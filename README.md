## Shopping List App
Simple shopping list app built with Flutter to showcase slivers, BLoC state management, real-time totals, and audio feedback.

## Setup
- Fetch packages: `flutter pub get`
- Run: `flutter run` (iOS/Android/web/desktop)

## App Details
- Sliver-based home screen with a collapsible "Shopping List" app bar and a pinned total header.
- Grocery list (10 items) with selectable rows, animated highlighting, and price chips.
- Live currency total and selected count that updates instantly on toggle.
- Audio cues for select/deselect (short WAV assets in `assets/audio`).

## State Management
- BLoC via `flutter_bloc` (using a  Cubit) for predictable updates that stay easy to extend.
- `ShoppingCubit` owns items as well as selected IDs. The UI rebuilds via `BlocBuilder`. `ShoppingItemTile` focuses on display and taps.

## Decisions & Notes
- Custom sliver layout keeps the total header pinned while the list scrolls with bounce physics.
- Number formatting via `intl` for consistent currency display.
