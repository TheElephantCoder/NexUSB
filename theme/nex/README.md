# NexusUSB Theme Assets

Place the following image files in this directory:

- `background.png` - 1920x1080 background (blue/black gradient)
- `logo.png` - 400x80 NexusUSB logo
- `select_c.png` - Center part of selection highlight
- `select_e.png` - East (right) edge of selection
- `select_w.png` - West (left) edge of selection

## Creating the Background

Use a dark blue (#001a33) to black (#000000) gradient.
Recommended tool: GIMP or ImageMagick

Example with ImageMagick:
```bash
convert -size 1920x1080 gradient:'#001a33-#000000' background.png
```

## Creating Selection Highlights

Create 32px height PNG files with blue (#0066cc) gradient and slight transparency.
