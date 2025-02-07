# Health Mate

Health Mate is a feature-rich mobile application designed to help users track their habits, calculate BMI, monitor the weather, customize themes, access health-related blogs, complete daily challenges, and receive AI-based health assistance.

## Features

- **User Authentication**: Sign up, log in, and manage user profiles.
- **Habit Tracker**: Add, edit, delete, and filter daily habits.
- **BMI Calculator**: Calculate BMI based on user input.
- **Weather Integration**: Get real-time weather updates.
- **Custom Themes & Modes**: Personalize the app's appearance.
- **Mindfulness Audios**: Listen to guided meditation and relaxation audios.
- **Health & Fitness Blogs**: Read curated health-related articles.
- **Daily Challenges**: Participate in new challenges every day.
- **AI Chat Assistance**: Get AI-powered health and fitness advice.

## Screenshots

### Onboarding
<img src="screenshots/mockups/onborading/ai_chat_assistance.png" width="300px">
<img src="screenshots/mockups/onborading/track_your_habit.png" width="300px">
<img src="screenshots/mockups/onborading/welcome_to_health_mate.png" width="300px">

### Authentication
<img src="screenshots/mockups/authentication/forgot_password.png" width="300px">
<img src="screenshots/mockups/authentication/login.png" width="300px">
<img src="screenshots/mockups/authentication/login_light.png" width="300px">
<img src="screenshots/mockups/authentication/password_reset_email_link.png" width="300px">
<img src="screenshots/mockups/authentication/signup.png" width="300px">
<img src="screenshots/mockups/authentication/sign_with_google.png" width="300px">


### Home
<img src="screenshots/mockups/home/home_page.png" width="300px">
<img src="screenshots/mockups/home/home_page_light.png" width="300px">
<img src="screenshots/mockups/home/location_request.png" width="300px">


### AI Chat
<img src="screenshots/mockups/ai_chat/ai_chat.png" width="300px">
<img src="screenshots/mockups/ai_chat/ai_chat_light.png" width="300px">
<img src="screenshots/mockups/ai_chat/ask_ai.png" width="300px">
<img src="screenshots/mockups/ai_chat/ask_ai_light.png" width="300px">


### BMI Calculator
<img src="screenshots/mockups/bmi/bmi_input.png" width="300px">
<img src="screenshots/mockups/bmi/bmi_result.png" width="300px">


### Challenges
<img src="screenshots/mockups/challenges/daily_challenges.png" width="300px">
<img src="screenshots/mockups/challenges/daily_challenges.png" width="300px">


### Mindfulness
<img src="screenshots/mockups/mindfulness/mindfulness_audios.png" width="300px">
<img src="screenshots/mockups/mindfulness/play_audio.jpg" width="300px">


### Habit Tracking
<img src="screenshots/mockups/habit_tacking/create_habit.png" width="300px">
<img src="screenshots/mockups/habit_tacking/create_habit_light.png" width="300px">
<img src="screenshots/mockups/habit_tacking/habit_created.png" width="300px">
<img src="screenshots/mockups/habit_tacking/habit_created_light.png" width="300px">
<img src="screenshots/mockups/habit_tacking/habit_list_sort_dark.jpg" width="300px">
<img src="screenshots/mockups/habit_tacking/habit_list_sort_light.jpg" width="300px">


### Blog
<img src="screenshots/mockups/blog/blogs_page.png" width="300px">
<img src="screenshots/mockups/blog/blogs_page_light.jpg" width="300px">
<img src="screenshots/mockups/blog/read_blog.jpg" width="300px">
<img src="screenshots/mockups/blog/read_blog_light.png" width="300px">


### Profile
<img src="screenshots/mockups/profile/change_profile_detail.jpg" width="300px">
<img src="screenshots/mockups/profile/profile_page.png" width="300px">
<img src="screenshots/mockups/profile/profile_page_light.png" width="300px">


### Themes
<img src="screenshots/mockups/themes/app_theme_colors.png" width="300px">
<img src="screenshots/mockups/themes/theme_modes.png" width="300px">
<img src="screenshots/mockups/themes/theme_modes_light.png" width="300px">


## Installation

### Prerequisites
- Flutter SDK installed ([Download Flutter](https://flutter.dev/docs/get-started/install))
- Dart installed
- A code editor (e.g., Visual Studio Code, Android Studio)
- Firebase configured for authentication (if applicable)

### Steps
1. Clone the repository:
   ```sh
   git clone https://github.com/H3inAK/Health-Mate.git
   ```
2. Navigate to the project directory:
   ```sh
   cd Health-Mate
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Set up environment variables (API keys, Firebase, etc.) in a `.env` file.
5. Initialize Firebase using FlutterFire CLI:
   ```sh
   flutterfire configure
   ```
6. Get Keystore for Android Signing :
   ```sh
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
5. Run the app:
   ```sh
   flutter run
   ```

## Testing

Health Mate uses **Unit Testing, Widget Testing, and Integration Testing** to ensure reliability.

### Running Tests
```sh
flutter test
```

## Technologies Used
- **Flutter** (Dart)
- **Firebase Authentication**
- **Bloc State Management**
- **Geolocator** (for weather services)
- **REST APIs** (healthmate backend api)
- **Sqflite Database** (for local storage)

## Contribution

Contributions are welcome! Follow these steps:
1. Fork the repository.
2. Create a new branch (`feature/your-feature-name`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push to your branch (`git push origin feature/your-feature-name`).
5. Open a pull request.

## License

This project is licensed under the  GNU GENERAL PUBLIC LICENSE. See `LICENSE` for details.
