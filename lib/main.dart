import 'package:bank_sha_rafi/blocs/user/user_bloc.dart';
import 'package:bank_sha_rafi/shared/theme.dart';
import 'package:bank_sha_rafi/ui/pages/home_page.dart';
import 'package:bank_sha_rafi/ui/pages/onboarding_page.dart';
import 'package:bank_sha_rafi/ui/pages/pin_page.dart';
import 'package:bank_sha_rafi/ui/pages/profile_edit_success_page.dart';
import 'package:bank_sha_rafi/ui/pages/profile_page.dart';
import 'package:bank_sha_rafi/ui/pages/service_page.dart';
import 'package:bank_sha_rafi/ui/pages/sign_in_page.dart';
import 'package:bank_sha_rafi/ui/pages/sign_up_page.dart';
import 'package:bank_sha_rafi/ui/pages/sign_up_set_ktp_page.dart';
import 'package:bank_sha_rafi/ui/pages/sign_up_set_profile_page.dart';
import 'package:bank_sha_rafi/ui/pages/sign_up_success_page.dart';
import 'package:bank_sha_rafi/ui/pages/splash_page.dart';
import 'package:bank_sha_rafi/ui/pages/topup_page.dart';
import 'package:bank_sha_rafi/ui/pages/topup_success.dart';
import 'package:bank_sha_rafi/ui/pages/transfer_page.dart';
import 'package:bank_sha_rafi/ui/pages/transfer_success_page.dart';
import 'package:bank_sha_rafi/ui/pages/service_success_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/service_form/service_form_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(AuthGetCurrent()),
        ),
        BlocProvider(
          create: (context) => UserBloc(),
        ),
        BlocProvider(
          create: (context) => ServiceBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: lightBackgroundColor,
          appBarTheme: AppBarTheme(
            backgroundColor: lightBackgroundColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(
              color: blackColor,
            ),
            titleTextStyle: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: semiBold,
            ),
          ),
        ),
        routes: {
          '/': (context) => const SplashPage(),
          '/onboarding': (context) => const OnboardingPage(),
          '/sign-in': (context) => const SignInPage(),
          '/sign-up': (context) => const SignUpPage(),
          // '/sign-up-set-profile': (context) => const SignUpSetProfilePage(),
          // '/sign-up-set-ktp': (context) => const SignUpSetKtpPage(),
          '/sign-up-success': (context) => const SignUpSuccessPage(),
          '/home': (context) => const HomePage(),
          '/profile': (context) => const ProfilePage(),
          '/pin': (context) => const PinPage(),
          '/profile-edit-success': (context) => const ProfileEditSuccessPage(),
          '/topup': (context) => const TopupPage(),
          '/topup-success': (context) => const TopupSuccessPage(),
          '/transfer': (context) => const TransferPage(),
          '/transfer-success': (context) => const TransferSuccessPage(),
          '/service': (context) => const ServicePage(), 
          '/service-success': (context) => const ServiceSuccessPage(),
          '/sign-out': (context) => const OnboardingPage(),
        },
      ),
    );
  }
}
