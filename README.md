# create-simple-flutter-app-for-education

A simple educational Flutter starter app committed into this repository.

## Included

- `pubspec.yaml` with basic Flutter configuration.
- `lib/main.dart` with a small counter app suitable for teaching beginners.
- `test/widget_test.dart` with a starter widget test.
- Platform folders (`android`, `ios`, `web`, `linux`, `macos`, `windows`) with placeholder README files.

## Install Flutter

### Ubuntu / Debian (quick way)

```bash
sudo snap install flutter --classic
flutter --version
```

If `snap` is not available, use the official archive method from Flutter docs.

### macOS

```bash
brew install --cask flutter
flutter --version
```

### Windows

1. Download Flutter SDK zip from the official Flutter site.
2. Extract it (for example to `C:\src\flutter`).
3. Add `C:\src\flutter\bin` to your PATH.
4. Open new PowerShell and run:

```powershell
flutter --version
```

## Project setup

After Flutter is installed:

```bash
flutter doctor
flutter pub get
flutter create .
flutter run
```

> `flutter create .` generates the full native scaffolding for Android/iOS/web/desktop.

## Run tests

```bash
flutter test
```

## Run deterministic tests with Docker

Use the included `Dockerfile` to run tests with a pinned Flutter version (`3.24.5`) everywhere.

```bash
docker build -t flutter-edu-test .
docker run --rm flutter-edu-test
```

If you also want to run commands interactively:

```bash
docker run --rm -it -v "$PWD":/app -w /app flutter-edu-test bash
flutter pub get
flutter test
```

