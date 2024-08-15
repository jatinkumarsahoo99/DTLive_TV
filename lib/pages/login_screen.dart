import 'dart:developer';

import 'package:dtlive/pages/home.dart';
import 'package:dtlive/utils/sharedpre.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

import '../provider/generalprovider.dart';
import '../provider/homeprovider.dart';
import '../provider/sectiondataprovider.dart';
import '../utils/constant.dart';
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  ProgressDialog? prDialog;
  SharedPre sharePref = SharedPre();
  String? mobileNumber, email, userName, strType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login Screen'),
      // ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.indigo],
          ),
        ),
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Hero(
                    tag: 'logoTag',
                    child: Image.asset(
                      'assets/images/appicon.png', // Replace with your app logo
                      height: MediaQuery.of(context).size.width * 0.18,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30.0),
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        // onSubmitted: (s){
                        //   FocusScope.of(context).nextFocus();
                        // },
                        autofocus: true,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email/Phone',
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.email, color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        // onSubmitted: (s){
                        //   FocusScope.of(context).nextFocus();
                        // },
                        style: const TextStyle(color: Colors.white),
                        textInputAction: TextInputAction.next,
                        onSubmitted: (s){
                          debugPrint("object");
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          if (_emailController.text == "") {
                            Utils.showSnackbar(context, "info",
                                "login_with_mobile_note", true);
                          } else if (_passwordController.text == "") {
                            Utils.showSnackbar(
                                context, "info", "password_empty", true);
                          } else {
                            login(email, password);
                          }
                          debugPrint('Email: $email, Password: $password');
                        },
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      ElevatedButton(
                        onPressed: () {
                          // Add your authentication logic here
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          if (_emailController.text == "") {
                            Utils.showSnackbar(context, "info",
                                "login_with_mobile_note", true);
                          } else if (_passwordController.text == "") {
                            Utils.showSnackbar(
                                context, "info", "password_empty", true);
                          } else {
                            login(email, password);
                          }
                          debugPrint('Email: $email, Password: $password');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Replaces `primary`
                          foregroundColor: Colors.white,  // Replaces `onPrimary`
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 10,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login(String mobile, String password) async {
    prDialog ??= ProgressDialog(
        context,
        isDismissible: true,
        customBody: const LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          backgroundColor: Colors.white,
        ),
      );
    if (!(prDialog?.isShowing())!) {
      Utils.showProgress(context, prDialog!);
    }
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final sectionDataProvider =
        Provider.of<SectionDataProvider>(context, listen: false);
    final generalProvider =
        Provider.of<GeneralProvider>(context, listen: false);
    await generalProvider.loginWithSocial(mobile, password, "mobile", null);
    log('checkAndNavigate loading ==>> ${generalProvider.loading}');

    if (!generalProvider.loading) {
      if (generalProvider.loginGmailModel.status == 200) {
        log('loginGmailModel ==>> ${generalProvider.loginGmailModel.toString()}');
        log('Login Successfull!');
        await sharePref.save(
            "userid", generalProvider.loginGmailModel.result?[0].id.toString());
        await sharePref.save("username",
            generalProvider.loginGmailModel.result?[0].name.toString() ?? "");
        await sharePref.save("userimage",
            generalProvider.loginGmailModel.result?[0].image.toString() ?? "");
        await sharePref.save("useremail",
            generalProvider.loginGmailModel.result?[0].email.toString() ?? "");
        await sharePref.save("usermobile",
            generalProvider.loginGmailModel.result?[0].mobile.toString() ?? "");
        await sharePref.save("usertype",
            generalProvider.loginGmailModel.result?[0].type.toString() ?? "");

        // Set UserID for Next
        Constant.userID =
            generalProvider.loginGmailModel.result?[0].id.toString();
        log('Constant userID ==>> ${Constant.userID}');

        await homeProvider.setSelectedTab(0);
        await sectionDataProvider.getSectionBanner("0", "1");
        await sectionDataProvider.getSectionList("0", "1");

        // Hide Progress Dialog
        await (prDialog?.hide())!;
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Home(pageName: ""),
          ),
        );
      } else {
        // Hide Progress Dialog
        await (prDialog?.hide())!;
        if (!mounted) return;
        Utils.showSnackbar(context, "Login Failed",
            "${generalProvider.loginGmailModel.message}", false);
      }
    }
  }

  void checkAndNavigate(String mail, String displayName, String type) async {
    email = mail;
    userName = displayName;
    strType = type;
    log('checkAndNavigate email ==>> $email');
    log('checkAndNavigate userName ==>> $userName');
    log('checkAndNavigate strType ==>> $strType');
    // log('checkAndNavigate mProfileImg :===> $mProfileImg');
    if (!(prDialog?.isShowing())!) {
      Utils.showProgress(context, prDialog!);
    }
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final sectionDataProvider =
        Provider.of<SectionDataProvider>(context, listen: false);
    final generalProvider =
        Provider.of<GeneralProvider>(context, listen: false);
    await generalProvider.loginWithSocial(email, userName, "mobile", null);
    log('checkAndNavigate loading ==>> ${generalProvider.loading}');

    if (!generalProvider.loading) {
      if (generalProvider.loginGmailModel.status == 200) {
        log('loginGmailModel ==>> ${generalProvider.loginGmailModel.toString()}');
        log('Login Successfull!');
        await sharePref.save(
            "userid", generalProvider.loginGmailModel.result?[0].id.toString());
        await sharePref.save("username",
            generalProvider.loginGmailModel.result?[0].name.toString() ?? "");
        await sharePref.save("userimage",
            generalProvider.loginGmailModel.result?[0].image.toString() ?? "");
        await sharePref.save("useremail",
            generalProvider.loginGmailModel.result?[0].email.toString() ?? "");
        await sharePref.save("usermobile",
            generalProvider.loginGmailModel.result?[0].mobile.toString() ?? "");
        await sharePref.save("usertype",
            generalProvider.loginGmailModel.result?[0].type.toString() ?? "");

        // Set UserID for Next
        Constant.userID =
            generalProvider.loginGmailModel.result?[0].id.toString();
        log('Constant userID ==>> ${Constant.userID}');

        await homeProvider.setSelectedTab(0);
        await sectionDataProvider.getSectionBanner("0", "1");
        await sectionDataProvider.getSectionList("0", "1");

        // Hide Progress Dialog
        await (prDialog?.hide())!;
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Home(pageName: ""),
          ),
        );
      } else {
        // Hide Progress Dialog
        await (prDialog?.hide())!;
        if (!mounted) return;
        Utils.showSnackbar(context, "fail",
            "${generalProvider.loginGmailModel.message}", false);
      }
    }
  }
}
