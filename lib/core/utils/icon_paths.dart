class IconPaths {
  static const String basePath = 'assets/icons/';

  static const String login = '${basePath}login.svg';
  static const String signin = '${basePath}signin.svg';

  static String getIcon(String iconName) {
    return '$basePath$iconName.svg';
  }
}

/* 사용방법!!!!!!!!!!!!!!!!!!!
다트 페이지 위에 이거 추가하기:
import 'package:flutter_svg/flutter_svg.dart';
import 'utils/icon_paths.dart';

iconbutton 으로 써야 할 때:
IconButton(
                  icon: SvgPicture.asset(
                    IconPaths.getIcon('search'),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),

그냥 아이콘으로 써야할때:
SvgPicture.asset(IconPaths.search),

*/
