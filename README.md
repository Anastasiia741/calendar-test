# Calendar Test App

SwiftUI-приложение для отображения тренировок по дням с календарём, деталями тренировки и базовой аналитикой.  
Проект выполнен как тестовое задание с фокусом на архитектуру, читаемость кода и unit-тесты.

---

## Requirements

- **Xcode:** 15.0+
- **iOS:** 17.0+
- **Swift:** 5.9 (Swift 6 language mode)
- **Frameworks:** SwiftUI, Combine
- **Concurrency:** async/await, MainActor

---

## How to Run

1. Clone the repository:
   - git clone https://github.com/Anastasiia741/calendar-test.git
2. Open `Calendar-test.xcodeproj` in Xcode.
3. Select the **Calendar-test** scheme.
4. Choose an iOS Simulator (e.g. iPhone 15 / iOS 17).
5. Run with **⌘R**.

### Run Unit Tests
- Run all tests: **⌘U**
- Or run from Test Navigator.

## Architecture
The project uses **MVVM**:
- **Views (SwiftUI)** render UI and forward user actions.
- **ViewModels** hold screen state via `@Published` and contain presentation logic.
- **ServiceProtocol** abstracts data loading, allowing mocking in tests.

Async work is implemented with **Swift Concurrency (`async/await`)** and UI updates are performed on **MainActor**.

## Unit Tests Coverage
Covered with XCTest:
- Filtering workouts by selected day (`workoutsForSelectedDay`)
- Switching months (`goToNextMonth`, `goToPreviousMonth`)
- Date formatting helpers (time / month title / date-time formatting)
