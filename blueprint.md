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

### Implement Firebase Authentication

1.  **Add `firebase_auth` dependency:** Include the package for Firebase Authentication.
2.  **Refactor `signup_screen.dart`:** Convert to `StatefulWidget` and implement `FirebaseAuth.instance.createUserWithEmailAndPassword`.
3.  **Refactor `login_screen.dart`:** Convert to `StatefulWidget` and implement `FirebaseAuth.instance.signInWithEmailAndPassword`.
4.  **Update `main.dart`:** Use a `StreamBuilder` to listen to `authStateChanges()` to automatically navigate users based on their authentication state.
5.  **Error Handling:** Implement user-friendly error messages for common authentication issues (e.g., wrong password, email already in use).
