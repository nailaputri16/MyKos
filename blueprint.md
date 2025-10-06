# MyKos App Blueprint

## Overview

MyKos adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu mahasiswa dan perantau menemukan tempat kos di sekitar kampus-kampus di Bandar Lampung. Aplikasi ini akan menggunakan Firebase untuk manajemen data secara real-time.

## Features & Design

### Version 1.0 (Initial Setup)

*   **Firebase Integration:** 
    *   Project linked to Firebase Console.
    *   FlutterFire configured for Android and Web.
    *   `firebase_core` initialized in the app.
*   **Login Screen:**
    *   UI created based on the user-provided design.
    *   Includes fields for username and password.
    *   Contains a login button and links for password recovery and account creation.
    *   Fixed overflow issue by making the form scrollable.
*   **Sign-up Screen:**
    *   UI created based on the user-provided design.
    *   Includes fields for name, email, password, and phone number.
    *   Contains a sign-up button and a link to log in.
*   **Home Screen:**
    *   UI created based on the user-provided design.
    *   Includes a welcome banner, a grid of kos listings, and a bottom navigation bar.
    *   Converted to a `StatefulWidget` to manage bottom navigation.
*   **Profile Screen & Logout:**
    *   A new profile screen with a prominent logout button.
    *   Logout functionality that securely signs the user out and returns them to the login screen.

## Current Plan

### Add Profile Screen with Logout

1.  **Create `lib/profile_screen.dart`:** A new file for the profile page UI, which will include a logout button.
2.  **Implement Logout Logic:** When the logout button is pressed, navigate the user back to the `LoginScreen` and clear the navigation stack.
3.  **Refactor `home_screen.dart`:** Convert it from a `StatelessWidget` to a `StatefulWidget` to handle the state of the bottom navigation bar.
4.  **Integrate Profile Screen:** Create a list of page widgets within `HomeScreen` and use the `BottomNavigationBar` to switch between the main home content and the new `ProfileScreen`.
