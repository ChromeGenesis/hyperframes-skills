# Windows setup

Same 134 skills, same kit — the folders are cross-platform. Only the **toolchain** differs, and on Windows it is
*easier* than on the Mac: no macOS 12 ceiling, and Homebrew's absence doesn't matter because FFmpeg ships through
winget.

**Assumption:** Windows 10/11 x64. (Chrome Headless Shell 152 needs Win10+; on Win7 nothing modern works.)

---

## 1. Clone and install the skills into your agent

On the Windows PC:

```powershell
# 1. install the GitHub CLI and sign in (private repo)
winget install GitHub.cli
gh auth login
gh repo clone ChromeGenesis/hyperframes-skills
cd hyperframes-skills
```

If you'd rather not install `gh`, use a personal access token (scope `repo`):

```powershell
git clone https://<TOKEN>@github.com/ChromeGenesis/hyperframes-skills.git
cd hyperframes-skills
```

Then pick your agent and run the installer from the cloned folder:

```powershell
# pick your agent
powershell -ExecutionPolicy Bypass -File install-to-agent.ps1 opencode   # -> %USERPROFILE%\.config\opencode\skills
powershell -ExecutionPolicy Bypass -File install-to-agent.ps1 claude     # -> %USERPROFILE%\.claude\skills
powershell -ExecutionPolicy Bypass -File install-to-agent.ps1 agents     # -> %USERPROFILE%\.agents\skills
powershell -ExecutionPolicy Bypass -File install-to-agent.ps1 project    # -> .\.opencode\skills (current folder)
```

`opencode` on Windows uses `%USERPROFILE%\.config\opencode` for its config and skills, same layout as macOS.

If your terminal blocks the script, use `powershell -ExecutionPolicy Bypass -File ...` (above) or
`Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` once.

---

## 2. The toolchain

| # | Tool | Version | How | Notes |
|---|---|---|---|---|
| 1 | Node.js | **22.12+** (LTS 22 or 24) | `winget install OpenJS.NodeJS.LTS` | Hard requirement: the HyperFrames CLI declares `node >=22` |
| 2 | `hyperframes` (npm CLI) | **0.8.177** | `npm install -g hyperframes@0.8.177` | Public npm name is `hyperframes` — `@hyperframes/cli` is 404. Free, Apache-2.0 |
| 3 | Chrome Headless Shell | **152.0.7977.30** | `npx hyperframes browser ensure` | Windows has **no version ceiling** (the 150 cap is macOS-12-only), so you get the current pin. Falls back to an installed Google Chrome |
| 4 | FFmpeg + ffprobe | **latest stable** | `winget install --id Gyan.FFmpeg -e` | This is the exact command the HyperFrames CLI itself suggests on Windows. Gyan's build includes `libx264` and `ffprobe` |
| 5 | Python 3 | **3.12** | `winget install Python.Python.3.12` | Only for `music-to-video` beat analysis and a few caption scripts |
| 6 | librosa / numpy / soundfile | latest | `pip install librosa numpy soundfile` | Only if you use `music-to-video` |

**After the winget installs, open a NEW terminal** so the refreshed PATH is picked up.

No Docker, no Rust, no build tools needed for the HyperFrames path.

---

## 3. Sanity check

```powershell
node -v
ffmpeg -version
npx hyperframes doctor
npx hyperframes init demo
cd demo
npx hyperframes render --quality draft --output demo.mp4
```

`doctor` reports node, ffmpeg and Chrome versions plus anything missing.

---

## 4. What differs from the Mac

| | Windows | macOS 12 (the Mac) |
|---|---|---|
| Chrome Headless Shell | 152.0.7977.30 (current) | **150.0.7871.124** — 151+ dropped macOS 12 |
| FFmpeg install | `winget install --id Gyan.FFmpeg -e` | static build from evermeet.cx — **Homebrew dropped macOS 12** |
| Render speed | M-series/desktop GPU → fast | Iris 6100 software raster → **minutes per 15s clip** |
| Bash scripts (`.sh` in `embedded-captions`, `remotion-to-hyperframes`) | need Git Bash or WSL2 | native |
| `fframes-video` skill (Rust) | possible: needs Rust + LLVM + a prebuilt FFmpeg 9 shared build (BtbN) — see the skill's Windows section | possible but needs Homebrew for nasm/ninja → **risky on macOS 12** |

**If you can only work on one machine: work on the Windows PC.** The Mac's macOS 12 ceiling costs you the current
Chrome and forces a hand-installed FFmpeg, and its renders are the slow path in the pipeline.

---

## 5. Windows-only notes

- **Long paths:** if extraction fails on deeply nested skill folders, enable long paths in the registry:
  `reg add HKLM\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled /t REG_DWORD /d 1 /f`
- **Antivirus:** Defender's real-time scan can slow Chrome frame capture noticeably during `render`. Excluding the
  project folder is usually faster than the virus.
- **Chrome + GPU:** headless capture on Windows uses SwiftShader by default. If a scene renders black or with
  missing effects, try `npx hyperframes render --browser-gpu auto` (or `hardware`) — desktop NVIDIA/AMD/Intel
  GPUs handle it fine.
- **Drive type:** put project folders on an SSD. Rendering writes many frame files; a spinning disk turns a
  30-second render into a 5-minute one.
