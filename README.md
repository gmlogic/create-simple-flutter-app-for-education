# create-simple-flutter-app-for-education

A simple educational Flutter starter app focused on practicing multiplication (προπαίδεια).

## Included

- `pubspec.yaml` with basic Flutter configuration.
- `lib/main.dart` with two learning tabs: multiplication with difficulty levels and age-4 friendly addition practice.
- `test/widget_test.dart` with a starter widget test.
- Platform folders (`android`, `ios`, `web`, `linux`, `macos`, `windows`) with placeholder README files.


## Τι κάνει η εφαρμογή

- Έχει 2 tabs: **Πολλαπλασιασμός** και **Ηλικία 4+**.
- Στο tab πολλαπλασιασμού υπάρχει επίπεδο δυσκολίας (**Εύκολο / Μεσαίο / Δύσκολο**).
- Οι πράξεις ανακατεύονται και δεν επαναλαμβάνονται αμέσως η μία μετά την άλλη.
- Στο tab **Ηλικία 4+** υπάρχουν απλές προσθέσεις με αστεράκια και έτοιμες επιλογές απάντησης.

## Πώς το τρέχω τώρα; (γρήγορα)

Από το root του project:

```bash
flutter pub get
flutter create .
flutter run -d chrome
```

Αν θες να το ανοίξεις σε άλλη συσκευή:

```bash
flutter devices
flutter run -d <device_id>
```

## How to run it (quick start)

From the project root:

```bash
flutter --version
flutter pub get
flutter create .
flutter run -d chrome
```

- `flutter create .` creates the missing platform scaffolding files.
- `flutter run -d chrome` starts the app in your browser.
- If you have only one device available, `flutter run` is enough.

## Install Flutter

### Linux (Ubuntu/Debian) — if `snap` exists

```bash
sudo snap install flutter --classic
flutter --version
```

### Linux (Ubuntu/Debian) — if `snap: command not found`

Use the helper script from this repo (installs pinned Flutter `3.24.5`):

```bash
./scripts/install_flutter_linux.sh
source ~/.bashrc
flutter --version
```

Manual alternative (official SDK archive):

```bash
cd "$HOME"
curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz
tar xf flutter_linux_3.24.5-stable.tar.xz
export PATH="$HOME/flutter/bin:$PATH"
flutter --version
```

To make PATH permanent:

```bash
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

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
```

## Run app

```bash
flutter run -d chrome
```

Other common targets:

```bash
flutter run -d android
flutter run -d windows
flutter run -d linux
flutter run -d macos
```

To see available devices:

```bash
flutter devices
```

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
