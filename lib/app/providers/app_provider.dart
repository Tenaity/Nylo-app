import '/app/forms/style/form_style.dart';
import '/config/form_casts.dart';
import '/config/decoders.dart';
import '/config/design.dart';
import '/config/theme.dart';
import '/config/validation_rules.dart';
import 'package:nylo_framework/nylo_framework.dart';
import '/config/localization.dart';

class AppProvider implements NyProvider {
  @override
  boot(Nylo nylo) async {
    await NyLocalization.instance.init(
      localeType: localeType,
      languageCode: languageCode,
      assetsDirectory: assetsDirectory,
    );

    FormStyle formStyle = FormStyle();

    nylo.addLoader(loader);
    nylo.addLogo(logo);
    nylo.addThemes(appThemes);
    nylo.addToastNotification(getToastNotificationWidget);
    nylo.addValidationRules(validationRules);
    nylo.addModelDecoders(modelDecoders);
    nylo.addControllers(controllers);
    nylo.addApiDecoders(apiDecoders);
    nylo.addFormCasts(formCasts);
    nylo.useErrorStack();
    nylo.addFormStyle(formStyle);

    // Optional
    // nylo.showDateTimeInLogs(); // Show date time in logs
    // nylo.monitorAppUsage(); // Monitor the app usage

    return nylo;
  }

  @override
  afterBoot(Nylo nylo) async {

  }
}