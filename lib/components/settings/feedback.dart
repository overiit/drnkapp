import 'package:drnk/components/buttons/OutlinedTextField.dart';
import 'package:drnk/components/buttons/betterbutton.dart';
import 'package:drnk/store/stores.dart';
import 'package:drnk/utils/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  FeedbackState createState() => FeedbackState();
}

class FeedbackState extends State<FeedbackForm> {
  String feedback = "";
  String contact = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        children: [
          const Text(
              "We would love to hear your feedback! Please send send us any feedback you might have."),
          const SizedBox(height: 10),
          BetterTextField(
            color: Colors.white.withOpacity(.5),
            style: TextStyle(),
            onChanged: (email) {
              setState(() {
                contact = email;
              });
            },
            isEmail: true,
            hintText: "E-Mail (optional)",
          ),
          const SizedBox(height: 10),
          TextField(
            onChanged: (value) {
              setState(() {
                feedback = value;
              });
            },
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: "Feedback",
              hoverColor: Colors.red,
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(.5),
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(.5),
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
            ),
            maxLines: 5,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: BetterTextButton(
                  "Submit",
                  onPressed: () {
                    ApiService.sendFeedback(
                      feedbackType: "InApp Feedback",
                      content: feedback,
                      contact: contact.isNotEmpty ? contact : null,
                    );
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BetterTextButton(
                  "Cancel",
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.white.withOpacity(.1),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
