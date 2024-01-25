import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dtlive/pages/home.dart';
import 'package:dtlive/pages/otpverify.dart';
import 'package:dtlive/provider/generalprovider.dart';
import 'package:dtlive/provider/homeprovider.dart';
import 'package:dtlive/provider/sectiondataprovider.dart';
import 'package:dtlive/utils/color.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:dtlive/utils/sharedpre.dart';
import 'package:dtlive/utils/strings.dart';
import 'package:dtlive/widget/focusbase.dart';
import 'package:dtlive/widget/myimage.dart';
import 'package:dtlive/widget/mytext.dart';
import 'package:dtlive/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class LoginSocial extends StatefulWidget {
  const LoginSocial({Key? key}) : super(key: key);

  @override
  State<LoginSocial> createState() => LoginSocialState();
}

class LoginSocialState extends State<LoginSocial> {
  late ProgressDialog prDialog;
  SharedPre sharePref = SharedPre();
  final numberController = TextEditingController();
  String? mobileNumber,
      email,
      userName,
      strType,
      strPrivacyAndTNC,
      privacyUrl,
      termsConditionUrl;
  File? mProfileImg;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    prDialog = ProgressDialog(context);
    _getData();
  }

  _getData() async {
    privacyUrl = await sharePref.read("privacy-policy") ?? "";
    termsConditionUrl = await sharePref.read("terms-and-conditions") ?? "";
    debugPrint('privacyUrl ==> $privacyUrl');
    debugPrint('termsConditionUrl ==> $termsConditionUrl');

    strPrivacyAndTNC =
        "<p style=color:white; > By continuing , I understand and agree with <a href=$privacyUrl>Privacy Policy</a> and <a href=$termsConditionUrl>Terms and Conditions</a> of ${Constant.appName}. </p>";
    Future.delayed(Duration.zero).then((value) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      body: Center(
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
                Container(
                  width: 170,
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: MyImage(
                    fit: BoxFit.fill,
                    imagePath: "appicon.png",
                  ),
                ),
                const SizedBox(height: 10),
                MyText(
                  color: white,
                  text: "welcomeback",
                  fontsizeNormal: 18,
                  fontsizeWeb: 18,
                  multilanguage: true,
                  fontweight: FontWeight.bold,
                  maxline: 1,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal,
                ),
                const SizedBox(height: 7),
                MyText(
                  color: otherColor,
                  text: "login_with_mobile_note",
                  fontsizeNormal: 14,
                  fontsizeWeb: 14,
                  multilanguage: true,
                  fontweight: FontWeight.w500,
                  maxline: 2,
                  overflow: TextOverflow.ellipsis,
                  textalign: TextAlign.center,
                  fontstyle: FontStyle.normal,
                ),
                const SizedBox(height: 20),

                /* Enter Mobile Number */
                Container(
                  width: MediaQuery.of(context).size.width > 720
                      ? (MediaQuery.of(context).size.width * 0.5)
                      : 200,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: primaryColor,
                      width: 0.7,
                    ),
                    // color: edtBG,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: IntlPhoneField(
                    disableLengthCheck: true,
                    textAlignVertical: TextAlignVertical.center,
                    autovalidateMode: AutovalidateMode.disabled,
                    controller: numberController,
                    style: const TextStyle(fontSize: 16, color: white),
                    showCountryFlag: false,
                    showDropdownIcon: false,
                    initialCountryCode: 'IN',
                    dropdownTextStyle: GoogleFonts.montserrat(
                      color: white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: false,
                      hintStyle: GoogleFonts.montserrat(
                        color: otherColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      hintText: enterYourMobileNumber,
                    ),
                    onChanged: (phone) {
                      log('===> ${phone.completeNumber}');
                      log('===> ${numberController.text}');
                      mobileNumber = phone.completeNumber;
                      log('===>mobileNumber $mobileNumber');
                    },
                    onCountryChanged: (country) {
                      log('===> ${country.name}');
                      log('===> ${country.code}');
                    },
                  ),
                ),
                const SizedBox(height: 20),

                /* Login Button */
                FocusBase(
                  focusColor: white,
                  onFocus: (isFocused) {},
                  onPressed: () {
                    debugPrint("Click mobileNumber ==> $mobileNumber");
                    if (numberController.text.toString().isEmpty) {
                      Utils.showSnackbar(
                          context, "info", "login_with_mobile_note", true);
                    } else {
                      log("mobileNumber ==> $mobileNumber");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return OTPVerify(mobileNumber ?? "");
                          },
                        ),
                      );
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
                      text: "login",
                      multilanguage: true,
                      fontsizeNormal: 17,
                      fontsizeWeb: 19,
                      fontweight: FontWeight.w700,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                /* Privacy & TermsCondition link */
                if (strPrivacyAndTNC != null)
                  Container(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    width: (MediaQuery.of(context).size.width * 0.5),
                    child: Utils.htmlTexts(strPrivacyAndTNC),
                  ),
                const SizedBox(height: 10),

                /* Or */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 1,
                      color: accentColor,
                    ),
                    const SizedBox(width: 15),
                    MyText(
                      color: otherColor,
                      text: "or",
                      multilanguage: true,
                      fontsizeNormal: 14,
                      fontsizeWeb: 16,
                      fontweight: FontWeight.w500,
                      maxline: 1,
                      overflow: TextOverflow.ellipsis,
                      textalign: TextAlign.center,
                      fontstyle: FontStyle.normal,
                    ),
                    const SizedBox(width: 15),
                    Container(
                      width: 80,
                      height: 1,
                      color: accentColor,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /* Google Login Button */
                FocusBase(
                  focusColor: gray.withOpacity(0.5),
                  onFocus: (isFocused) {},
                  onPressed: () {
                    debugPrint("Clicked on : ====> loginWith Google");
                    _gmailLogin();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width > 720
                        ? (MediaQuery.of(context).size.width * 0.4)
                        : 200,
                    height: 45,
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                    decoration: Utils.setBackground(white, 4),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyImage(
                          width: 30,
                          height: 30,
                          imagePath: "ic_google.png",
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 30),
                        MyText(
                          color: black,
                          text: "loginwithgoogle",
                          fontsizeNormal: 14,
                          fontsizeWeb: 16,
                          multilanguage: true,
                          fontweight: FontWeight.w600,
                          maxline: 1,
                          overflow: TextOverflow.ellipsis,
                          textalign: TextAlign.center,
                          fontstyle: FontStyle.normal,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /* Apple Login Button */
                if (Platform.isIOS)
                  FocusBase(
                    focusColor: gray.withOpacity(0.5),
                    onFocus: (isFocused) {},
                    onPressed: () {
                      debugPrint("Clicked on : ====> loginWith Apple");
                      signInWithApple();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width > 720
                          ? (MediaQuery.of(context).size.width * 0.4)
                          : 200,
                      height: 45,
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                      decoration: Utils.setBackground(white, 4),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyImage(
                            width: 30,
                            height: 30,
                            imagePath: "ic_apple.png",
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 30),
                          MyText(
                            color: black,
                            text: "loginwithapple",
                            fontsizeNormal: 14,
                            fontsizeWeb: 16,
                            multilanguage: true,
                            fontweight: FontWeight.w600,
                            maxline: 1,
                            overflow: TextOverflow.ellipsis,
                            textalign: TextAlign.center,
                            fontstyle: FontStyle.normal,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (Platform.isIOS) const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* Google Login */
  Future<void> _gmailLogin() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    GoogleSignInAccount user = googleUser;

    debugPrint('GoogleSignIn ===> id : ${user.id}');
    debugPrint('GoogleSignIn ===> email : ${user.email}');
    debugPrint('GoogleSignIn ===> displayName : ${user.displayName}');
    debugPrint('GoogleSignIn ===> photoUrl : ${user.photoUrl}');

    if (!mounted) return;
    Utils.showProgress(context, prDialog);

    UserCredential userCredential;
    try {
      GoogleSignInAuthentication googleSignInAuthentication =
          await user.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      userCredential = await _auth.signInWithCredential(credential);
      assert(await userCredential.user?.getIdToken() != null);
      debugPrint("User Name: ${userCredential.user?.displayName}");
      debugPrint("User Email ${userCredential.user?.email}");
      debugPrint("User photoUrl ${userCredential.user?.photoURL}");
      debugPrint("uid ===> ${userCredential.user?.uid}");
      String firebasedid = userCredential.user?.uid ?? "";
      debugPrint('firebasedid :===> $firebasedid');

      /* Save PhotoUrl in File */
      mProfileImg =
          await Utils.saveImageInStorage(userCredential.user?.photoURL ?? "");
      debugPrint('mProfileImg :===> $mProfileImg');

      checkAndNavigate(user.email, user.displayName ?? "", "2");
    } on FirebaseAuthException catch (e) {
      debugPrint('Exp ===> ${e.code.toString()}');
      debugPrint('Exp ===> ${e.message.toString()}');
      if (e.code.toString() == "user-not-found") {
      } else if (e.code == 'wrong-password') {
        // Hide Progress Dialog
        await prDialog.hide();
        debugPrint('Wrong password provided.');
        Utils.showToast('Wrong password provided.');
      } else {
        // Hide Progress Dialog
        await prDialog.hide();
      }
    }
  }

  /* Apple Login */
  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User?> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      debugPrint(appleCredential.authorizationCode);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final authResult = await _auth.signInWithCredential(oauthCredential);

      String? displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      debugPrint("displayName ==1==> $displayName");

      final firebaseUser = authResult.user;
      debugPrint("==================================");

      final userEmail = firebaseUser?.email.toString();
      final firebasedId = firebaseUser?.uid.toString();
      final photoURL = firebaseUser?.photoURL.toString();
      displayName = firebaseUser?.displayName.toString();
      debugPrint("userEmail =======> $userEmail");
      debugPrint("firebasedId =====> $firebasedId");
      debugPrint("photoURL ========> $photoURL");
      debugPrint("displayName ==2==> $displayName");

      // await firebaseUser?.updateDisplayName(displayName);
      // await firebaseUser?.updatePhotoURL(photoURL);
      // await firebaseUser?.updateEmail(userEmail);

      /* Save PhotoUrl in File */
      if (photoURL != null || photoURL != "") {
        mProfileImg = await Utils.saveImageInStorage(photoURL);
      }

      checkAndNavigate(userEmail ?? "", displayName ?? "", "5");
    } catch (exception) {
      debugPrint("Apple Login exception =====> $exception");
    }
    return null;
  }

  checkAndNavigate(String mail, String displayName, String type) async {
    email = mail;
    userName = displayName;
    strType = type;
    log('checkAndNavigate email ==>> $email');
    log('checkAndNavigate userName ==>> $userName');
    log('checkAndNavigate strType ==>> $strType');
    log('checkAndNavigate mProfileImg :===> $mProfileImg');
    if (!prDialog.isShowing()) {
      Utils.showProgress(context, prDialog);
    }
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final sectionDataProvider =
        Provider.of<SectionDataProvider>(context, listen: false);
    final generalProvider =
        Provider.of<GeneralProvider>(context, listen: false);
    await generalProvider.loginWithSocial(
        email, userName, strType, mProfileImg);
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
        await prDialog.hide();
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Home(pageName: ''),
          ),
        );
      } else {
        // Hide Progress Dialog
        await prDialog.hide();
        if (!mounted) return;
        Utils.showSnackbar(context, "fail",
            "${generalProvider.loginGmailModel.message}", false);
      }
    }
  }
}
