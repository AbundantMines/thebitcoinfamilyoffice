# OG Image PNG Conversion

The OG image exists as a high-quality SVG at `assets/og-image.svg`.

To convert to PNG (1200x630) for full social media compatibility, run ONE of the following:

## Option 1: Using Inkscape (macOS/Linux)
```bash
inkscape --export-type=png --export-width=1200 --export-height=630 \
  --export-filename=assets/og-image.png assets/og-image.svg
```

## Option 2: Using ImageMagick (macOS: `brew install imagemagick`)
```bash
convert -background "#0a0a0a" -resize 1200x630 assets/og-image.svg assets/og-image.png
```

## Option 3: Using rsvg-convert (macOS: `brew install librsvg`)
```bash
rsvg-convert -w 1200 -h 630 assets/og-image.svg -o assets/og-image.png
```

## Option 4: Node.js (if sharp is available)
```bash
npm install -g sharp-cli
sharp -i assets/og-image.svg -o assets/og-image.png resize 1200 630
```

## Online (quickest)
1. Visit https://svgtopng.com or https://convertio.co/svg-png/
2. Upload assets/og-image.svg
3. Set size to 1200x630
4. Download and save as assets/og-image.png

After generating, run: `git add assets/og-image.png && git commit -m "Add OG image PNG"` and push.
