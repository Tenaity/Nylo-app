import 'package:nylo_framework/nylo_framework.dart';
import 'package:nylo_framework/theme/helper/ny_theme.dart';
import 'package:flutter/material.dart';
import '/bootstrap/extensions.dart';
import '/resources/widgets/logo_widget.dart';
import '/resources/widgets/safearea_widget.dart';
import '/bootstrap/helpers.dart';
import '/app/controllers/home_controller.dart';

class HomePage extends NyStatefulWidget<HomeController> {
  static const path = '/home';

  HomePage({super.key}) : super(path, child: () => _HomePageState());
}

class _HomePageState extends NyState<HomePage> {

  /// The boot method is called before the [view] is rendered.
  /// You can override this method to perform any async operations.
  /// Try uncommenting the code below.
  // @override
  // boot() async {
  //   dump("boot");
  //   await Future.delayed(Duration(seconds: 2));
  // }

  /// If you would like to use the Skeletonizer loader,
  /// uncomment the code below.
  // bool get useSkeletonizer => true;

  /// The Loading widget is shown while the [boot] method is running.
  /// You can override this method to show a custom loading widget.
  // @override
  // Widget loading(BuildContext context) {
  //   return Scaffold(
  //       body: Center(child: Text("Loading..."))
  //   );
  // }

  /// The [view] method should display your page.
  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello World".tr()),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.controller.showAbout,
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: SafeAreaWidget(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Logo(),
              Text(
                getEnv("APP_NAME"),
              ).displayMedium(context),
              const Text("Micro-framework for Flutter", textAlign: TextAlign.center)
                  .titleMedium(context)
                  .setColor(context, (color) => color.primaryAccent),
              const Text(
                "Build something amazing 💡",
              ).bodyMedium(context).alignCenter(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Divider(),
                  Container(
                    height: 250,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                        color: ThemeColor.get(context).surfaceBackground,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 9,
                            offset: const Offset(0, 3),
                          ),
                        ]),
                    child: Center(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children:
                        ListTile.divideTiles(context: context, tiles: [
                          if (Nylo.containsRoute("/landing"))
                            MaterialButton(
                              onPressed: () => routeTo("/landing"),
                              child: Text(
                                "Landing".tr(),
                              ).bodyLarge(context).setColor(
                                  context, (color) => color.surfaceContent),
                            ),
                          if (Nylo.containsRoutes(["/login", "/register"]))
                            ...[
                              MaterialButton(
                                onPressed: () => routeTo("/login"),
                                child: Text(
                                  "Login".tr(),
                                ).bodyLarge(context).setColor(
                                    context, (color) => color.surfaceContent),
                              ),
                              MaterialButton(
                                onPressed: () => routeTo("/register"),
                                child: Text(
                                  "Register".tr(),
                                ).bodyLarge(context).setColor(
                                    context, (color) => color.surfaceContent),
                              ),
                            ],
                          MaterialButton(
                            onPressed: widget.controller.onTapDocumentation,
                            child: Text(
                              "documentation".tr().capitalize(),
                            ).bodyLarge(context).setColor(
                                context, (color) => color.surfaceContent),
                          ),
                          MaterialButton(
                            onPressed: widget.controller.onTapGithub,
                            child: const Text(
                              "GitHub",
                            ).bodyLarge(context).setColor(
                                context, (color) => color.surfaceContent),
                          ),
                          MaterialButton(
                            onPressed: widget.controller.onTapChangeLog,
                            child: Text(
                              "changelog".tr().capitalize(),
                            ).bodyLarge(context).setColor(
                                context, (color) => color.surfaceContent),
                          ),
                          MaterialButton(
                            onPressed: widget.controller.onTapYouTube,
                            child: Text(
                              "YouTube Channel".tr().capitalize(),
                            ).bodyLarge(context).setColor(
                                context, (color) => color.surfaceContent),
                          ),
                        ]).toList(),
                      ),
                    ),
                  ),
                  const Text(
                    "Framework Version: $nyloVersion",
                  )
                      .bodyMedium(context)
                      .setColor(context, (color) => Colors.grey),
                  if (!context.isDarkMode)
                    Switch(
                        value: isThemeDark,
                        onChanged: (_) {
                          NyTheme.set(context,
                              id: getEnv(isThemeDark != true
                                  ? 'DARK_THEME_ID'
                                  : 'LIGHT_THEME_ID'));
                        }),
                  if (!context.isDarkMode)
                    Text("${isThemeDark ? "Dark" : "Light"} Mode"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get isThemeDark =>
      ThemeProvider.controllerOf(context).currentThemeId ==
          getEnv('DARK_THEME_ID');
}