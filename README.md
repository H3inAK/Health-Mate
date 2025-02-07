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
![AI Chat Assistance](screenshots/mockups/onborading/ai_chat_assistance.png)
![Track Your Habit](screenshots/mockups/onborading/track_your_habit.png)
![Welcome to Health Mate](screenshots/mockups/onborading/welcome_to_health_mate.png)

### Authentication
![Forgot Password](screenshots/mockups/authentication/forgot_password.png)
![Login](screenshots/mockups/authentication/login.png)
![Login Light](screenshots/mockups/authentication/login_light.png)
![Password Reset Email](screenshots/mockups/authentication/password_reset_email_link.png)
![Signup](screenshots/mockups/authentication/signup.png)
![Sign in with Google](screenshots/mockups/authentication/sign_with_google.png)

### Home
![Home Page](screenshots/mockups/home/home_page.png)
![Home Page Light](screenshots/mockups/home/home_page_light.png)
![Location Request](screenshots/mockups/home/location_request.png)

### AI Chat
![AI Chat](screenshots/mockups/ai_chat/ai_chat.png)
![AI Chat Light](screenshots/mockups/ai_chat/ai_chat_light.png)
![Ask AI](screenshots/mockups/ai_chat/ask_ai.png)
![Ask AI Light](screenshots/mockups/ai_chat/ask_ai_light.png)

### BMI Calculator
![BMI Input](screenshots/mockups/bmi/bmi_input.png)
![BMI Result](screenshots/mockups/bmi/bmi_result.png)

### Challenges
![Daily Challenges](screenshots/mockups/challenges/daily_challenges.png)
![Habit Import](screenshots/mockups/challenges/habit_import.png)

### Mindfulness
![Mindfulness Audios](screenshots/mockups/mindfulness/mindfulness_audios.png)
![Play Audio](screenshots/mockups/mindfulness/play_audio.jpg)

### Habit Tracking
![Create Habit](screenshots/mockups/habit_tracking/create_habit.png)
![Create Habit Light](screenshots/mockups/habit_tracking/create_habit_light.png)
![Habit Created](screenshots/mockups/habit_tracking/habit_created.png)
![Habit Created Light](screenshots/mockups/habit_tracking/habit_created_light.png)
![Habit List Sort Dark](screenshots/mockups/habit_tracking/habit_list_sort_dark.jpg)
![Habit List Sort Light](screenshots/mockups/habit_tracking/habit_list_sort_light.jpg)

### Blog
![Blogs Page](screenshots/mockups/blog/blogs_page.png)
![Blogs Page Light](screenshots/mockups/blog/blogs_page_light.jpg)
![Read Blog](screenshots/mockups/blog/read_blog.jpg)
![Read Blog Light](screenshots/mockups/blog/read_blog_light.png)

### Profile
![Change Profile Detail](screenshots/mockups/profile/change_profile_detail.jpg)
![Profile Page](screenshots/mockups/profile/profile_page.png)
![Profile Page Light](screenshots/mockups/profile/profile_page_light.png)

### Themes
![App Theme Colors](screenshots/mockups/themes/app_theme_colors.png)
![Theme Modes](screenshots/mockups/themes/theme_modes.png)
![Theme Modes Light](screenshots/mockups/themes/theme_modes_light.png)

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
