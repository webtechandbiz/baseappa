import 'package:flutter/material.dart';

class AppConfig{
  static String WS_domain = ''; //#change
  static String splash_bg_page = WS_domain + 'wp-content/uploads/2021/10/splasha-scaled.jpg'; //#change

  static Uri WS_url_login = Uri.parse(WS_domain + 'wp-json/remote-login-vojocheruh/login-lutanithet'); //#change
  static Uri WS_url_logout = Uri.parse(WS_domain + 'wp-json/remote-login-vojocheruh/logout-lutanithet'); //#change
  static Uri WS_url_authtoken_login = Uri.parse(WS_domain + 'wp-json/remote-login-vojocheruh/authtoken-login-lutanithet'); //#change
  static Uri WS_url_accessosenzaregistrazione_login = Uri.parse(WS_domain + 'wp-json/remote-login-vojocheruh/accessosenzaregistrazione-lutanithet'); //#change
  static Uri WS_url_card = Uri.parse(WS_domain + 'wp-json/remote-login-vojocheruh/get-wp-post-lutanithet'); //#change
  static Uri WS_url_forgottenpassword = Uri.parse(WS_domain + 'wp-json/remote-login-vojocheruh/forgotten-password-lutanithet');
  static Uri WS_url_Subscribe = Uri.parse(WS_domain + 'wp-json/remote-login-vojocheruh/subscribe-lutanithet'); //#change

  static const Map<String, dynamic> applabels = {
    'login_http': {'labelText': 'Email user', 'hintText': 'Il tuo nome utente'},
    'menu': {
      'header': {'labelText': 'Drawer app Header', 'bgcolor': Colors.blue},

      'items': {
        'item1' : {'labelText': 'item 1'},
      },
      'logout': {'labelText': 'Logout'}
    }
  };

}