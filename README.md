# HyperFrames Skill Kit

Video / motion / presentation skills for AI agents — extracted from the source repos, **no Electron app required**.

- **Origin:** `heygen-com/hyperframes` (Apache-2.0), `nexu-io/open-design` (bundled catalog), `emilkowalski/skills` (MIT), `slidevjs/slidev` (MIT)
- **Copied from:** `~/.config/opencode/skills/` (installed globally, live in OpenCode right now)
- **Count:** 134 skills, 32 MB
- **License:** free/open-source. The **skills** are free. Some *providers* they call (fal.ai, venice.ai, Sora, HeyGen TTS) need a paid API key — see "Needs a key" below.
- **Windows?** Same folder, same skills. Use `install-to-agent.ps1` and read **WINDOWS.md** — the toolchain is
  *easier* on Windows (no macOS 12 Chrome ceiling, FFmpeg via winget).

---

## Clone this kit

```bash
gh repo clone ChromeGenesis/hyperframes-skills                      # with the GitHub CLI
git clone https://github.com/ChromeGenesis/hyperframes-skills.git   # needs a PAT as the password
```

**Private repo** — on a fresh machine you need credentials first:

```bash
gh auth login                       # GitHub CLI: browser login, then `gh repo clone ...` just works
# or with a personal access token (scope: repo):
git clone https://<TOKEN>@github.com/ChromeGenesis/hyperframes-skills.git
```

Windows: `winget install GitHub.cli` then `gh auth login` then `gh repo clone ChromeGenesis/hyperframes-skills`.

---

```bash
./install-to-agent.sh opencode      # -> ~/.config/opencode/skills
./install-to-agent.sh claude        # -> ~/.claude/skills
./install-to-agent.sh agents         # -> ~/.agents/skills
./install-to-agent.sh project        # -> ./.opencode/skills (current dir)
```

On Windows:

```powershell
powershell -ExecutionPolicy Bypass -File install-to-agent.ps1 opencode
powershell -ExecutionPolicy Bypass -File install-to-agent.ps1 claude
powershell -ExecutionPolicy Bypass -File install-to-agent.ps1 agents
powershell -ExecutionPolicy Bypass -File install-to-agent.ps1 project
```

Or point an agent at this folder directly (OpenCode `opencode.json`):

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "skills": ["/Users/o2cfx/Desktop/Genesis/Hyperframes/skills"]
}
```

Skill IDs are the folder names. Load one explicitly with `@skill-id` or the `skill` tool.

---

## The 20 skills that matter most for "make me a nice video"

| Skill | What it does for you |
|---|---|
| `hyperframes` | **Mandatory entry point.** Any video/animation request routes through here first. |
| `hyperframes-core` | The composition contract — how to write the HTML that renders. |
| `hyperframes-cli` | The dev loop: `init`, `lint`, `check`, `preview`, `render`, `capture`, `catalog`, `add`. |
| `hyperframes-animation` | Atomic motion rules, scene blueprints, transitions, GSAP/Lottie/Three/WAAPI adapters. |
| `hyperframes-creative` | Palette, type, pacing, narration, brand direction. |
| `hyperframes-keyframes` | Punch-ins, zooms, reframes, Ken Burns, camera moves, seek-safe 2D/3D keys. |
| `hyperframes-registry` | ~400 ready-made blocks (CRT, glitch, grain, charts, confetti…) — search before hand-building. |
| `motion-graphics` | Short design-led motion: kinetic type, stat count-ups, logo stings, lower thirds. |
| `general-video` | Multi-scene / long-form / montage / title cards. |
| `faceless-explainer` | Article or notes -> narrated explainer with invented visuals. |
| `product-launch-video` | URL/script -> product promo. |
| `slideshow` | Interactive decks: fragments, branching, presenter mode. |
| `media-use` | BGM, SFX, images, logos, VO, captions, background removal. |
| `embedded-captions` | Kinetic/cinematic captions on existing footage (35-style catalog). |
| `talking-head-recut` | Graphic overlay cards on an interview/podcast clip. |
| `music-to-video` | Track -> beat-synced video. |
| `figma` | Figma file/URL -> video composition (see TOOLS.md for what it's actually for). |
| `remotion` | React-based video, if you'd rather not use HTML. |
| `animate` | Emil's decision framework for motion: should it animate, with what curve, for how long. |
| `motion-lab` | 160 motion-effect case library (HTML/CSS/JS + params, CN/EN index). |

---

## The rest of the kit, by family

**Motion / animation (web):** `animate`, `animation-vocabulary` (name any effect), `animation-performance` (60fps on a weak CPU), `review-animations`, `improve-animations`, `find-animation-opportunities`, `break-ui` (stress-test UI with worst-case data), `emil-design-eng`, `emilkowalski-motion`, `ui-animation`, `motion-design`, `motion-lab`, `oil-motion`, `huashu-art-motion`, `emilkowalski-motion`, `stitch-loop`.

**GSAP (official, 8 skills):** `gsap-core`, `gsap-timeline`, `gsap-scrolltrigger`, `gsap-performance`, `gsap-plugins`, `gsap-react`, `gsap-frameworks`, `gsap-utils`.

**Ready-made video frames (drop-in):** `frame-glitch-title`, `frame-light-leak-cinema`, `frame-liquid-bg-hero` (WebGL fluid), `frame-logo-outro`, `frame-macos-notification`, `frame-data-chart-nyt`, `frame-flowchart-sticky`, `vfx-text-cursor`, `chat-motion-overlay` (chat bubbles for TikTok/Douyin).

**The other renderer (optional):** `fframes-video` — a completely separate Rust+SVG+Skia pipeline. Not a HyperFrames
plugin; use it *instead of* HyperFrames for a project when render speed matters more than the HTML ecosystem. Its
official one-liner is `npx skills add https://fframes.studio`.

