# Task Manager App

## Overview

Task Manager is a Flutter application designed to help users manage their tasks efficiently. It utilizes Flutter for the front-end development, Bloc for state management, and Firestore for the backend database. The app allows users to perform CRUD (Create, Read, Update, Delete) operations on tasks, ensuring a seamless task management experience.

## Features

- **User Authentication**: Users can securely log in to the app using Firebase email and password authentication. New users are required to register before logging in.

- **Task Management**: Once logged in, users can view, add, update, and delete tasks. Tasks are stored in the Firestore database, ensuring data persistence and accessibility across devices.

- **Intuitive Interface**: The app features a user-friendly interface, making it easy for users to navigate and manage their tasks efficiently.

## Getting Started

To get started with Task Manager, follow these steps:

1. **Clone the repository** to your local machine.
2. Ensure you have **Flutter and Dart** installed on your development environment.
3. **Set up Firebase** for your project and configure the necessary authentication and Firestore database.
4. **Update the Firebase configuration** in the app (usually located in `lib/main.dart`) with your Firebase project credentials.
5. Run the app on your preferred **emulator or physical device** using `flutter run`.

## Dependencies

Task Manager relies on the following dependencies:

- Flutter
- Bloc for state management
- Firestore for database storage
- Firebase Authentication for user authentication


