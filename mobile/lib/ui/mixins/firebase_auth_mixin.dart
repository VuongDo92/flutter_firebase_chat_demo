import 'dart:async';

import 'package:core/repositories/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rovo_app/platform_channel.dart';
import 'package:rovo_app/ui/screens/auth/mixins/base_auth_mixin.dart';
import 'package:rovo_app/ui/utils/exception_utils.dart';
import 'package:rovo_app/ui/utils/ui_helper.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

mixin FirebaseAuthMixin on BaseAuthMixin {
  Future<bool> firebaseLogin(String email, String password) async {
    accountStore.setIsAuthenticatingWithProvider(true);
    try {
      final FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String token = await user.getIdToken();
      await showLoadingPopup(
        buildContext,
        accountStore.authenticate(IdentityProvider.Firebase, token),
      );
      return true;
    } catch (e) {
      ExceptionUtils.show(e, context: buildContext);
      return false;
    } finally {
      accountStore.setIsAuthenticatingWithProvider(false);
    }
  }

  Future<bool> firebaseSignup(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    accountStore.setIsAuthenticatingWithProvider(true);
    try {
      bool shouldContinue = false;
      if (email != null && email.length > 0) {
        shouldContinue = await shouldContinueAfterCheckingExistingAccount(
            email.trim().toLowerCase(), IdentityProvider.Firebase);
      }
      if (!shouldContinue) {
        return false;
      }

      final channel = Provider.of<PlatformChannel>(buildContext);

      await showLoadingPopup(buildContext, Future(() async {
        final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
          email: email.trim().toLowerCase(),
          password: password,
        );
        String token = await user.getIdToken(refresh: true);
        final result = await accountStore.authenticate(
          IdentityProvider.Firebase,
          token,
          firstName: firstName,
          lastName: lastName,
        );

        if (result.isSignup) {
          final profile = result.account.profile;
          channel.consentGranted(
            username: profile?.username,
            profileId: profile?.id,
            eventName: 'Email',
          );
        }
        if (!user.isEmailVerified) {
          await user.sendEmailVerification();
        }
      }));
      return true;
    } catch (e) {
      ExceptionUtils.show(e, context: buildContext);
      return false;
    } finally {
      accountStore.setIsAuthenticatingWithProvider(false);
    }
  }

  Future<bool> sendResetPasswordEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      ExceptionUtils.show(e, context: buildContext);
      return false;
    }
  }
}
