import 'dart:async';

import 'package:core/models/profile.dart';
import 'package:core/repositories/providers/providers.dart';
import 'package:core/utils/facebook.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:provider/provider.dart';
import 'package:rovo_app/platform_channel.dart';
import 'package:rovo_app/ui/screens/auth/mixins/base_auth_mixin.dart';
import 'package:rovo_app/ui/utils/exception_utils.dart';
import 'package:rovo_app/ui/utils/ui_helper.dart';

const REQUESTING_PERMISSIONS = ["public_profile", "email", "user_friends"];

mixin FacebookConnectMixin {
  Future<FacebookAccessToken> getCurrentFacebookToken() async {
    final facebookLogin = FacebookLogin();
    final accessToken = await facebookLogin.currentAccessToken;
    return accessToken;
  }

  Future<bool> isConnectedToFacebook() {
    return FacebookLogin().isLoggedIn;
  }

  Future<FacebookAccessToken> connectFacebookThenSyncFriends() async {
    final facebookAccessToken = await connectFacebook();
    if (facebookAccessToken != null) {
      await syncFacebookFriends(
          facebookAccessToken.userId, facebookAccessToken.token);
    }
    return facebookAccessToken;
  }

  Future<FacebookAccessToken> connectFacebook() async {
    final facebookLogin = FacebookLogin();
    final result =
        await facebookLogin.logInWithReadPermissions(REQUESTING_PERMISSIONS);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        return result.accessToken;
      case FacebookLoginStatus.cancelledByUser:
        return null;
      case FacebookLoginStatus.error:
        ExceptionUtils.show(result.errorMessage);
        return null;
        break;
    }
    return null;
  }

  Future<List<Profile>> syncFacebookFriends(
      String facebookId, String facebookToken) {
    return kiwi.Container()
        .resolve<ApiProvider>()
        .syncFacebookFriends(facebookId, facebookToken);
  }

  clearFacebookToken() async {
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
  }
}

mixin FacebookAuthMixin on BaseAuthMixin {
  // Connect with facebook account to sync friends, return faceboo token
  Future<String> facebookContect() async {
    final facebookLogin = FacebookLogin();
    final accessToken = await facebookLogin.currentAccessToken;
    if (accessToken != null) {
      return accessToken.token;
    }
    accountStore.setIsAuthenticatingWithProvider(true);
    try {
      final result =
          await facebookLogin.logInWithReadPermissions(REQUESTING_PERMISSIONS);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final facebookToken = result.accessToken.token;
          return facebookToken;
          break;
        case FacebookLoginStatus.cancelledByUser:
          return null;
          break;
        case FacebookLoginStatus.error:
          ExceptionUtils.show(result.errorMessage);
          return null;
          break;
        default:
          return null;
      }
    } catch (e) {
      rethrow;
    } finally {
      accountStore.setIsAuthenticatingWithProvider(false);
    }
  }

  Future<dynamic> facebookLogin() async {
    final facebookLogin = FacebookLogin();
    accountStore.setIsAuthenticatingWithProvider(true);
    try {
      final result =
          await facebookLogin.logInWithReadPermissions(REQUESTING_PERMISSIONS);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final facebookToken = result.accessToken.token;
          final email = await getFacebookEmailFromToken(facebookToken);
          // If email exists, check for existing providers and ask user if new account should be created
          bool shouldContinue = false;
          if (email != null && email.length > 0) {
            shouldContinue = await shouldContinueAfterCheckingExistingAccount(
              email,
              IdentityProvider.Facebook,
            );
          }
          if (!shouldContinue) {
            return null;
          }
          // Continue logging user in or creating new account
          final res = await showLoadingPopup(
            buildContext,
            accountStore.authenticate(
              IdentityProvider.Facebook,
              facebookToken,
            ),
          );
          if (res.isSignup) {
            final channel = Provider.of<PlatformChannel>(buildContext);
            final profile = res.account.profile;
            channel.consentGranted(
              username: profile?.username,
              profileId: profile?.id,
              eventName: 'Facebook',
            );
          }
          break;
        case FacebookLoginStatus.cancelledByUser:
          break;
        case FacebookLoginStatus.error:
          ExceptionUtils.show(result.errorMessage);
          break;
      }
    } catch (e) {
      rethrow;
    } finally {
      accountStore.setIsAuthenticatingWithProvider(false);
    }
  }
}
