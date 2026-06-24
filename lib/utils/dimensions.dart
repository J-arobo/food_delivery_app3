import 'package:get/get.dart';

class Dimensions {
  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;

  // Getting the scalling factor
  // the height 844 is for iphone 12pro
  // screen size/height of body = 844/320
  static double pageView = screenHeight / 2.64;
  // screen height / selcted height 844/220 = 3.84
  static double pageviViewContainer = screenHeight / 3.84;
  // screen height/text container 844/120 = 7.03
  static double pageViewTextContainer = screenHeight / 7.03;

  // 844/10=84.4 , 844/20=42.2, 844/15=56.27, 844/30=28.13
  // Dynamic height padding and margin
  static double height10 = screenHeight / 84.4;
  static double height15 = screenHeight / 56.27;
  static double height20 = screenHeight / 42.2;
  static double height30 = screenHeight / 28.13;
  static double height45 = screenHeight / 18.76;

  //font size
  static double font12 = screenHeight / 70.33;
  static double font16 = screenHeight / 52.7;
  static double font20 = screenHeight / 42.2;
  static double font26 = screenHeight / 32.46;

  // Dynamic width padding and margin
  static double width10 = screenHeight / 84.4;
  static double width15 = screenHeight / 56.27;
  static double width20 = screenHeight / 42.2;
  static double width30 = screenHeight / 28.13;

  //border radius
  static double radius15 = screenHeight / 56.27;
  static double radius20 = screenHeight / 42.2;
  static double radius30 = screenHeight / 28.13;

  // Icons size
  static double iconSize24 = screenHeight / 35.17;
  static double iconSize16 = screenHeight / 52.75;

  //List view size  390/120=3.25
  static double listViewImgSize = screenWidth / 3.25;
  static double listViewTextContSize = screenWidth / 3.9;

  //popular food screenheight/350=2.41
  static double popularFoodImgSize = screenHeight / 2.41;

  // bottom height 844/120=7.03
  static double bottomheightBar = screenHeight / 7.03;

  //Splash screen dimensions
  static double splashImg = screenHeight / 3.38;
}
