# Contributing to NexUSB

Thanks for your interest in contributing!

## How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test the build process
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Adding New Tools

To add a new tool to NexUSB:

1. Add the tool to `config/tools.conf` with format:
   ```
   CATEGORY|TOOL_NAME|PACKAGE_NAME|DESCRIPTION
   ```

2. If the tool needs a menu entry, add it to the appropriate menu script in `autorun/`

3. Test the build to ensure the tool installs correctly

## Theme Customization

Theme files are in `theme/nexus/`. To customize:

- Edit `theme.txt` for layout and colors
- Replace image files (background.png, logo.png, etc.)
- Modify `grub.cfg` for boot menu entries

## Code Style

- Use 4 spaces for indentation in shell scripts
- Add comments for complex operations
- Test all scripts before submitting

## Reporting Issues

Please include:
- Your build environment (OS, version)
- Steps to reproduce
- Expected vs actual behavior
- Build logs if applicable
