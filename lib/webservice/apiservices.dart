import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dtlive/model/avatarmodel.dart';
import 'package:dtlive/model/castdetailmodel.dart';
import 'package:dtlive/model/couponmodel.dart';
import 'package:dtlive/model/historymodel.dart';
import 'package:dtlive/model/pagesmodel.dart';
import 'package:dtlive/model/paymentoptionmodel.dart';
import 'package:dtlive/model/paytmmodel.dart';
import 'package:dtlive/model/subscriptionmodel.dart';
import 'package:dtlive/model/channelsectionmodel.dart';
import 'package:dtlive/model/episodebyseasonmodel.dart';
import 'package:dtlive/model/generalsettingmodel.dart';
import 'package:dtlive/model/genresmodel.dart';
import 'package:dtlive/model/langaugemodel.dart';
import 'package:dtlive/model/loginregistermodel.dart';
import 'package:dtlive/model/profilemodel.dart';
import 'package:dtlive/model/rentmodel.dart';
import 'package:dtlive/model/searchmodel.dart';
import 'package:dtlive/model/sectionbannermodel.dart';
import 'package:dtlive/model/sectiondetailmodel.dart';
import 'package:dtlive/model/sectionlistmodel.dart';
import 'package:dtlive/model/sectiontypemodel.dart';
import 'package:dtlive/model/successmodel.dart';
import 'package:dtlive/model/tvcodemodel.dart';
import 'package:dtlive/model/videobyidmodel.dart';
import 'package:dtlive/model/watchlistmodel.dart';
import 'package:dtlive/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../model/VersionModel.dart';

class ApiService {
  String baseUrl = Constant.baseurl;

  late Dio dio;

  Options optHeaders = Options(headers: <String, dynamic>{
    'Content-Type': 'application/json',
  });