**Video templates:** `8-bit-orbit-video-template`, `after-hours-editorial-template` (luxury dark editorial), `swiss-user-research-video-template`, `weread-year-in-review-video-template` (9:16 reading report), `article-magazine`, `html-ppt-retro-quarterly-review`.

**Social / cards:** `card-twitter`, `social-x-post-card`, `social-reddit-card`, `social-spotify-card`, `card-xiaohongshu`, `poster-hero`, `mockup-device-3d`, `gif-sticker-maker`, `slack-gif-creator`, `screenshots-marketing`, `ad-creative`, `marketing-psychology`, `copywriting`.

**Presentations:** `slidev` (Markdown decks), `frontend-slides`, `slides`, `deck-open-slide-canvas`, `deck-swiss-international`, `deck-guizang-editorial`, `ppt-keynote`, `nanobanana-ppt`, `pptx-generator`, `pptx`, `pptx-html-fidelity-audit`, `swiss-creative-mode-template`, `editorial-burgundy-principles-template`, `data-report`.

**Design quality (makes the output look expensive):** `design-md`, `design-review`, `design-brief`, `design-consultation`, `impeccable-design-polish`, `taste-skill` (anti-slop), `gpt-tasteskill`, `creative-director`.

**3D / shaders:** `threejs`, `shader-dev`.

**HeyGen house-style (opinionated, from the HyperFrames repo):** `motion-doctrine`, `cut-the-curve`, `seam-craft`, `oversized-cursor`, `captions-overlay`, `changelog-video`. These enforce a specific look — `motion-doctrine` says its rules *supersede* generic motion guidance. Read before using if you don't want that house style.

**Registry blocks (local, 7):** `hf-blocks/orbit-card`, `glass-shard-title`, `cuboid-carousel`, `code-slice-hero`, `frost-sequence-camera-orbit`, `wireframe-portal-title`, `canopy-part-title`. Self-contained HTML + assets; copy straight into a composition.

**Needs a paid API key** (installed but hidden from the auto-advertised list via `metadata.opencode/autoinvoke: false` — load explicitly with `@fal-video-edit` etc.): `fal-video-edit`, `fal-kling-o3`, `fal-lip-sync`, `fal-upscale`, `fal-generate`, `fal-image-edit`, `fal-3d`, `fal-vision`, `fal-restore`, `venice-video`, `venice-image-generate`, `venice-image-edit`, `venice-audio-speech`, `venice-audio-music`, `imagegen`, `imagen`, `replicate`, `sora`, `speech` (OpenAI), `youtube-clipper`, `video-downloader`.

---

## Notes

- `hf-blocks/*` are nested one level deep on purpose — OpenCode derives the skill ID from the folder holding `SKILL.md`, so `hf-blocks/orbit-card/SKILL.md` registers as `orbit-card`.
- The `metadata: internal: true` you may see in the HeyGen house-style skills is Claude Code metadata; OpenCode ignores it.
- Update procedure: the source clones are `~/hyperframes-src` (HeyGen) and `~/open-design-src` (OpenDesign). `git pull` in each, re-copy the `skills/` dirs, and re-run the install script.
