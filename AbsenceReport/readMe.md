Developed by:

Xcode version - 26.0.1
Minimum deployment target - 18.6

**TESTING**

*UNIT TESTS*

- AbsenceDecodingTests — parsing the real API payload, covering the date format, end-date derivation, unknown absence types, and malformed data.
- `AbsenceListViewModelTests` — state transitions, sorting, and conflict handling, using a mock service.

**UI tests**

- AbsenceReportUITests — launch the app with a `-uiTesting` argument, which swaps in a stub service so the tests run deterministically without network access. They cover the list populating on launch, sorting reordering the rows, and the conflict badge appearing.

# Features implemented

1. Include a visual indication that an absence has conflicts, using the conflict endpoint.
2. Allow the list to be sorted by dates, absence type, and name.
3. When an employee's name is tapped, show all of their absences.

# Architecture

MVVM with protocol-based dependency injection.

*State management* The view model exposes a single `ViewState` enum (`idle`, `loading`, `loaded`, `empty`, `failed`) rather than separate loading/error/data properties. This makes contradictory states unrepresentable and reduces the view to one exhaustive `switch`.

*Concurrency* `async`/`await` throughout.

# Notable decisions

-   The whole row is tappable, not just the name.** The brief specifies tapping the employee's name. I made the entire row the navigation target instead: it gives a much larger touch target, matches standard iOS list behaviour, and works better with VoiceOver and Switch Control, where a small inline tap region inside a row is awkward to reach. The destination and behaviour are identical. If name-only tapping were a hard requirement, it's a small change — a `.navigationDestination(item:)` driven by a selected-employee state property, with the link scoped to the name text.

# TODO

- Snapshot tests
- Time zone handling
- Visual design
- Localisation
- Pagination