  ApiService() {
    dio = Dio();
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      ),
    );
  }

  // general_setting API
  Future<GeneralSettingModel> genaralSetting() async {
    GeneralSettingModel generalSettingModel;
    String generalsetting = "general_setting";
    Response response = await dio.post(
      '$baseUrl$generalsetting',
      options: optHeaders,
    );
    generalSettingModel = GeneralSettingModel.fromJson(response.data);
    return generalSettingModel;
  }

  // get_pages API
  Future<PagesModel> getPages() async {
    PagesModel pagesModel;
    String getPagesAPI = "get_pages";
    Response response = await dio.post(
      '$baseUrl$getPagesAPI',
      options: optHeaders,
    );
    pagesModel = PagesModel.fromJson(response.data);
    return pagesModel;
  }

  /* type => 1-Facebook, 2-Google */
  // login API
  Future<LoginRegisterModel> loginWithSocial(
      email, name, type, File? profileImg) async {
    log("email :==> $email");
    log("name :==> $name");
    log("type :==> $type");
    log("profileImg :==> $profileImg");

    LoginRegisterModel loginModel;
    String gmailLogin = "login";
    Response response = await dio.post(
      '$baseUrl$gmailLogin',
      options: optHeaders,
      data: FormData.fromMap({
        // 'type': type,
        // 'email': email,
        // 'name': name,
        'mobile': email,
        'password': name,
        /*'image': (profileImg?.path ?? "").isNotEmpty
            ? await MultipartFile.fromFile(
                profileImg?.path ?? "",
                filename: (profileImg?.path ?? "").split('/').last,
              )
            : "",*/
      }),
    );

    loginModel = LoginRegisterModel.fromJson(response.data);
    return loginModel;
  }

  /* type => 3-OTP */
  // login API
  Future<LoginRegisterModel> loginWithOTP(mobile) async {
    log("mobile :==> $mobile");

    LoginRegisterModel loginModel;
    String doctorLogin = "login";
    Response response = await dio.post(
      '$baseUrl$doctorLogin',
      options: optHeaders,
      data: {
        'type': '3',
        'mobile': mobile,
      },
    );

    loginModel = LoginRegisterModel.fromJson(response.data);
    return loginModel;
  }

  // get_tv_login_code API
  Future<TvCodeModel> tvLoginCode(deviceToken) async {
    log("deviceToken :==> $deviceToken");

    TvCodeModel tvCodeModel;
    String tvLoginCodeAPI = "get_tv_login_code";
    Response response = await dio.post(
      '$baseUrl$tvLoginCodeAPI',
      options: optHeaders,
      data: {
        'device_token': deviceToken,
      },
    );

    tvCodeModel = TvCodeModel.fromJson(response.data);
    return tvCodeModel;
  }

  // forgot_password API
  Future<SuccessModel> forgotPassword(email) async {
    log("email :==> $email");

    SuccessModel successModel;
    String doctorLogin = "forgot_password";
    Response response = await dio.post(
      '$baseUrl$doctorLogin',
      options: optHeaders,
      data: {
        'email': email,
      },
    );

    successModel = successModelFromJson(response.data.toString());
    return successModel;
  }

  // general_setting API
  Future<VersionModel> getVersion() async {
    VersionModel versionModel;
    String generalsetting = "get_version_controller";
    Response response = await dio.post(
      '$baseUrl$generalsetting',
      options: optHeaders,
    );
    versionModel = VersionModel.fromJson(response.data);
    return versionModel;
  }

  // get_profile API
  Future<ProfileModel> profile() async {
    log("profile userID :==> ${Constant.userID}");

    ProfileModel profileModel;
    String doctorLogin = "get_profile";
    Response response = await dio.post(
      '$baseUrl$doctorLogin',
      options: optHeaders,
      data: {
        'id': Constant.userID,
      },
    );

    profileModel = ProfileModel.fromJson(response.data);
    return profileModel;
  }

  // update_profile API
  Future<SuccessModel> updateProfile(name) async {
    log("updateProfile userID :==> ${Constant.userID}");
    log("updateProfile name :==> $name");

    SuccessModel successModel;
    String doctorLogin = "update_profile";
    Response response = await dio.post(
      '$baseUrl$doctorLogin',
      options: optHeaders,
      data: {
        'id': Constant.userID,
        'name': name,
      },
    );

    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  // image_upload API
  Future<SuccessModel> imageUpload(File? profileImg) async {
    log("ProfileImg Filename :==> ${profileImg?.path.split('/').last}");
    log("profileImg Extension :==> ${profileImg?.path.split('/').last.split(".").last}");
    SuccessModel uploadImgModel;
    String uploadImage = "image_upload";
    log("imageUpload API :==> $baseUrl$uploadImage");
    Response response = await dio.post(
      '$baseUrl$uploadImage',
      data: FormData.fromMap({
        'id': Constant.userID,
        'image': (profileImg?.path ?? "").isNotEmpty
            ? await MultipartFile.fromFile(
                profileImg?.path ?? "",
                filename: (profileImg?.path ?? "").split('/').last,
              )
            : "",
      }),
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    uploadImgModel = SuccessModel.fromJson(response.data);
    return uploadImgModel;
  }

  // get_avatar API
  Future<AvatarModel> getAvatar() async {
    AvatarModel avatarModel;
    String getAvatar = "get_avatar";
    Response response = await dio.post(
      '$baseUrl$getAvatar',
      options: optHeaders,
      data: {},
    );
    avatarModel = AvatarModel.fromJson(response.data);
    return avatarModel;
  }

  /* type => 1-movies, 2-news, 3-sport, 4-tv show */
  // get_type API
  Future<SectionTypeModel> sectionType() async {
    SectionTypeModel sectionTypeModel;
    String sectionType = "get_type";
    Response response = await dio.post(
      '$baseUrl$sectionType',
      options: optHeaders,
    );
    sectionTypeModel = SectionTypeModel.fromJson(response.data);
    return sectionTypeModel;
  }

  // get_banner API
  Future<SectionBannerModel> sectionBanner(typeId, isHomePage) async {
    log('sectionBanner typeId ==>>> $typeId');
    log('sectionBanner isHomePage ==>>> $isHomePage');
    SectionBannerModel sectionBannerModel;
    String sectionBanner = "get_banner";
    Response response = await dio.post(
      '$baseUrl$sectionBanner',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
        'type_id': typeId,
        'is_home_page': isHomePage,
      },
    );
    sectionBannerModel = SectionBannerModel.fromJson(response.data);
    return sectionBannerModel;
  }

  // section_list API
  Future<SectionListModel> sectionList(typeId, isHomePage) async {
    SectionListModel sectionListModel;
    String sectionList = "section_list";
    Response response = await dio.post(
      '$baseUrl$sectionList',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
        'type_id': typeId,
        'is_home_page': isHomePage,
      },
    );
    sectionListModel = SectionListModel.fromJson(response.data);
    return sectionListModel;
  }

  // section_detail API
  Future<SectionDetailModel> sectionDetails(
      typeId, videoType, videoId, upcomingType) async {
    SectionDetailModel sectionDetailModel;
    String sectionList = "section_detail";
    Response ?response;
    try{
       response = await dio.post(
        '$baseUrl$sectionList',
        options: optHeaders,
        data: {
          'user_id': Constant.userID,
          'type_id': typeId,
          'video_type': videoType,
          'video_id': videoId,
          'upcoming_type': upcomingType,
        },
      );
    }catch(e){
      response = Response(requestOptions: RequestOptions(),data: null);
    }

    sectionDetailModel = SectionDetailModel.fromJson(response.data);
    return sectionDetailModel;
  }

  // video_view API
  Future<SuccessModel> videoView(videoId, videoType, otherId) async {
    debugPrint('videoView videoId ====>>> $videoId');
    debugPrint('videoView videoType ==>>> $videoType');
    debugPrint('videoView otherId ====>>> $otherId');
    SuccessModel successModel;
    String sectionList = "video_view";
    Response ?response;
    try{
       response = await dio.post(
        '$baseUrl$sectionList',
        options: optHeaders,
        data: {
          'user_id': Constant.userID,
          'video_id': videoId,
          'video_type': videoType,
          'other_id': otherId,
        },
      );
    }catch(e){
      response = Response(requestOptions: RequestOptions(),data: {"status":1,"message":""});
    }

    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  // add_remove_bookmark API
  Future<SuccessModel> addRemoveBookmark(typeId, videoType, videoId) async {
    SuccessModel successModel;
    String sectionList = "add_remove_bookmark";
    Response response = await dio.post(
      '$baseUrl$sectionList',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
        'type_id': typeId,
        'video_type': videoType,
        'video_id': videoId,
      },
    );
    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  // add_continue_watching API
  Future<SuccessModel> addContinueWatching(videoId, videoType, stopTime) async {
    SuccessModel successModel;
    String continueWatching = "add_continue_watching";
    Response response = await dio.post(
      '$baseUrl$continueWatching',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
        'video_id': videoId,
        'video_type': videoType,
        'stop_time': stopTime,
      },
    );
    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  // remove_continue_watching API
  /* user_id, video_id, video_type
     * Show :=> ("video_id" = Episode's ID)  AND  ("video_type" = "2")
     * Video :=> ("video_id" = Video's ID) */
  Future<SuccessModel> removeContinueWatching(videoId, videoType) async {
    SuccessModel successModel;
    String removeContinueWatching = "remove_continue_watching";
    Response response = await dio.post(
      '$baseUrl$removeContinueWatching',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
        'video_type': videoType,
        'video_id': videoId,
      },
    );
    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  // add_remove_download API
  /* user_id, video_id, video_type, type_id, other_id
     * Show :=> ("video_id" = Session's ID)  AND  ("other_id" = Show's ID)
     * Video :=> ("other_id" = "0") */
  Future<SuccessModel> addRemoveDownload(
      videoId, videoType, typeId, otherId) async {
    SuccessModel successModel;
    String addRemoveDownload = "add_remove_download";
    Response response = await dio.post(
      '$baseUrl$addRemoveDownload',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
        'video_id': videoId,
        'video_type': videoType,
        'type_id': typeId,
        'other_id': otherId,
      },
    );
    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  // get_video_by_session_id API
  Future<EpisodeBySeasonModel> episodeBySeason(seasonId, showId) async {
    EpisodeBySeasonModel episodeBySeasonModel;
    String episodeBySeasonList = "get_video_by_session_id";
    Response response = await dio.post(
      '$baseUrl$episodeBySeasonList',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
        'session_id': seasonId,
        'show_id': showId,
      },
    );
    episodeBySeasonModel = EpisodeBySeasonModel.fromJson(response.data);
    return episodeBySeasonModel;
  }

  // cast_detail API
  Future<CastDetailModel> getCastDetails(castId) async {
    CastDetailModel castDetailModel;
    String castDetails = "cast_detail";
    Response response = await dio.post(
      '$baseUrl$castDetails',
      options: optHeaders,
      data: {
        'cast_id': castId,
      },
    );
    castDetailModel = CastDetailModel.fromJson(response.data);
    return castDetailModel;
  }

  // get_category API
  Future<GenresModel> genres() async {
    GenresModel genresModel;
    String genres = "get_category";
    Response response = await dio.post(
      '$baseUrl$genres',
      options: optHeaders,
    );
    genresModel = GenresModel.fromJson(response.data);
    return genresModel;
  }

  // get_language API
  Future<LangaugeModel> language() async {
    LangaugeModel langaugeModel;
    String language = "get_language";
    Response response = await dio.post(
      '$baseUrl$language',
      options: optHeaders,
    );
    langaugeModel = LangaugeModel.fromJson(response.data);
    return langaugeModel;
  }

  // search_video API
  Future<SearchModel> searchVideo(searchText) async {
    log('searchVideo searchText ==>>> $searchText');
    SearchModel searchModel;
    String search = "search_video";
    Response response = await dio.post(
      '$baseUrl$search',
      options: optHeaders,
      data: {
        'name': searchText,
        'user_id': Constant.userID,
      },
    );
    searchModel = SearchModel.fromJson(response.data);
    return searchModel;
  }

  // channel_section_list API
  Future<ChannelSectionModel> channelSectionList() async {
    ChannelSectionModel channelSectionModel;
    String channelSection = "channel_section_list";
    Response response = await dio.post(
      '$baseUrl$channelSection',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
      },
    );
    channelSectionModel = ChannelSectionModel.fromJson(response.data);
    return channelSectionModel;
  }

  // rent_video_list API
  Future<RentModel> rentVideoList() async {
    RentModel rentModel;
    String rentList = "rent_video_list";
    Response response = await dio.post(
      '$baseUrl$rentList',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
      },
    );
    rentModel = RentModel.fromJson(response.data);
    return rentModel;
  }

  // user_rent_video_list API
  Future<RentModel> userRentVideoList() async {
    RentModel rentModel;
    String rentList = "user_rent_video_list";
    Response response = await dio.post(
      '$baseUrl$rentList',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
      },
    );
    rentModel = RentModel.fromJson(response.data);
    return rentModel;
  }

  // video_by_category API
  Future<VideoByIdModel> videoByCategory(categoryID, typeId) async {
    log('videoByCategory categoryID ==>>> $categoryID');
    log('videoByCategory typeId ====>>>>> $typeId');
    VideoByIdModel videoByIdModel;
    String byCategory = "video_by_category";
    Response response = await dio.post(
      '$baseUrl$byCategory',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
        'category_id': categoryID,
        'type_id': typeId,
      },
    );
    videoByIdModel = VideoByIdModel.fromJson(response.data);
    return videoByIdModel;
  }

  // video_by_language API
  Future<VideoByIdModel> videoByLanguage(languageID, typeId) async {
    log('videoByLanguage languageID ==>>> $languageID');
    log('videoByLanguage typeId ====>>>>> $typeId');
    VideoByIdModel videoByIdModel;
    String byLanguage = "video_by_language";
    Response response = await dio.post(
      '$baseUrl$byLanguage',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
        'language_id': languageID,
        'type_id': typeId,
      },
    );
    videoByIdModel = VideoByIdModel.fromJson(response.data);
    return videoByIdModel;
  }

  // get_package API
  Future<SubscriptionModel> subscriptionPackage() async {
    log('subscriptionPackage userID ==>>> ${Constant.userID}');
    SubscriptionModel subscriptionModel;
    String getPackage = "get_package";
    Response response = await dio.post(
      '$baseUrl$getPackage',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
      },
    );
    subscriptionModel = SubscriptionModel.fromJson(response.data);
    return subscriptionModel;
  }

  // get_bookmark_video API
  Future<WatchlistModel> watchlist() async {
    log("watchlist userID :==> ${Constant.userID}");

    WatchlistModel watchlistModel;
    String getBookmarkVideo = "get_bookmark_video";
    log("getBookmarkVideo API :==> $baseUrl$getBookmarkVideo");
    Response response = await dio.post(
      '$baseUrl$getBookmarkVideo',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
      },
    );

    watchlistModel = WatchlistModel.fromJson(response.data);
    return watchlistModel;
  }

  // get_payment_option API
  Future<PaymentOptionModel> getPaymentOption() async {
    PaymentOptionModel paymentOptionModel;
    String paymentOption = "get_payment_option";
    log("paymentOption API :==> $baseUrl$paymentOption");
    Response response = await dio.post(
      '$baseUrl$paymentOption',
      options: optHeaders,
    );

    paymentOptionModel = PaymentOptionModel.fromJson(response.data);
    return paymentOptionModel;
  }

  // apply_coupon API
  Future<CouponModel> applyPackageCoupon(couponCode, packageId) async {
    CouponModel couponModel;
    String applyCoupon = "apply_coupon";
    log("applyPackageCoupon API :==> $baseUrl$applyCoupon");
    Response response = await dio.post(
      '$baseUrl$applyCoupon',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
        'apply_coupon_type': "1",
        'unique_id': couponCode,
        'package_id': packageId,
      },
    );

    couponModel = CouponModel.fromJson(response.data);
    return couponModel;
  }

  // apply_coupon API
  Future<CouponModel> applyRentCoupon(
      couponCode, videoId, typeId, videoType, price) async {
    CouponModel couponModel;
    String applyCoupon = "apply_coupon";
    log("applyRentCoupon API :==> $baseUrl$applyCoupon");
    Response response = await dio.post(
      '$baseUrl$applyCoupon',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
        'apply_coupon_type': "2",
        'unique_id': couponCode,
        'video_id': videoId,
        'type_id': typeId,
        'video_type': videoType,
        'price': price,
      },
    );

    couponModel = CouponModel.fromJson(response.data);
    return couponModel;
  }

  // get_payment_token API
  Future<PayTmModel> getPaytmToken(merchantID, orderId, custmoreID, channelID,
      txnAmount, website, callbackURL, industryTypeID) async {
    PayTmModel payTmModel;
    String paytmToken = "get_payment_token";
    log("paytmToken API :==> $baseUrl$paytmToken");
    Response response = await dio.post(
      '$baseUrl$paytmToken',
      options: optHeaders,
      data: {
        'MID': merchantID,
        'order_id': orderId,
        'CUST_ID': custmoreID,
        'CHANNEL_ID': channelID,
        'TXN_AMOUNT': txnAmount,
        'WEBSITE': website,
        'CALLBACK_URL': callbackURL,
        'INDUSTRY_TYPE_ID': industryTypeID,
      },
    );

    payTmModel = PayTmModel.fromJson(response.data);
    return payTmModel;
  }

  // add_transaction API
  Future<SuccessModel> addTransaction(packageId, description, amount, paymentId,
      currencyCode, couponCode) async {
    log('addTransaction userID ==>>> ${Constant.userID}');
    log('addTransaction packageId ==>>> $packageId');
    log('addTransaction description ==>>> $description');
    log('addTransaction amount ==>>> $amount');
    log('addTransaction paymentId ==>>> $paymentId');
    log('addTransaction currencyCode ==>>> $currencyCode');
    log('addTransaction couponCode ==>>> $couponCode');
    SuccessModel successModel;
    String transaction = "add_transaction";
    Response response = await dio.post(
      '$baseUrl$transaction',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
        'package_id': packageId,
        'description': description,
        'amount': amount,
        'payment_id': paymentId,
        'currency_code': currencyCode,
        'unique_id': couponCode,
      },
    );
    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  // add_rent_transaction API
  Future<SuccessModel> addRentTransaction(
      videoId, price, typeId, videoType, couponCode) async {
    log('addRentTransaction userID ==>>> ${Constant.userID}');
    log('addRentTransaction video_id ==>>> $videoId');
    log('addRentTransaction price ==>>> $price');
    log('addRentTransaction typeId ==>>> $typeId');
    log('addRentTransaction videoType ==>>> $videoType');
    log('addTransaction couponCode ==>>> $couponCode');
    SuccessModel successModel;
    String rentTransaction = "add_rent_transaction";
    Response response = await dio.post(
      '$baseUrl$rentTransaction',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
        'video_id': videoId,
        'price': price,
        'type_id': typeId,
        'video_type': videoType,
        'unique_id': couponCode,
      },
    );
    successModel = SuccessModel.fromJson(response.data);
    return successModel;
  }

  // subscription_list API
  Future<HistoryModel> subscriptionList() async {
    HistoryModel historyModel;
    String subscriptionListAPI = "subscription_list";
    Response response = await dio.post(
      '$baseUrl$subscriptionListAPI',
      options: optHeaders,
      data: {
        'user_id': Constant.userID,
      },
    );
    historyModel = HistoryModel.fromJson(response.data);
    return historyModel;
  }
}
