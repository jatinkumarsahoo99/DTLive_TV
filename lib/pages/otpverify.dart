import 'dart:developer';

import 'package:dtlive/pages/home.dart';
import 'package:dtlive/provider/generalprovider.dart';
import 'package:dtlive/provider/homeprovider.dart';
import 'package:dtlive/provider/sectiondataprovider.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/utils/sharedpre.dart';
import 'package:dtlive/widget/focusbase.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class OTPVerify extends StatefulWidget {
  final String mobileNumber;
  const OTPVerify(this.mobileNumber, {Key? key}) : super(key: key);

  @override
  State<OTPVerify> createState() => OTPVerifyState();
}

class OTPVerifyState extends State<OTPVerify> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late ProgressDialog prDialog;
  SharedPre sharePref = SharedPre();
  final pinPutController = TextEditingController();
  String? verificationId;
  int? forceResendingToken;
  bool codeResended = false;

  @override
  void initState() {
    super.initState();
    prDialog = ProgressDialog(context);
    codeSend(false);
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    pinPutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width > 400
                  ? 400
                  : MediaQuery.of(context).size.width,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyText(
                    color: white,
                    text: "verifyphonenumber",
                    fontsizeNormal: 22,
                    fontsizeWeb: 18,
                    multilanguage: true,
                    fontweight: FontWeight.bold,
                    maxline: 2,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    fontstyle: FontStyle.normal,
                  ),
                  const SizedBox(height: 8),
                  MyText(
                    color: otherColor,
                    text: "code_sent_desc",
                    fontsizeNormal: 15,
                    fontsizeWeb: 14,
                    fontweight: FontWeight.w500,
                    maxline: 3,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    multilanguage: true,
                    fontstyle: FontStyle.normal,
                  ),
                  MyText(
                    color: otherColor,
                    text: widget.mobileNumber,
                    fontsizeNormal: 15,
                    fontsizeWeb: 14,
                    fontweight: FontWeight.w500,
                    maxline: 3,
                    overflow: TextOverflow.ellipsis,
                    textalign: TextAlign.center,
                    multilanguage: false,
                    fontstyle: FontStyle.normal,
                  ),
                  const SizedBox(height: 40),

                  /* Enter Received OTP */
                  Pinput(
                    length: 6,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: pinPutController,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    defaultPinTheme: PinTheme(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor, width: 0.7),
                        shape: BoxShape.rectangle,
                        color: edtBG,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      textStyle: GoogleFonts.montserrat(
                        color: white,
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  /* Confirm Button */
                  FocusBase(
                    focusColor: white,
                    onFocus: (isFocused) {},
                    onPressed: () {
                      debugPrint(
                          "Clicked sms Code =====> ${pinPutController.text}");
                      if (pinPutController.text.toString().isEmpty) {
                        Utils.showSnackbar(
                            context, "info", "enterreceivedotp", true);
                      } else {
                        Utils.showProgress(context, prDialog);
                        _checkOTPAndLogin();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width > 720
                          ? (MediaQuery.of(context).size.width * 0.4)
                          : 200,
                      height: 45,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            primaryLight,
                            primaryDark,
                          ],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      alignment: Alignment.center,
                      child: MyText(
                        color: white,
                        text: "confirm",
                        fontsizeNormal: 17,
                        fontsizeWeb: 17,
                        multilanguage: true,
                        fontweight: FontWeight.w700,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  /* Resend */
                  FocusBase(
                    focusColor: gray.withOpacity(0.5),
                    onFocus: (isFocused) {},
                    onPressed: () {
                      if (!codeResended) {
                        codeSend(true);
                      }
                    },
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 70),
                      padding: const EdgeInsets.all(5),
                      child: MyText(
                        color: white,
                        text: "resend",
                        multilanguage: true,
                        fontsizeNormal: 15,
                        fontsizeWeb: 16,
                        fontweight: FontWeight.w700,
                        maxline: 1,
                        overflow: TextOverflow.ellipsis,
                        textalign: TextAlign.center,
                        fontstyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  codeSend(bool isResend) async {
    codeResended = isResend;
    await phoneSignIn(phoneNumber: widget.mobileNumber.toString());
    prDialog.hide();
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: phoneNumber,
      forceResendingToken: forceResendingToken,
      verificationCompleted: _onVerificationCompleted,
      verificationFailed: _onVerificationFailed,
      codeSent: _onCodeSent,
      codeAutoRetrievalTimeout: _onCodeTimeout,
    );
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    log("verification completed ======> ${authCredential.smsCode}");
    setState(() {
      pinPutController.text = authCredential.smsCode ?? "";
    });
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      log("The phone number entered is invalid!");
      Utils.showSnackbar(context, "fail", "invalidphonenumber", true);
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    this.verificationId = verificationId;
    this.forceResendingToken = forceResendingToken;
    log("verificationId =======> $verificationId");
    log("resendingToken =======> ${forceResendingToken.toString()}");
    log("code sent");
  }

  _onCodeTimeout(String verificationId) {
    log("_onCodeTimeout verificationId =======> $verificationId");
    this.verificationId = verificationId;
    prDialog.hide();
    codeResended = false;
    return null;
  }

  _checkOTPAndLogin() async {
    bool error = false;
    UserCredential? userCredential;

    log("_checkOTPAndLogin verificationId =====> $verificationId");
    log("_checkOTPAndLogin smsCode =====> ${pinPutController.text}");
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential? phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: verificationId ?? "",
      smsCode: pinPutController.text.toString(),
    );

    log("phoneAuthCredential.smsCode        =====> ${phoneAuthCredential.smsCode}");
    log("phoneAuthCredential.verificationId =====> ${phoneAuthCredential.verificationId}");
    try {
      userCredential = await _auth.signInWithCredential(phoneAuthCredential);
      log("_checkOTPAndLogin userCredential =====> ${userCredential.user?.phoneNumber ?? ""}");
    } on FirebaseAuthException catch (e) {
      await prDialog.hide();
      log("_checkOTPAndLogin error Code =====> ${e.code}");
      if (e.code == 'invalid-verification-code' ||
          e.code == 'invalid-verification-id') {
        if (!mounted) return;
        Utils.showSnackbar(context, "info", "otp_invalid", true);
        return;
      } else if (e.code == 'session-expired') {
        if (!mounted) return;
        Utils.showSnackbar(context, "fail", "otp_session_expired", true);
        return;
      } else {
        error = true;
      }
    }
    log("Firebase Verification Complated & phoneNumber => ${userCredential?.user?.phoneNumber} and isError => $error");
    if (!error && userCredential != null) {
      _login(widget.mobileNumber.toString());
    } else {
      await prDialog.hide();
      if (!mounted) return;
      Utils.showSnackbar(context, "fail", "otp_login_fail", true);
    }
  }

  _login(String mobile) async {
    log("click on Submit mobile => $mobile");
    var generalProvider = Provider.of<GeneralProvider>(context, listen: false);
    if (!prDialog.isShowing()) {
      Utils.showProgress(context, prDialog);
    }
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final sectionDataProvider =
        Provider.of<SectionDataProvider>(context, listen: false);
    await generalProvider.loginWithOTP(mobile);

    if (!generalProvider.loading) {
      if (generalProvider.loginOTPModel.status == 200) {
        log('loginOTPModel ==>> ${generalProvider.loginOTPModel.toString()}');
        log('Login Successfull!');
        await sharePref.save(
            "userid", generalProvider.loginOTPModel.result?[0].id.toString());
        await sharePref.save("username",
            generalProvider.loginOTPModel.result?[0].name.toString() ?? "");
        await sharePref.save("userimage",
            generalProvider.loginOTPModel.result?[0].image.toString() ?? "");
        await sharePref.save("useremail",
            generalProvider.loginOTPModel.result?[0].email.toString() ?? "");
        await sharePref.save("usermobile",
            generalProvider.loginOTPModel.result?[0].mobile.toString() ?? "");
        await sharePref.save("usertype",
            generalProvider.loginOTPModel.result?[0].type.toString() ?? "");

        // Set UserID for Next
        Constant.userID =
            generalProvider.loginOTPModel.result?[0].id.toString();
        log('Constant userID ==>> ${Constant.userID}');

        await homeProvider.setLoading(true);
        await sectionDataProvider.getSectionBanner("0", "1");
        await sectionDataProvider.getSectionList("0", "1");

        await prDialog.hide();
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Home(pageName: ''),
          ),
        );
      } else {
        await prDialog.hide();
        if (!mounted) return;
        Utils.showSnackbar(
            context, "fail", "${generalProvider.loginOTPModel.message}", false);
      }
    }
  }
}
