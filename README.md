# Punches Lab — Website

Static website generated from [Ghost](https://ghost.org) and deployed to GitHub Pages.

---

## Stack

| Layer | Tool |
|---|---|
| CMS | Ghost (runs locally) |
| Export | `wget` crawler (`scripts/export.sh`) |
| Hosting | GitHub Pages (from `/docs`) |
| CI/CD | GitHub Actions (auto-deploys on push) |

---

## First-Time Setup

### 1. Install prerequisites

- [Node.js 18+](https://nodejs.org/)
- Git Bash (already installed with Git for Windows — provides `wget`)

### 2. Clone this repo and install dependencies

```bash
git clone https://github.com/YOUR_ORG/punches-lab.git
cd punches-lab
npm install
```

### 3. Install and start Ghost locally

```bash
npm run ghost:install   # one-time setup (downloads Ghost ~200MB)
npm run ghost:start
```

Ghost admin will be available at `http://localhost:2368/ghost`.
Create your admin account on first launch.

### 4. Configure your site URL

Edit `scripts/export.sh` and update the `SITE_URL` variable to match
the GitHub Pages URL you'll publish to (e.g. `https://punches-lab.github.io`).

---

## Daily Workflow

```
1. npm run ghost:start       # start Ghost locally
2. (write content in Ghost admin at http://localhost:2368/ghost)
3. npm run export            # generate static files into /docs
4. npm run preview           # optional: spot-check at http://localhost:4000
5. git add docs/ && git commit -m "content: update [description]"
6. git push                  # GitHub Actions deploys automatically
```

---

## GitHub Pages Configuration

In your GitHub repository settings:

1. **Settings → Pages → Source:** Deploy from a branch
2. **Branch:** `main` / `docs`
3. (Or use the GitHub Actions workflow in `.github/workflows/deploy.yml` for the modern Pages approach)

For the Actions-based deployment (recommended), set Pages source to
**"GitHub Actions"** instead of a branch.

---

## Repo Structure

```
punches-lab/
├── .github/
│   └── workflows/
│       └── deploy.yml      # Auto-deploy docs/ to GitHub Pages on push
├── docs/                   # Generated static site (committed, served by Pages)
│   └── index.html          # Placeholder until first Ghost export
├── ghost/                  # Ghost local install (gitignored)
│   └── .gitkeep
├── scripts/
│   └── export.sh           # Crawl Ghost → write docs/
├── .gitignore
├── package.json
└── README.md
```

---

## Adding Content

Once branding is finalized:

1. Choose or build a Ghost theme and place it in `ghost/content/themes/`
2. Activate it via Ghost admin
3. Write posts and pages in Ghost
4. Run `npm run export` to regenerate

---

## Accessibility

The placeholder page (`docs/index.html`) includes:
- Skip-to-content link
- Semantic HTML (`<header>`, `<main>`, `<footer>`, ARIA roles)
- System dark mode support
- Sufficient color contrast (WCAG AA)
- Responsive layout
