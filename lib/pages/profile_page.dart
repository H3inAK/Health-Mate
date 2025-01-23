import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/authentication/blocs.dart';
import '../features/authentication/screens/signin_screen.dart';
import '../features/themes/pages/change_theme_mode_page.dart';
import '../features/themes/pages/themes_selection_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const String routeName = '/profile-page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _sanitizeProfileImageUrl(String url) {
    if (url.contains('=s96-c')) {
      return url.replaceAll('=s96-c', '');
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // statusBarColor: Colors.transparent,
      // statusBarIconBrightness: Brightness.dark,
      // statusBarBrightness:
      //     !kIsWeb && Platform.isAndroid ? Brightness.light : Brightness.dark,
      // systemNavigationBarColor:
      //     AdaptiveTheme.of(context).mode == AdaptiveThemeMode.system
      //         ? AdaptiveTheme.of(context).lightTheme.scaffoldBackgroundColor
      //         : AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light
      //             ? AdaptiveTheme.of(context).lightTheme.scaffoldBackgroundColor
      //             : AdaptiveTheme.of(context).darkTheme.scaffoldBackgroundColor,
      systemNavigationBarColor: Theme.of(context).brightness == Brightness.dark
          ? AdaptiveTheme.of(context).darkTheme.scaffoldBackgroundColor
          : AdaptiveTheme.of(context).lightTheme.scaffoldBackgroundColor,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.profileStatus == ProfileStatus.error) {
            return Center(child: Text(state.error.message));
          }

          final sanitizedImageUrl =
              _sanitizeProfileImageUrl(currentUser?.photoURL ?? '');

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    currentUser?.displayName ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black26,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      sanitizedImageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: sanitizedImageUrl,
                              placeholder: (context, url) => Image.asset(
                                'assets/images/loading.gif',
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/loading.gif',
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 10),
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      leading: Icon(Icons.edit,
                          color: Theme.of(context).colorScheme.secondary),
                      title: Text('Edit Profile',
                          style: Theme.of(context).textTheme.bodyLarge),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              fbUser: currentUser!,
                              onProfileUpdated: () => setState(() {
                                // refresh the profile
                                print('Profile updated');
                              }),
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      leading: Icon(Icons.brightness_6,
                          color: Theme.of(context).colorScheme.secondary),
                      title: Text('Theme Mode',
                          style: Theme.of(context).textTheme.bodyLarge),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(ChangeThemeModePage.routeName);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      leading: Icon(Icons.color_lens,
                          color: Theme.of(context).colorScheme.secondary),
                      title: Text('Select Theme',
                          style: Theme.of(context).textTheme.bodyLarge),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(ThemeSelectionPage.routeName);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      leading: Icon(Icons.logout,
                          color: Theme.of(context).colorScheme.secondary),
                      title: Text('Logout',
                          style: Theme.of(context).textTheme.bodyLarge),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        context.read<AuthBloc>().add(SignoutRequestEvent());
                        Navigator.of(context)
                            .pushReplacementNamed(SignInScreen.routeName);
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.33),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
