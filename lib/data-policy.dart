import 'package:flutter/material.dart';
import 'package:multi_timer/settings.dart';
import 'package:multi_timer/utils/helper.dart';

class DataPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logScreen(screenName: "Privacy Policy", screenClass: "DataPolicy");
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Privacy Policy"),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Settings.STANDARD_DARK_TEXT),
              children: const <TextSpan>[
                TextSpan(text: 'Felix Künnecke built the Multi Timer app as a Free app. This SERVICE is provided by Felix Künnecke at no cost and is intended for use as is. This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service. If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy. The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Multi Timer unless otherwise defined in this Privacy Policy. '),
                TextSpan(text: '\nInformation Collection and Use\n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information. The information that I request will be retained on your device and is not collected by me in any way. The app does use third party services that may collect information used to identify you. Link to privacy policy of third party service providers used by the app \n'),
                TextSpan(text: '• Google Play Services\n• Google Analytics for Firebase\n• Firebase Crashlytics'),
                TextSpan(text: '\nLog Data\n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.'),
                TextSpan(text: '\nCookies\n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory. This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service."),
                TextSpan(text: '\nService Providers\n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'I may employ third-party companies and individuals due to the following reasons:\n'),
                TextSpan(text: '• To facilitate our Service;\n• To provide the Service on our behalf;\n• To perform Service-related services; or\n• To assist us in analyzing how our Service is used.\n'),
                TextSpan(text: 'I want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.'),
                TextSpan(text: '\nSecurity\n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'I value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.'),
                TextSpan(text: '\nLinks to Other Sites\n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.'),
                TextSpan(text: '\nChildren’s Privacy\n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'These Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13 years of age. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do necessary actions.'),
                TextSpan(text: '\nChanges to This Privacy Policy\n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page. This policy is effective as of 2021-10-14'),
                TextSpan(text: '\nContact Us\n', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at multitimerapp@gmail.com. This privacy policy page was created at privacypolicytemplate.net and modified/generated by App Privacy Policy Generator')
              ],
            ),
          ),
        )));
  }
}
