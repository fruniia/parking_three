# Parking Three: Parking Admin and Parking User
This is the third exercise in Programming with Dart/Flutter. 

A mobile app for users who wants to park a vehicle.

A desktop app for admins to handle parking spaces.

Using excisting server from the second exercise.

## Project overview
1. **Parking Server** - Backend-server built with dart to handle data storage and server-side logic.
2. **Parking Admin** - A desktop-application built with Flutter for administration tasks like managing parking spaces.
3. **Parking User** - A mobile application built with Flutter for users to handle parking information.
4. **Parking Shared Logic** - A Dart package containing shared models, enums, repositories and utility functions, shared between Parking Server, Parking Admin, Parking User.
5. **Parking Shared UI** - A Flutter package with reusable widgets and providers shared between Parking Admin and Parking User.

## Table of Contents
1. [Project Overview](#project-overview)
2. [Functionality Overview](#functionality-overview)
3. [Installation - Flutter and Dart](#installation---flutter-and-dart)
4. [Clone the repository](#repository)
5. [Start the server](#start-the-server)
6. [Start the Admin](#start-the-desktop-application-parking-admin)
7. [Start the User](#start-the-mobile-application-parking-user)
8. [Limitations](#limitations)

## Functionality Overview

### Parking Admin
- Register parking spaces.
- Add or remove parking spaces.
- Update address or price on parking spaces.
- View all parking spaces.
- View active parking sessions with price/cost.
- View total earning for both active and completed parking sessions.
- View most popular parking spaces.

### Parking User
- Register an account.
- Login with username and password.
- Logout.
- Add a vehicle.
- Remove a vehicle.
- View availble parking spaces.
- Start parking session (register vehicle if not already registrered).
- Stop parking session.
- View active and completed parking sessions.

## Installation - Flutter and Dart
Follow the instructions below to install and run the application:
1. **Install Flutter**

   If you haven't installed Flutter yet, follow the instructions in the [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

2. **Install Dart**

   If you haven't installed Dart yet, follow the instructions in the [Dart Installation Guide](https://dart.dev/get-dart)

3. **Verify installations**
   
      After installation, verify that everything is set up correctly by running:
   ```bash
   flutter doctor
   flutter --version
   ```

## Repository
1. Clone the repository:
   ```bash
   git clone git@github.com:fruniia/parking_three.git
   ```

## Start the server
1. **Install dependencies**

   Navigate to the `parking_server` directory and install dependencies:
   ```bash
   cd parking_server
   dart pub get
   ```
2. **Run the server:**

   Start the server by running the following:
   ```
   dart run parking_server:server
   ```
   The server will now be running and ready to handle requests.

### Start the desktop application Parking Admin
1. **Install dependencies**

   Navigate to the `parking_admin` directory and install dependencies:
   ```bash
   cd parking_admin
   flutter pub get
   ```
2. **Run the desktop app**

   Run the app on Windows:
   ```bash
   flutter run -d windows # On Windows
   ```

### Start the mobile application Parking User
1. **Install dependencies**

   Navigate to the `parking_user` directory and install dependencies:
   ```bash
   cd parking_user
   flutter pub get
   ```
2. **Run the mobile app**
   Run the app with Android
   ```bash
   flutter run
   ```

### Limitations
**Server**
* No proper database system is used for persistent storage.
* Duplicated data is stored in `.json` files, leading to potential inconsistencies.
* No tests implemented.

**Admin**
* No login is required for the admin panel, making it insecure for production environments. (anyone with access to the app can modify data).
* Price per hour and adresses can be changed but are not updated in all `.json` files.
* The UI is not responsive, so it may not work well on all screen sizes.
* Only tested on Windows.
* No tests implemented.

**User**
* A password is needed to login, but is not securely stored in the app (e.g., no encryption).
* Vehicle can be removed but not changed (no editing functionality).
* When Vehicle is removed, it is still stored in other `.json` files, causing data redundancy.
* No responsive UI, meaning the app may not display well on all devices.
* Only tested on Android.
* No tests implemented.


## License
This project is licensed under the MIT-license - see the [LICENSE](LICENSE) file for details.