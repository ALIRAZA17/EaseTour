import 'package:ease_tour/screens/bottom_nav/favorites/favorites_vu.dart';
import 'package:ease_tour/screens/bottom_nav/home/home_vu.dart';
import 'package:ease_tour/screens/bottom_nav/offers/offers_vu.dart';
import 'package:ease_tour/screens/bottom_nav/profile/profile_vu.dart';
import 'package:flutter/material.dart';

List<String> iconsListNav = [
  'assets/icons/home.svg',
  'assets/icons/heart.svg',
  'assets/icons/discount.svg',
  'assets/icons/user.svg',
];
List<String> widgetsListNav = ['/home', '/favorites', '/offers', '/profile'];

List<Widget> widgetsList = [
  const HomeView(),
  const FavoritesView(),
  const OffersView(),
  const ProfileView()
];

List<String> labelListNav = [
  'Home',
  'Favorites',
  'Offers',
  'Profile',
];
