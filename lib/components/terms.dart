import 'package:flutter/material.dart';

// TODO: Change the name of the Developer's Name to the name of the developer
// TODO: Change the name of the Developer's Email to the email of the developer

class Terms extends StatelessWidget {
  final Function()? onClose;

  const Terms({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    // scrollable column of text
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Terms and Conditions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Spacer(),
                if (onClose != null)
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: onClose,
                    splashRadius: 20,
                  ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Last updated: June 15, 2023",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Please read these Terms and Conditions (\"Terms\", \"Terms and Conditions\") carefully before using the DRNK mobile application (the \"App\") operated by [Developer's Name] (\"us\", \"we\", or \"our\").",
            ),
            SizedBox(height: 20),
            Text(
              "Your access to and use of the App is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all users who access or use the App. By accessing or using the App, you agree to be bound by these Terms. If you disagree with any part of the terms, then you may not access the App.",
            ),
            SizedBox(height: 20),
            Text(
              "Disclaimer",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "The App is provided for informational purposes only. It is designed to assist users in estimating their blood alcohol content (BAC) and associated health effects based on the information provided by the users (such as weight, sex, and drinks consumed). The App should not be used as a substitute for professional medical or legal advice. We make no guarantee as to the accuracy or completeness of the information provided by the App, and you are solely responsible for any actions or decisions you take based on such information.",
            ),
            SizedBox(height: 20),
            Text(
              "Privacy",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "The App does not store any personal information, such as weight, sex, or drinks consumed. We do collect event analytics and other non-personal information to help improve the App, but this information is not linked to your specific use of the App.",
            ),
            SizedBox(height: 20),
            Text(
              "Copyright",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "All content and materials in the App, including text, graphics, logos, and images, are the property of [Developer's Name] or its licensors and may not be reproduced, distributed, or otherwise used without the written permission of [Developer's Name].",
            ),
            SizedBox(height: 20),
            Text(
              "Limitation of Liability",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "In no event shall [Developer's Name] be liable for any direct, indirect, punitive, incidental, special, or consequential damages, or any damages whatsoever, arising out of or in connection with the use or misuse of the App. This limitation applies whether the alleged liability is based on contract, tort, negligence, strict liability, or any other basis.",
            ),
            SizedBox(height: 20),
            Text(
              "Indemnity",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "You agree to defend, indemnify and hold harmless [Developer's Name] and its licensors, and their respective directors, officers, employees, and agents, from and against any and all claims, damages, obligations, losses, liabilities, costs, and expenses (including but not limited to attorney's fees) arising from your use or misuse of the App, or your violation of these Terms.",
            ),
            SizedBox(height: 20),
            Text(
              "Governing Law",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "These Terms shall be governed by and construed in accordance with the laws of the United Kingdom, without regard to its conflict of law provisions. You agree that any legal action or proceeding between you and [Developer's Name] shall be brought exclusively in a court of competent jurisdiction located in the United Kingdom.",
            ),
            SizedBox(height: 20),
            Text(
              "Future Features",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "We reserve the right to change, modify, or update the App and its Terms at any time in our sole discretion, including the addition of accounts and related features that may store personal information. Your continued use of the App after any such changes, modifications, or updates constitute your acceptance of the updated Terms.",
            ),
            SizedBox(height: 20),
            Text(
              "Contact Us",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "If you have any questions about these Terms, please contact us at [Developer's Email].",
            ),
          ],
        ),
      ),
    );
  }
}
