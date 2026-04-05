# Punches Lab — Website

Static website for Dr. Brittany Punches' research lab and the HealthNow program.
Deployed to GitHub Pages via GitHub Actions.

**Live site:** https://punches-lab.github.io

---

## Stack

| Layer | Tool |
|---|---|
| Static site | Hand-built HTML/CSS (7 pages, in `docs/`) |
| Optional CMS | Ghost (runs locally, exports to `docs/`) |
| Hosting | GitHub Pages (serves `docs/`) |
| CI/CD | GitHub Actions (auto-deploys on `git push`) |

> **You don't need Ghost to update the site.** The HTML files in `docs/` can be edited directly.
> Ghost is only needed if you want a visual admin interface for writing content.

---

## Quick Start — Direct HTML Editing (no Ghost needed)

This is the fastest way to update content.

```bash
# 1. You're already in the project folder — just open the file you want:
#    docs/index.html         → homepage
#    docs/research/index.html → research page
#    docs/about/index.html   → about page
#    ... etc.

# 2. Edit the HTML, save, then preview locally:
npx serve docs -l 4000
# Open http://localhost:4000 in your browser

# 3. Deploy when happy:
git add docs/
git commit -m "content: describe what you changed"
git push
# GitHub Actions picks it up automatically — live in ~20 seconds
```

---

## Ghost CMS Setup (optional — for visual content editing)

Use this if you want to write posts/pages through a browser-based editor instead of editing HTML directly.

### Prerequisites

1. **Node.js 18+** — check with `node --version`. Download at https://nodejs.org if needed.
2. **Git Bash** — already installed if you have Git for Windows. Open it from Start menu.

### Step 1 — Install dependencies

Open Git Bash, navigate to this project folder, and run:

```bash
cd /c/Users/david/Claude/PROJECTS/Punches-Lab
npm install
```

This installs `ghost-cli` locally. Takes ~1 minute.

### Step 2 — Install Ghost

```bash
npm run ghost:install
```

This runs `ghost install local` inside the `ghost/` subfolder. It downloads Ghost (~200MB) and sets up a local SQLite database. **One-time only — takes 2–5 minutes.**

If it asks for your system password or errors on MySQL, that's fine — Ghost local mode uses SQLite, not MySQL. The install script uses `--no-setup-linux-user` to skip that.

### Step 3 — Start Ghost

```bash
npm run ghost:start
```

Then open **http://localhost:2368/ghost** in your browser.

On first launch, you'll be prompted to create an admin account — use any email/password, this is local only.

### Step 4 — Write content

In the Ghost admin:
- **Pages** → for site pages (About, Research, etc.)
- **Posts** → for news/blog entries
- **Settings → Design** → to manage your theme

### Step 5 — Export to static files

When you're ready to publish:

```bash
npm run export
```

This runs `scripts/export.sh`, which:
1. Crawls your local Ghost site with `wget`
2. Writes all HTML/CSS/JS into `docs/`
3. Rewrites internal URLs to match the live GitHub Pages domain

Then commit and push as normal:

```bash
git add docs/
git commit -m "content: [describe changes]"
git push
```

### Starting and stopping Ghost day-to-day

```bash
npm run ghost:start   # start
npm run ghost:stop    # stop (frees up port 2368)
```

Ghost must be running at `http://localhost:2368` before you run `npm run export`.

### Troubleshooting Ghost

**`ghost start` fails with "Ghost is already running"**
```bash
npm run ghost:stop
npm run ghost:start
```

**Port 2368 already in use**
```bash
# Find what's using it:
netstat -ano | findstr :2368
# Kill the process (replace PID with the number from above):
taskkill /PID [PID] /F
```

**Ghost install errors on Windows**
Ghost CLI has occasional issues on Windows. If `npm run ghost:install` fails:
```bash
# Try running ghost-cli directly with verbose output:
./node_modules/.bin/ghost install local --dir ghost --no-setup-linux-user --verbose
```

**`wget` not found during export**
`wget` comes with Git Bash. Make sure you're running `npm run export` from Git Bash, not PowerShell or CMD.

---

## Daily Workflow (with Ghost)

```
1. npm run ghost:start       → Ghost admin at http://localhost:2368/ghost
2. Write/edit content in the admin UI
3. npm run export            → regenerates docs/ from Ghost
4. npx serve docs -l 4000   → preview at http://localhost:4000 (optional)
5. git add docs/ && git commit -m "content: ..."
6. git push                  → live in ~20 seconds
```

---

## Repo Structure

```
Punches-Lab/
├── .github/
│   └── workflows/
│       └── deploy.yml        # GitHub Actions: deploys docs/ on push to main
├── docs/                     # The actual website (committed, served by GitHub Pages)
│   ├── .nojekyll             # Prevents GitHub's Jekyll builder from interfering
│   ├── assets/
│   │   ├── style.css         # All CSS — design system, components, dark mode
│   │   └── nav.js            # Mobile navigation toggle
│   ├── index.html            # Homepage
│   ├── about/index.html
│   ├── research/index.html
│   ├── healthnow/index.html
│   ├── education/index.html
│   ├── news/index.html
│   └── contact/index.html
├── ghost/                    # Ghost local install (gitignored — not deployed)
│   └── .gitkeep
├── inputs/                   # Source content docs (not deployed)
├── scripts/
│   └── export.sh             # wget crawler: Ghost → docs/
├── .gitignore
├── package.json
├── CLAUDE.md                 # Technical context for Claude Code sessions
└── README.md
```

---

## GitHub Pages — How Deployment Works

1. You push to `main` with changes inside `docs/`
2. `.github/workflows/deploy.yml` triggers automatically
3. It uploads the `docs/` folder as a GitHub Pages artifact
4. GitHub Pages serves that artifact at https://punches-lab.github.io
5. Done in ~20 seconds

**The `.nojekyll` file** in `docs/` is important — without it, GitHub's legacy Jekyll builder can run after our workflow and overwrite the deployment with a plain README page.

To check deployment status:
```bash
gh run list --repo Punches-Lab/punches-lab.github.io --limit 3
```

---

## Pending Content (as of April 2026)

- [ ] Model Pain R01 — add grant number, dates, full title, and objective to `research/index.html`
- [ ] Dr. Brent Emerson — confirm title and testimonial attribution in `education/index.html`
- [ ] Dr. Punches' headshot — add photo to `docs/` and replace placeholder in `about/index.html`
- [ ] HealthNow contact — add Natalie Taul's direct contact to `contact/index.html`
- [ ] Custom domain — currently `punches-lab.github.io`; update `scripts/export.sh` SITE_URL if this changes
