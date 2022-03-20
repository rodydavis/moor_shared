# moor_shared

An example project to demonstrate how drift (formerly known as moor) can be used on multiple platforms
(Web, android, iOS, macOS, Windows and Linux).

- Undo/Redo
- Cross Platform

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### MacOS

![](/screenshots/macos.png)

### iPad

![](/screenshots/ipad.png)

### Windows

__Note__: On Linux and Windows, you need to ensure that the compiled native sqlite3 libraries
are available as a `.so` or a `.dll`, respectively.
The `sqlite3_flutter_libs` package only automates this process for Android, iOS and macOS.
For more information on how to setup drift on all platforms, see [this page](https://drift.simonbinder.eu/docs/platforms/).
As shown in [this commit](https://github.com/rodydavis/moor_shared/commit/32bf6823e2d260ea449c2c4ae37eab212f2e7939),
sqlite3 is bundled natively in this example.

![](/screenshots/windows.png)

### Web

__Note__: When launching the app in debug mode on Chrome, Flutter will use a
temporary user profile which doesn't persist data across debug sessions.
Release builds aren't affected by this.

![](/screenshots/web.png)
