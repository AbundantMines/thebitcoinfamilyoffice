#!/bin/bash
# BFO Site Deploy Script
# Run from: /Users/beauturner/.openclaw/workspace/thebitcoinfamilyoffice/
# Or via: cd /Users/beauturner/.openclaw/workspace/thebitcoinfamilyoffice && bash _deploy.sh

set -e
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

echo "📦 Staging all changes..."
git add -A

echo "📝 Committing..."
git commit -m "SEO: schema markup, internal linking, OG images, robots.txt, canonical tags, premium design upgrades

- Added JSON-LD Organization schema to homepage
- Added Article + FAQ schema to all 5 blog posts (complete guide, building, estate planning, tax, custody)
- FAQ schemas extract real Q&A from post content (4-5 questions per post)
- Internal linking: every post now links to all 4 other pillar posts contextually
- Added og-image.png (1200x630, dark background, programmatically generated)
- robots.txt: verified correct with sitemap reference
- Canonical tags: verified on all 7 HTML pages
- html lang=en, charset, viewport: all pages ✓
- Copyright 2026: all pages ✓
- Sticky nav + reading progress bar: all blog posts ✓"

echo "🚀 Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Push complete. Pinging search engines..."
curl -s "https://www.google.com/ping?sitemap=https://thebitcoinfamilyoffice.com/sitemap.xml" && echo "Google pinged"
curl -s "https://www.bing.com/indexnow?url=https://thebitcoinfamilyoffice.com&key=thebitcoinfamilyoffice" && echo "IndexNow pinged"

echo ""
echo "🎉 All done! Site should update in ~2-5 minutes at thebitcoinfamilyoffice.com"
