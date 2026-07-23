# Momentum 🚀

A professional, feature-rich habit tracker application built with Flutter. Momentum helps users build positive routines, track their daily progress, earn milestone badges, and visualize their productivity trends with elegant charts and gamified celebration effects.

---

## 📋 Table of Contents
1. [Key Features](#-key-features)
2. [Project Architecture](#-project-architecture)
3. [Tech Stack & Dependencies](#-tech-stack--dependencies)
4. [File & Directory Structure](#-file--directory-structure)
5. [Data Models & Hive Adapters](#-data-models--hive-adapters)
6. [Getting Started & Development Commands](#-getting-started--development-commands)
7. [AI Reference & Development Guidelines](#-ai-reference--development-guidelines)

---

## 🌟 Key Features

*   **Interactive Habit Management:** Create, edit, inspect details of, and archive (soft delete) habits.
*   **Daily Scoring & Logs:** Track daily accomplishments with a points/score log system.
*   **Gamified Streaks & Badges:** Automatically compute current/longest streaks, check milestones, and award badges. Includes confetti animations upon hitting key milestones.
*   **Aesthetic Statistics:** Visual representation of habits, completion history, and trend graphs powered by `fl_chart`.
*   **Polished Onboarding Flow:** Seamless introduction sequence for first-time users.
*   **Customizable Settings & Theming:** Smooth transitions between Light and Dark mode using custom design tokens, and personal settings configuration.

---

## 🏗️ Project Architecture

Momentum is structured around clean coding standards and clear separation of concerns:

1.  **State Management (`Provider`):** Handles reactive state updates across the app (e.g., UI state, themes, database updates).
2.  **Navigation (`GoRouter`):** Utilizes declarative routing. It features a nested-tab system (`StatefulShellRoute`) to preserve page state across navigation tabs while allowing full-screen modal overlays (e.g. adding or editing habits).
3.  **Local Storage (`Hive`):** A lightweight, fast key-value database optimized for Flutter. It uses custom type adapters for serialization.

---

## 🛠️ Tech Stack & Dependencies

### Core
*   **Flutter SDK**: `>=3.0.0 <4.0.0`
*   **Dart SDK**

### State & Routing
*   [`provider`](https://pub.dev/packages/provider): Central state propagation.
*   [`go_router`](https://pub.dev/packages/go_router): Declarative routing with deep linking capabilities and state preservation.

### Database / Local Persistence
*   [`hive`](https://pub.dev/packages/hive) & [`hive_flutter`](https://pub.dev/packages/hive_flutter): NoSQL database storing habits, completion logs, and daily scores.

### UI & Animations
*   [`fl_chart`](https://pub.dev/packages/fl_chart): Drawing beautiful weekly and monthly analytics charts.
*   [`confetti`](https://pub.dev/packages/confetti): Celebrating milestone achievements visually.
*   [`google_fonts`](https://pub.dev/packages/google_fonts): Clean typography.
*   [`cupertino_icons`](https://pub.dev/packages/cupertino_icons): Clean, stylized icon packs.

### Development & Tools
*   [`build_runner`](https://pub.dev/packages/build_runner): Code generation trigger.
*   [`hive_generator`](https://pub.dev/packages/hive_generator): Code generator generating Hive TypeAdapters (`g.dart` files).
*   [`very_good_analysis`](https://pub.dev/packages/very_good_analysis): Linting guidelines.
*   [`uuid`](https://pub.dev/packages/uuid) & [`intl`](https://pub.dev/packages/intl): Utilities for ID generation and date formatting.

---

## 📂 File & Directory Structure

```text
lib/
├── app.dart                   # Main app definition, theme configurations, & GoRouter setups
├── main.dart                  # App bootstrap, Hive init, adapter registrations, & top-level providers
├── core/                      # Global configurations, utils, & constants
│   ├── constants/             # Constants for colors and assets
│   ├── theme/                 # Light/Dark app theme configurations & color definitions
│   └── utils/                 # General helpers (e.g., date formats, math calculations)
├── models/                    # Data blueprints/structures
│   ├── badge_model.dart       # Milestone badge attributes
│   ├── enums.dart             # Habit categories (fitness, mind, etc.) & times-of-day
│   ├── habit.dart             # Habit class schema
│   ├── habit_log.dart         # Log tracking single completion instances
│   └── score_log.dart         # Daily user score progression
├── providers/                 # State management controllers
│   ├── habit_provider.dart    # Manages habits lifecycle and logs
│   ├── stats_provider.dart    # Aggregates scores and builds analytics metrics
│   └── theme_provider.dart    # Manages the app styling states
├── services/                  # Business logic and external interfaces
│   ├── database_service.dart  # Hive box wrappers (CRUD)
│   └── streak_service.dart    # Tracks consecutive streaks and awards badges
├── screens/                   # Page UI screens
│   ├── add_habit/             # Form screen for creating habits
│   ├── edit_habit/            # Form screen for editing existing habits
│   ├── habit_detail/          # Visual breakdown of a habit's history, stats, and badges
│   ├── home/                  # Day-to-day habit task list and scoring status
│   ├── onboarding/            # First-run welcome carousel
│   ├── settings/              # Dark mode toggles, profile details
│   └── stats/                 # Historical charts and streak overviews
└── widgets/                   # Specialized UI elements
    ├── animated_check.dart    # Smooth, rewarding completion checkbox animation
    ├── habit_card.dart        # List items representing habit states
    └── streak_badge.dart      # Graphical badge represent milestone achievements
```

---

## 💾 Data Models & Hive Adapters

Hive adapters are mapped to specific unique IDs to prevent serialization conflicts:

| Model | Adapter ID | Hive Box Name | Description |
| :--- | :--- | :--- | :--- |
| `Habit` | `0` | `'habits'` | Stores habits definitions, schedule frequencies, and archived flags. |
| `HabitLog` | `1` | `'logs'` | Tracks every historical completion event of habits. |
| `HabitCategory` | `2` | N/A (Enum) | Mapped habit tags (e.g., Work, Health, Mind, Routine). |
| `HabitTimeOfDay` | `3` | N/A (Enum) | Preferred execution time (Morning, Afternoon, Evening, Anytime). |
| `ScoreLog` | `4` | `'score_logs'` | Tracks the user's total score achieved on any calendar date. |

---

## 🚀 Getting Started & Development Commands

### Prerequisites
*   Ensure Flutter is installed. Run `flutter doctor` to verify your environment setup.

### Installing Dependencies
```bash
flutter pub get
```

### Running Code Generation
If you make changes to files in `lib/models/` (adding properties, adding new adapters, etc.), execute the code generator:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Running the App
To run Momentum locally on an emulator/device:
```bash
flutter run
```

### Running Tests
To run unit and widget tests:
```bash
flutter test
```

---

## 🤖 AI Reference & Development Guidelines
This section acts as a quick memory layout for AI models modifying this codebase:

1.  **Strict Adapter Registration:** Always register Hive adapters in `lib/main.dart` *before* calling `Hive.initFlutter()`.
2.  **Soft Archival Pattern:** When deleting habits, do not call box deletion directly. Toggle `isArchived = true` and update the record to preserve completion logs.
3.  **State Upstream Integrity:** Always interact with habits through `HabitProvider` rather than modifying `DatabaseService` directly in the UI. This ensures widgets rebuild dynamically.
4.  **No Direct Modification of Generator Files:** Never modify `.g.dart` files directly. Make edits in the main models (`.dart`), then execute the generator command.

---

## 📊 Project Status & Future Roadmap

This report describes the current state of Momentum, highlighting what has been successfully completed, known limitations, and the future development direction.

### 🏁 1. Where the Project Has Reached (Current Status)
*   **Fully Functional Core CRUD:** Users can add, view, update, and soft-delete/archive habits.
*   **Persistent Progress Tracking:** Habits, completions (`HabitLog`), and scoring history (`ScoreLog`) persist locally using Hive.
*   **Gamified Streaks & Badges:** Features milestone tracking (e.g. 7-day, 30-day milestones) that awards badges and triggers celebration effects (confetti).
*   **Streak Protection (Freeze Tokens):** Users can earn or use freeze tokens to protect their habits from breaking when they miss a day.
*   **Visual Analytics:** The "Stats" tab includes a Category Balance Radar Chart and a 7-day Momentum History Line Chart.
*   **Personalization:** Settings include system-wide Light/Dark mode state management.

### ➕ 2. What Has Been Added (Recent Updates)
*   **Daily Score Logs (`ScoreLog`):** Unified daily score tracking to keep records of cumulative daily scores.
*   **Stateful Shell Tab Preservation:** Clean navigation using `StatefulShellRoute` in GoRouter so tab pages preserve scroll positions and filters.
*   **Confetti & Animation Feedback:** Rewarding animations added during check-ins and when passing milestones.

### 🔍 3. What is Missing / Needs Attention (Gaps)
*   **Custom Habit Frequencies:** Habits are currently restricted to basic daily routines; complex intervals (e.g., "every Monday/Wednesday/Friday" or "every 3 days") are not fully supported yet.
*   **Notifications & Reminders:** Lack of push notifications to remind users to complete habits in their designated time-of-day slots (morning, afternoon, evening).
*   **Data Export/Backup:** No option to export completion history to JSON/CSV or sync with cloud systems (i.e. iCloud, Google Drive).

### 🚀 4. Future Roadmap (What to Add Next)
1.  **Local Push Notifications:** Integrate local scheduled notifications tailored to the habit's time of day.
2.  **Advanced Habit Frequency Patterns:** Extend habit models to support custom days of the week or custom intervals.
3.  **Cloud Synchronization:** Implement remote database backup and sync support.
4.  **Social sharing & Widget support:** Allow sharing of habit milestones and add home-screen widgets for quick check-ins.

