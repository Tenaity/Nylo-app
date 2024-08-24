import '/resources/pages/profile_page.dart';
import '/resources/pages/reward_page.dart';
import '/resources/pages/daily_report_page.dart';
import '/resources/pages/weekly_report_page.dart';
import '/resources/pages/dashboard_page.dart';
import '/resources/pages/_page.dart';
import '/resources/pages/landing_page.dart';
import '/resources/pages/home_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
| Learn more https://nylo.dev/docs/5.20.0/router
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
      router.route(HomePage.path, (context) => HomePage());
      // Add your routes here

      // router.route(NewPage.path, (context) => NewPage(), transition: PageTransitionType.fade);

      // Example using grouped routes
      // router.group(() => {
      //   "route_guards": [AuthRouteGuard()],
      //   "prefix": "/dashboard"
      // }, (router) {
      //
      //   router.route(AccountPage.path, (context) => AccountPage());
      // });
      router.route(LandingPage.path, (context) => LandingPage(),
          initialRoute: false);
      router.route(Page.path, (context) => Page());
      router.route(DashboardPage.path, (context) => DashboardPage(),
          initialRoute: true);
      router.route(WeeklyReportPage.path, (context) => WeeklyReportPage());
      router.route(DailyReportPage.path, (context) => DailyReportPage());
      router.route(RewardPage.path, (context) => RewardPage());
      router.route(ProfilePage.path, (context) => ProfilePage());
    });
