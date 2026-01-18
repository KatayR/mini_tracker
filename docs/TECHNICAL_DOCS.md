# Technical Documentation: Mini Tracker

## 1. Project Overview
**Application Name:** Mini Tracker
**Technologies:** Flutter (SDK ^3.10.4), Dart
**State Management:** Provider
**Architecture:** Clean Architecture
**Local Storage:** Hive
**Navigation:** GoRouter
**Dependency Injection:** GetIt

The application is a prototype designed to demonstrate features like Habit Tracking and Task Management. It follows a strict **Clean Architecture** pattern to ensure separation of concerns, scalability, and testability.

## 2. Architecture
The project adopts a layered **Clean Architecture** approach, structured into four main modules to ensure separation of concerns:

1.  **Core Module (`lib/core`)**: Contains shared utilities, configuration, dependency injection, and theme definitions used across all other layers.
2.  **Presentation Layer (`lib/presentation`)**: Contains the UI logic, widgets, screens, and controllers (State Management). It depends on the Domain layer.
3.  **Domain Layer (`lib/domain`)**: The core of the application. It contains Entities (business objects), Repository Interfaces, and pure Business Logic classes. This layer is independent of other layers.
4.  **Data Layer (`lib/data`)**: Handles data retrieval and persistence. It implements the Domain repositories and manages Data Sources (Local/Remote). It depends on the Domain layer.

### Directory Structure
```
lib/
├── core/           # Core utilities, configuration, and shared logic
│   ├── constants/  # App-wide constants (Strings, Assets)
│   ├── di/         # Dependency Injection setup (ServiceLocator)
│   ├── init/       # App initialization logic
│   ├── network/    # Network connectivity abstraction (NetworkInfo)
│   ├── theme/      # App theming (Light/Dark themes, Colors, Typography, Decorations)
│   └── utils/      # Shared utility classes
├── data/           # Data Layer
│   ├── datasources/# Remote and Local data sources
│   ├── models/     # Data Transfer Objects (DTOs) with JSON serialization
│   └── repositories/# Implementation of domain repositories
├── domain/         # Domain Layer
│   ├── entities/   # Pure business objects
│   ├── logic/      # Pure business logic
│   └── repositories/# Abstract repository interfaces
├── presentation/   # Presentation Layer
│   ├── controllers/# State management (Providers)
│   ├── mixins/     # Reusable UI logic
│   ├── routes/     # Navigation configuration (GoRouter)
│   ├── screens/    # Full-screen widgets
│   └── widgets/    # Reusable UI components
└── main.dart       # Application entry point
```

## 3. Core Module
The `core` module provides essential services to the entire application.

-   **Dependency Injection (`core/di`)**: Uses `get_it` to register and provide singletons and factories for Repositories, Data Sources, and external services. `setupLocator()` in `service_locator.dart` is the main registration point.
-   **Initialization (`core/init`)**: `AppInitializer` handles asynchronous setup required before the app starts (e.g., initializing Hive, loading configurations).
-   **Network (`core/network`)**: Contains `NetworkInfo` abstraction with `NetworkInfoImpl` that wraps `connectivity_plus` to check internet connectivity. Used by repositories to enforce online requirements for write operations.
-   **Theme (`core/theme`)**: Defines `AppTheme` with `lightTheme` and `darkTheme` configuration. Additional files include `AppPalette` (colors), `AppTextStyles` (typography), `AppDecorations` (box decorations), `AppDimens` (spacing/sizing), and `AppShapes` (border radii).
-   **Constants (`core/constants`)**: Centralized string resources and configuration constants.


## 4. Data Layer (`lib/data`)
The Data Layer is responsible for data retrieval, storage, and synchronization. It abstracts the underlying data sources from the rest of the application.

### Datasources
The application uses two types of datasources, defined by the `ICrudDataSource` interface:

