# Module 5 - Activity 5 - HAUDEX app (Flutter capstone)

[![Made with Claude](https://img.shields.io/badge/Made_with-Claude-D97757?logo=anthropic&logoColor=white)](https://tjakoen.github.io/notes/ten-times-zero)
![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)

The finale. Put the whole course together into one small, complete app: a
HAUDEX you can browse, add to, and battle in.

## Build this

Starting from `lib/dex_app.dart` (and splitting into more files as you go),
build an app that:

- starts by showing the seed monsters (`lib/seed.dart`) in a scrollable list,
- has a **FloatingActionButton** that opens a form (dialog or screen) with a
  `TextField` to **add** a monster - adding it grows the list,
- lets you **tap** a monster to open a **detail** screen (`Navigator.push`) that
  shows the type keyed `Key('detailType')`, the current HP keyed `Key('hp')`,
  and an **Attack** button that lowers that monster's HP with `setState`
  (never below 0).

Then make it feel real: consistent styling, a smooth add flow, and a detail
screen with battle feedback (an HP bar, a fainted state). Split it into small,
well-named widgets and files.

## How it is graded

100 points: **40 automated** (the interactions above) + **60 design/UX** (from a
phone-framed screenshot and your code - visual consistency, the list, the add
flow, the detail/battle feel, phone layout, and code organization). See
`RUBRIC.md`.

## Run and check

```bash
flutter pub get
flutter run
flutter test
```

## Submit

Fill in `student.json`, commit, and push.
