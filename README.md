# WorldView iOS App
WorldView is a SwiftUI-based iOS application that enables users to explore countries worldwide, view key details such as capital cities and currencies, and manage a personalized list of favorite countries. The app utilizes the [REST Countries API](https://restcountries.com/v2/all?fields=name,capital,currencies,flag,flags) and the user’s current GPS location for an interactive and personalized experience.
# Table of Content
  * [Features](#features)
  * [Technologies](#technologies)
  * [App Structure](#app-structure)
  * [Acceptance Criteria](#acceptance-criteria)

# Features
## Main Screen 

  - Displays all countries from the countries API.
  - Displays a user-defined list of selected countries up to 5 countries.
  - If location permission is granted, it automatically adds the country corresponding to the user's GPS location.
  - If permission is denied, a default country (Egypt) is shown.
  - Allows removing countries from the list with ease.
  - Display each country's name, flag, and capital.

## Country Search
- Users can search for countries by the name of the country or the capital.
- Displays matching results that can be added to the main view (up to 5).

## Detail View 
Tapping on a country displays detailed info, including:

  - Country Name
  - Flag
  - Capital City
  - Currency

## Offline Support
Countries added to the selected countries list are saved locally using SwiftData, ensuring the app works without network access. However, the list of all countries displays a network reachability error message to alert the user that the network is down.

## Unit Testing
The app includes multiple test suites using **Swift Testing** Library, which cover the following test categories:

  - **Initialization:** loads persisted countries on init.
  - **Search:** filters search results by name, empty query handling, and unmatched query behavior.
  - **Selection:** handles adding/removing countries and enforces the selection limit.

# Technologies

 ![Static Badge](https://img.shields.io/badge/iOS-17.2-blue)
 ![Static Badge](https://img.shields.io/badge/Swift-5.0-orange)
 ![Static Badge](https://img.shields.io/badge/Xcode-18.2-blue)

|        Technology        |           Framework in Project            |
| ------------------------ | ----------------------------------------- |
| UI                       | SwiftUI                                   |
| Networking               | URLSession                                |
| Testing                  | Swift Testing                             |
| Local Storage            | SwiftData                                 |
| Caching                  | NSCache                                   |


# App Structure

## Folder Structure:
The project is divided into the following folders:

- **App:** Holds the entry point for the application and the AppDelegate.
- **Core:** Holds the shared data between all features, like managers, resources, and utilities.
- **Features:** Holds the main features of the application, divided into data and presentation layers.

## Architecture: 
The app's codebase is organized into **data** and **presentation** layers, separating concerns. The project implements the **MVVM architecture** pattern for managing UI-related concerns, separating presentation logic from business logic.

## Error Handling: 
Informative error messages are displayed to users when data retrieval or processing fails.

## UI/UX Design: 
The app's design and usability are carefully considered to provide a smooth and intuitive user experience.


## Acceptance Criteria

### 1. Code Quality
- ✅ Developed entirely using **Swift 5.0**, fully compatible with Swift 5+ requirement.
- ✅ Used **SwiftUI** across the entire app to build views and layouts, meeting the recommendation to prefer SwiftUI.
- ✅ Avoided UIKit and ensured the project showcases modern SwiftUI practices.

### 2. UI
- ✅ No use of Storyboards or Xib files; all UI is implemented programmatically using SwiftUI.
- ✅ Designed a **clean and user-friendly interface**, focusing on usability and clarity.
- ✅ Implemented **smooth navigation** between the main country list and a detailed country view using SwiftUI's `NavigationStack`.
- ✅ Display an animated splash screen and created a suitable app icon for the project.

### 3. Version Control
- ✅ Managed the project using **Git** on **GitHub**.
- ✅ Maintained a **clean and informative commit history** with frequent, descriptive commit messages that reflect the changes made at each step.


