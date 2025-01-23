import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/constants.dart';
import '../blocs/blocs.dart';

class WeatherInfoCard extends StatefulWidget {
  const WeatherInfoCard({super.key});

  @override
  State<WeatherInfoCard> createState() => _WeatherInfoCardState();
}

class _WeatherInfoCardState extends State<WeatherInfoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    final weatherBloc = context.read<WeatherBloc>();
    if (weatherBloc.state.weatherStatus == WeatherStatus.initial) {
      weatherBloc.add(FetchWeatherEvent());
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String showTemperature(double temperature) {
    return '${temperature.toStringAsFixed(2)}℃';
  }

  Widget showIcon(String icon) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      image: 'http://$kIconHost/img/wn/$icon@4x.png',
      width: 75,
      height: 75,
      imageErrorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/loading.gif',
          width: 70,
          height: 70,
        );
      },
    );
  }

  Widget formatText(String description) {
    final formattedString = description.titleCase;
    return Text(
      formattedString,
      style: const TextStyle(fontSize: 17.0),
      textAlign: TextAlign.left,
    );
  }

  Widget shimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[300]!
          : Colors.grey[800]!,
      highlightColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[100]!
          : Colors.grey[900]!,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 2,
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 80,
                    height: 16,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Container(
                width: 75,
                height: 75,
                color: Colors.white,
              ),
              const Spacer(),
              Column(
                children: [
                  Container(
                    width: 100,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 70,
                    height: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
      if (state.weatherStatus == WeatherStatus.initial) {
        return const SizedBox.shrink();
      } else if (state.weatherStatus == WeatherStatus.loading) {
        return shimmerEffect();
      } else if (state.weatherStatus == WeatherStatus.error) {
        return const SizedBox.shrink();
      } else if (state.weatherStatus == WeatherStatus.loaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _animationController.forward();
        });
      }

      return FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Card(
            elevation:
                Theme.of(context).brightness == Brightness.light ? 0.5 : 1,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 2,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formatText(state.weather.description),
                      const SizedBox(height: 4),
                      Text(
                        showTemperature(state.weather.temp),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  showIcon(state.weather.icon),
                  const Spacer(),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.zero,
                        child: Text(
                          state.weather.name,
                          style: TextStyle(
                            fontSize: state.weather.name.length > 12 ? 16 : 17,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "(${state.weather.country})",
                        style: const TextStyle(fontSize: 13.2),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
