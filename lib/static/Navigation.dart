enum NavigationRoute {
  HomePageRoute('/homepage'),
  DetailPageRoute('/detailpage'),
  CreatePageRoute('/createpage'),
  ListProfileRoute('/listprofilepage');

  const NavigationRoute(this.name);
  final String name;
}