*   **Local Datasources (`TaskLocalDataSourceImpl`, `HabitLocalDataSourceImpl`)**:
    *   **Technology**: [Hive](https://docs.hivedb.dev/) (NoSQL key-value database).
    *   **Function**: Act as the local cache for offline access and instant data loads.
    *   **Implementation**: Separate implementations per entity type, each implementing `ICrudDataSource<T>` interface. Both handle entities extending `BaseEntity` (which provides an `id`).
*   **Remote Datasource (`MockGenericRemoteDataSource`)**:
    *   **Technology**: Mock implementation (Simulates backend).
    *   **Function**: Simulates network delays and random errors (10% failure rate) to test error handling and synchronization.
    *   **Behavior**: Supports UPSERT operations (updates if exists, creates if not).

### Repositories (`BaseRepository`)
The repository implementation (`GenericRepositoryImpl` equivalent, specifically `BaseRepository`) orchestrates data flow between Local and Remote sources.

*   **Strategy**: **Remote-First for Writes, Local-First for Reads.**
    *   **Read (`fetchAllItems`)**: Returns data from the **Local** datasource to ensure zero-latency UI loading.
    *   **Write (`create`, `update`, `delete`)**: strict **Remote-First** approach.
        1.  Attempt operation on **Remote**.
        2.  If successful, replicate change to **Local**.
        3.  If Remote fails, throw error (UI handles feedback).
*   **Synchronization (`syncRemote`)**:
    1.  Fetches all local and remote items.
    2.  **Push**: Finds items present locally but missing remotely (e.g., created offline) and pushes them to Remote.
    3.  **Pull**: Fetches the latest list from Remote and replaces the Local cache (Source of Truth).

### Models
Models in `data/models` are DTOs (Data Transfer Objects) that extend specific Entities. They include `fromJson` and `toJson` methods for serialization, bridging the gap between raw API data and Domain Entities.


## 5. Domain Layer (`lib/domain`)
The Domain layer contains the core business rules and is completely independent of the Data and Presentation layers.

*   **Entities (`domain/entities`)**: Pure Dart classes representing business objects (e.g., `TaskEntity`, `HabitEntity`). They implement `equatable` for value comparison.
*   **Logic (`domain/logic`)**: Contains pure business logic classes with static utility methods. For example, `TaskFilterLogic` handles filtering and searching tasks in memory, and `HabitLogic` provides streak calculation algorithms.
*   **Repository Interfaces (`domain/repositories`)**: Abstract classes (contracts) that the Data layer must implement (e.g., `IHabitRepository`). This allows the Domain layer to request data without knowing *how* it is fetched.

## 6. Presentation Layer (`lib/presentation`)
The Presentation layer is responsible for the UI and handling user interactions.

### State Management (Controllers)
The app uses **Provider** for dependency injection of controllers, which extend `ChangeNotifier` for state management.
*   **Base Controller (`BaseDataController`)**: A generic base class that handles common state (loading, syncing, search) and CRUD operations.
*   **RemoteActionMixin**: A critical mixin used by controllers to handle async operations.
    *   **Responsibilities**: Manages per-item loading states using `_loadingItemIds`.
    *   **Safeguards**: Wraps remote calls in a try-catch block (`executeRemoteAction`).
    *   **Flow**: Enforces a strict **Remote Success → Local Update** pattern. If the remote call fails, the local state is NOT updated, and an error is shown.
*   **Feature Controllers**: `TaskController` and `HabitController` extend the base controller and use the mixin for feature-specific logic.
*   **Theme Controller (`ThemeController`)**: Manages the application's theme mode (Light/Dark) and persists the user's preference.

### Navigation (`routes`)
Navigation is handled by **GoRouter**, configured in `AppRouter`.
*   **Shell Route**: Uses `StatefulShellRoute` to implement a persistent Bottom Navigation Bar (`HomePage`) that maintains the state of each tab (Tasks, Habits).
*   **Routes**: Defined in `AppRoutes` constants. Supports nested navigation and parameter passing.

### Screens & Widgets
*   **Screens**: High-level pages (e.g., `TaskListScreen`, `AddEditHabitScreen`).
*   **Widgets**: Reusable components. The design follows strict theming rules, using `AppTheme` and `AppPalette` to ensure consistency and Dark Mode support.


## 7. Key Features
### Task Management
*   **CRUD Operations**: Users can Create, Read, Update, and Delete tasks.
*   **Filtering**: Tasks can be filtered by status (All, Active, Completed) using `TaskFilterLogic`.
*   **Properties**: Tasks support Title, Description, Due Date, and Priority levels.

### Habit Tracking
*   **Habit Persistence**: Habits are stored locally and synced to remote.
*   **Tracking**: Users can mark habits as completed for the day.
*   **Streaks**: Streak values are stored in `HabitEntity.streak` and recalculated using `HabitLogic.calculateStreak()` in the domain layer. The algorithm counts consecutive completion days starting from today/yesterday backwards.

### Offline Synchronization
The app is built to be **Offline-First** (for reads) and **Resilient** (for writes).
*   **Scenario 1 (Offline Start)**: App loads data immediately from Hive. User sees last known state.
*   **Scenario 2 (Offline Write)**: User creates a task. Repository first checks connectivity via `NetworkInfo.isConnected` -> If offline, throws `Exception("No Internet Connection")` immediately (before attempting remote write). Error is displayed to UI via `FeedbackUtils`. (Note: A robust "Queue" system would be the next step for full offline-write support).
*   **Scenario 3 (Online Sync)**: On app start, `syncRemote` ensures local data matches the server, merging any differences.

---
# End of Documentation
