# Toolchain — versions compatible with THIS machine

**Host:** MacBook Pro 13" (2015) · Intel i5-5257U (Broadwell, 2 cores / 4 threads) · 8 GB RAM · Intel Iris 6100 · **macOS 12.7.6 Monterey** · x86_64 · 77 GB free

**Hard constraints found in the source code (not guesses):**

- `packages/engine/src/services/chromeHostCeiling.ts` — *"Chrome 151 dropped macOS 12 and older (Darwin < 22); 150 is the last major that launches there."* The CLI therefore auto-installs **chrome-headless-shell 150.0.7871.124** instead of its default pin (152.0.7977.30) on this OS. If you ever force 152, it dies at launch with `dyld: Symbol not found: _kVTCompressionPropertyKey_ReferenceBufferCount` (a macOS 13+ VideoToolbox symbol). That exact crash is handled in `packages/cli/src/browser/macosOldChromeCrash.ts`.
- **Homebrew dropped macOS 12 in 4.4.0** (Oct 2024) and now treats all Intel Macs as Tier 3 with no new bottles. So the CLI's own advice — `brew install ffmpeg` — would trigger a source build that will likely fail here. Homebrew's own guidance for Intel + older macOS is MacPorts; the static-build route below is faster and safer.
- `hyperframes` CLI `engines: { node: ">=22" }`; `puppeteer` needs `>=22.12`.

---

## Decision table

| # | Tool | Version to use | Why this version | Size | Call |
|---|---|---|---|---|---|
| 1 | Node.js | **24.22.0** (installed) · floor **22.12** | CLI needs `>=22`; puppeteer needs `>=22.12` | — | ✅ have it |
| 2 | `hyperframes` (npm CLI) | **0.8.177** | The render/authoring engine. Public npm name is `hyperframes` — **`@hyperframes/cli` is 404**. Apache-2.0, free | ~22 MB + deps | ✅ get |
| 3 | Chrome Headless Shell | **150.0.7871.124** mac-x64 | 151+ needs macOS 13+. CLI auto-picks 150 here. Never install 152 | ~200 MB | ✅ get (auto) |
| 4 | FFmpeg | **8.0.1** static (evermeet.cx, Intel) | Needs `libx264`. 8.0.x is the branch the CLI's version parsing targets; 9.0.2 is newer but untested against it | ~40 MB | ✅ get |
| 5 | FFprobe | **8.0.1** (same source) | Must match ffmpeg | ~40 MB | ✅ get |
| 6 | unzip | present ✔ | Chrome extraction | — | ✅ keep |
| 7 | Python 3 | **3.12** (via `uv`) | You have 3.14.8; `librosa`/`numpy` wheels for 3.14 are thin. Only for `music-to-video` beat analysis | ~50 MB | ⚪ optional |
| 8 | librosa / numpy / soundfile | latest | Beat-grid analyzer only | ~60 MB | ⚪ optional |
| 9 | `uv` | latest | Isolated Python envs; works on Intel + macOS 12 | ~30 MB | ⚪ optional |
| 10 | Xcode CLT | present ✔ | Required for whisper.cpp build | — | ✅ keep |
| 11 | cmake | missing | Only for local whisper.cpp ASR | — | ❌ skip |
| 12 | Parakeet ASR model | — | ~640 MB; runs on Intel but 8 GB RAM is tight | 640 MB | ❌ skip |
| 13 | `heygen` CLI | latest (developers.heygen.com/cli) | BGM catalog + TTS + avatar. OAuth = free allowance; API key = billed. SFX via Openverse needs no account | small | ⚪ optional |
| 14 | Docker | missing | Only for `--docker` render fallback; a VM on 8 GB is painful | GBs | ❌ skip |
| 15 | OpenDesign desktop app | 400 MB Electron | The thing this kit replaces | 400 MB | ❌ skip |

**Cost:** rows 1–12 are free and run locally. Paid things are optional providers (fal.ai / venice.ai / Sora / OpenAI speech / HeyGen TTS-avatar) and cloud rendering. Plain MP4 output needs none of them.

---

## Install commands (not yet run — awaiting your call)

```bash
# 2. HyperFrames CLI (global beats npx on this CPU; npx re-resolves every call)
npm install -g hyperframes@0.8.177

# 3. Chrome Headless Shell 150 for macOS 12 (the CLI does this for you)
npx hyperframes browser ensure
npx hyperframes browser path        # prints the binary it picked

# 4 + 5. Static FFmpeg 8.0.1 for Intel/macOS 12 (no Homebrew, no build)
mkdir -p ~/.local/bin && cd /tmp
curl -LO https://evermeet.cx/ffmpeg/ffmpeg-8.0.1.zip
curl -LO https://evermeet.cx/ffmpeg/ffprobe-8.0.1.zip
unzip -o ffmpeg-8.0.1.zip && unzip -o ffprobe-8.0.1.zip
xattr -dr com.apple.quarantine ffmpeg ffprobe   # if Gatekeeper complains
mv ffmpeg ffprobe ~/.local/bin/
export PATH="$HOME/.local/bin:$PATH"             # add to ~/.zshrc
ffmpeg -version                                  # expect 8.0.1

# optional: Python env for music-to-video
uv python install 3.12
uv venv ~/.venvs/hf && VIRTUAL_ENV=~/.venvs/hf uv pip install librosa numpy soundfile
```

`~/.local/bin` is already ahead of `/usr/bin` here (your `node` and `python3` live there), so ffmpeg lands on PATH automatically.

---

## After install — sanity check

```bash
npx hyperframes doctor      # reports node, ffmpeg, chrome, versions
npx hyperframes init demo   # scaffold a blank project
npx hyperframes render --quality draft --output demo.mp4
```

## Performance expectations on this hardware

Rendering is CPU-bound frame capture + software H.264. On this i5, expect **minutes, not seconds**, for a 1080×1920 / 30 fps clip. Practical mitigations, from the repo's own `docs/guides/performance.mdx`:

- Iterate with `--quality draft`; deliver with `standard`/`high`.
- Keep `backdrop-filter` and large `filter: blur()` layers minimal — they are the #1 capture cost.
- Size images near delivery dimensions (a 4K source for a 1080p composition only costs decode time).
- Avoid animating dozens of shadowed elements at once.
- Prefer 1080×1920 (9:16) or 1080×1080 for TikTok/X over 4K — the repo has a 4K guide, but it is not this machine.
