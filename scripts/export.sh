#!/usr/bin/env bash
# export.sh — Crawl local Ghost and generate static files into /docs
#
# Prerequisites:
#   - Ghost is running locally (npm run ghost:start)
#   - wget is installed (Git Bash includes wget; on macOS: brew install wget)
#   - Update SITE_URL below to match your published GitHub Pages URL once known

GHOST_URL="http://127.0.0.1:2368"
SITE_URL="https://YOUR_ORG.github.io"   # ← update this before first deploy
OUTPUT_DIR="docs"

echo "Cleaning previous export..."
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

echo "Crawling Ghost at $GHOST_URL ..."
wget \
  --recursive \
  --convert-links \
  --page-requisites \
  --no-verbose \
  --no-host-directories \
  --directory-prefix="$OUTPUT_DIR" \
  --restrict-file-names=unix \
  --span-hosts \
  --domains="127.0.0.1,fonts.googleapis.com,fonts.gstatic.com,code.jquery.com" \
  "$GHOST_URL"

echo "Rewriting internal URLs: $GHOST_URL → $SITE_URL"
find "$OUTPUT_DIR" -name "*.html" -type f \
  -exec sed -i "s#$GHOST_URL#$SITE_URL#g" {} \;

echo "Done. Preview with: npm run preview"
echo "Commit docs/ and push to deploy."
