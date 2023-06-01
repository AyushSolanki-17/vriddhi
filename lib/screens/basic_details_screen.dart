import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:vriddhi_0/constants.dart';
import 'package:vriddhi_0/global_listeners/farm_data.dart';
import 'package:vriddhi_0/screens/soil_details_screen.dart';
import 'package:vriddhi_0/utilities/show_dialog_box.dart';
import 'package:vriddhi_0/widgets/reusable_widgets.dart';


class BasicDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar:ReusableWidgets.smallAppBar('Predict'),
        body: BasicDetailsForm(),
      ),
    );
  }
}

class BasicDetailsForm extends StatefulWidget {
  @override
  State<BasicDetailsForm> createState() => _BasicDetailsFormState();
}

class _BasicDetailsFormState extends State<BasicDetailsForm> {

  //vars
  late String _farmArea;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>(); //global key  to uniquely identify the form widget and helps in validating

  Future<void> _submitForm() async{
    if (_formKey.currentState!.validate() == true) {
      _formKey.currentState!.save();

      // Map<String, dynamic> formData = _formKey.currentState!.value;
      if (_farmArea == null) {
        ShowDialogBox.showAlertDialog(context, 'Farm Area is not given!!');
      } else {
        final farmProvider = Provider.of<FarmData>(context, listen: false);
        farmProvider.setFarmArea(_farmArea); // Use ! to assert non-nullability
        Navigator.pop(context);
      }
    }

      Navigator.push(context,MaterialPageRoute(builder: (context) => SoilDetailsScreen(),),);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Form submitted successfully'),
        ),
      );
    }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Crop Prediction",
                style: TextStyle(
                  fontFamily: "Jaldi",
                  fontWeight: FontWeight.w900,
                  fontSize: 28.0,
                  color: kHeadingTextColor,
                ),
              ),
              Text(
                "Answer the questions given below",
                style: kGreySubtitleTS,
              ),
              FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Basic Details",
                      style: kFormTextFieldLabelStyle.copyWith(
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '1.Location',
                            style: kFormTextFieldLabelStyle,
                          ),
                            Opacity(
                              opacity: 0.5,
                              child: FormBuilderTextField(
                                name: "location",
                                enabled: false,
                                decoration: kFormTextFieldStyle.copyWith(
                                    hintText: "Sarkhej"),
                                validator: FormBuilderValidators.required(),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '2. Farming Area',
                            style: kFormTextFieldLabelStyle,
                          ),
                          FormBuilderTextField(
                              name: "farming_area",

                              decoration: kFormTextFieldStyle.copyWith(
                                  hintText: "( in square meters )"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the farm area';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if(value != null){
                                _farmArea = value;
                              }
                              else{
                                _farmArea = '10';
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.all(12.0),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         '3. Annual Income',
                    //         style: kFormTextFieldLabelStyle,
                    //       ),
                    //       FormBuilderTextField(
                    //         name: "annual_income",
                    //         decoration: kFormTextFieldStyle.copyWith(
                    //             hintText: "( in rupees )"),
                    //         validator: FormBuilderValidators.compose([
                    //           FormBuilderValidators.required(),
                    //           FormBuilderValidators.numeric()
                    //         ]),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '3. Past Grown Crop',
                            style: kFormTextFieldLabelStyle,
                          ),
                          FormBuilderTextField(
                            name: "past_crop_grown",
                            decoration: kFormTextFieldStyle.copyWith(
                                hintText: "( Ex: KidneyBeans )"),
                            validator: FormBuilderValidators.required(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 12.0, left: 12.0, right: 12.0, bottom: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '4. WorkForce',
                            style: kFormTextFieldLabelStyle,
                          ),
                          FormBuilderTextField(
                            name: "workforce",
                            decoration: kFormTextFieldStyle.copyWith(
                                hintText: "( number of Workers )"),
                            // validator: FormBuilderValidators.required(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(
                                fontFamily: "Catamaran",
                              ),
                              backgroundColor: kButtonPositiveColor,
                            ),
                            onPressed: () async{
                              //will move forward to soil details screen
                              await _submitForm();
                              Navigator.push(context,MaterialPageRoute(builder: (context) => SoilDetailsScreen(),),);

                            },
                            child: Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



