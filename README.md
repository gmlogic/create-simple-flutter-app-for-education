# Μαθηματικά για Παιδιά (Flutter)

Πολύχρωμη εκπαιδευτική εφαρμογή Flutter για μικρά παιδιά με 2 tabs.

## Tab 1: Προπαίδεια

- Εύκολο: 1–5
- Μεσαίο: 1–10
- Δύσκολο: απαιτητικές πράξεις μόνο με 6–9 (π.χ. 9×6, 8×7)
- Το παιδί γράφει την απάντηση σε πεδίο κειμένου ή πατά μικρόφωνο για φωνητική εισαγωγή.
- Μηνύματα: **Μπράβο!** / **Δοκίμασε ξανά**
- Bonus: με 5 σωστές συνεχόμενες εμφανίζεται ο επιλεγμένος ήρωας
- Επιλογή ήρωα bonus (π.χ. Spidey, Iron Man, Cap, Spider Tails)
- Οι ήρωες εμφανίζονται με τοπικές PNG εικόνες/avatars (χωρίς εξάρτηση από internet εικόνες)
- Στο repository δεν περιλαμβάνονται τα τελικά PNG αρχεία· βάλε τα δικά σου μέσα στο `assets/heroes/`
- Τα `assets/heroes/*.png` αγνοούνται από το git, ώστε να μη φαίνονται σε PR/diff ως binary files

## Tab 2: Αριθμητική για 4 ετών

- Επιλογή πράξης: **Πρόσθεση**, **Αφαίρεση** ή **Μικτά**
- Επιλογή επιπέδου: **Χαμηλό 1-5** ή **Κανονικό 0-10**
- Στο Χαμηλό επίπεδο, στην πρόσθεση αποφεύγεται το 0
- Οπτικά βοηθήματα με αστεράκια ⭐
- Το παιδί απαντά με πληκτρολόγηση ή φωνή
- Bonus: με 5 σωστές συνεχόμενες εμφανίζεται ο επιλεγμένος ήρωας
- Επιλογή ήρωα bonus (π.χ. Tails, Spidey, Iron Man, Spider Tails)
- Οι ήρωες εμφανίζονται με τοπικές PNG εικόνες/avatars (χωρίς εξάρτηση από internet εικόνες)
- Στο repository δεν περιλαμβάνονται τα τελικά PNG αρχεία· βάλε τα δικά σου μέσα στο `assets/heroes/`
- Τα `assets/heroes/*.png` αγνοούνται από το git, ώστε να μη φαίνονται σε PR/diff ως binary files

## Δομή αρχείων

- `lib/main.dart` → entry point
- `lib/app.dart` → MaterialApp + theme
- `lib/home_page.dart` → TabBar + TabBarView
- `lib/games/multiplication_game.dart` → tab προπαίδειας
- `lib/games/arithmetic_game.dart` → tab αριθμητικής
- `lib/widgets/difficulty_selector.dart` → επιλογή δυσκολίας προπαίδειας
- `lib/widgets/hero_selector.dart` → επιλογή bonus ήρωα
- `test/widget_test.dart` → basic widget test

## Τρέξιμο τώρα (γρήγορα)

### 1) Έλεγχος Flutter

```bash
flutter --version
```

Αν πάρεις `command not found`, εγκατάστησε Flutter από:
https://docs.flutter.dev/get-started/install

### 2) Πάρε dependencies

```bash
flutter pub get
```

### 3) Δες διαθέσιμες συσκευές

```bash
flutter devices
```

### 4) Τρέξε την εφαρμογή

```bash
flutter run
```

### 5) (Προαιρετικά) Τρέξιμο σε συγκεκριμένη συσκευή

```bash
flutter run -d <device_id>
```

## Tests

```bash
flutter test
```


## Τρέξιμο σε Chrome

```bash
flutter devices
flutter run -d chrome
```

Αν δεν εμφανίζεται το `chrome` στη λίστα:

1. Εγκατέστησε Chrome/Chromium στο σύστημα.
2. Όρισε μεταβλητή περιβάλλοντος (αν χρειάζεται):

```bash
export CHROME_EXECUTABLE=/path/to/chrome
```

3. Ξανατρέξε:

```bash
flutter doctor -v
flutter run -d chrome
```
