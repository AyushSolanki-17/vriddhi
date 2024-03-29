import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vriddhi_0/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vriddhi_0/global_listeners/farm_data.dart';
import 'package:vriddhi_0/global_listeners/temperature_data.dart';
import 'package:vriddhi_0/services/weather.dart';
import 'dart:io';
import 'dart:async';
import 'package:vriddhi_0/utilities/result_modal.dart';
import 'package:vriddhi_0/widgets/reusable_widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:vriddhi_0/url.dart';

import 'crop_predict_screen.dart';

WeatherModel weather = WeatherModel();
class SoilDetailsScreen extends StatelessWidget {
  static const String id = 'soil_details_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: ReusableWidgets.smallAppBar('Predict'),
      body: SoilDetailsForm(),
    );
  }
}

class SoilDetailsForm extends StatefulWidget {
  @override
  State<SoilDetailsForm> createState() => _SoilDetailsFormState();
}

class _SoilDetailsFormState extends State<SoilDetailsForm> {
  //Variables
  bool _showFields = false; // private variable that decides whether to show more textfields or not.
  File? image;
  String cropName = '';
  String crop2='';
  String crop3='';
  String probabilty = '';
  double price = 0.0;
  double prod = 0.0;
  bool buttonShow = false;
  bool gotResponse = false;
  late int temperature;
  late int humidity;
  late  int rain;
  late String farmArea;
  bool showProcessing = true;

  //Methods
  string2float(probs) {
    var number = double.parse(probs);
    number = number * 100;
    var prob = number.toString();
    return prob.substring(0, 2);
  }

  final ImagePicker picker = ImagePicker();

  //we can upload from gallery
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = File(img!.path);
    });
  }
  @override
  Future<void> getLocationData() async{
    // await weatherModel.setWeatherParameters(this.context);
    final temperatureData = Provider.of<WeatherDataAll>(this.context,listen: false);
    temperature = temperatureData.temperature;
    humidity = temperatureData.humidity;
    rain = temperatureData.rain;
    final farmData = Provider.of<FarmData>(this.context,listen: false);
    farmArea = farmData.farmArea;
  }

  Future upload(File imageFile) async {
    // open a bytestream
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(UNewCrop);

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));

    print("Done image uploaded");

    await getLocationData();

    // add file to multipart
    request.files.add(multipartFile);
    // send
    request.fields["humidity"] = "${humidity}";
    request.fields["temperature"] = "${temperature}";
    request.fields["rainfall"] = "572";
    request.fields["area"] = farmArea;


    var response = await request.send();

    if (response.statusCode == 200)
      gotResponse = true;

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      setState(() {
        print(value);
        cropName = jsonDecode(value)["crop_1"];
        probabilty = jsonDecode(value)["crop_1_probs"];
        probabilty = string2float(probabilty);
        crop2=jsonDecode(value)["crop_2"];
        crop3=jsonDecode(value)["crop_3"];
        print(crop2);
        price = jsonDecode(value)["price"];
        prod = jsonDecode(value)["production"];
        print(cropName);
        print(probabilty);
        showProcessing = false;
      });
    });
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
                style: kFormPrimaryHeadingStyle,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Soil Details",
                    style: kFormTextFieldLabelStyle.copyWith(
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!_showFields)
                          Text(
                            'Have you performed a soil test ? ',
                            style: kFormTextFieldLabelStyle,
                          ),
                        if (!_showFields)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <ElevatedButton>[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(
                                    fontFamily: "Catamaran",
                                  ),
                                  backgroundColor: kButtonPositiveColor,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            "Are you sure you had your Soil Tested"),
                                        content: Text(
                                            'Soil must be tested once after each crop season'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK',
                                                style:
                                                    kFormTextFieldLabelStyle),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  setState(() {
                                    _showFields = true;
                                  });
                                },
                                child: Text('Yes'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(
                                    fontFamily: "Catamaran",
                                  ),
                                  backgroundColor: kButtonNegativeColor,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Need Soil Test Results"),
                                        content: Text(
                                            'Please first have the soil tested.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              //will redirect the page to soil testing page.
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'OK',
                                              style: kFormTextFieldLabelStyle,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  'No',
                                  style: TextStyle(color: kButtonPositiveColor),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_showFields)
                Column(
                  children: [
                    Center(
                      child: Text(
                        "Please upload an image of your Soil Tests",
                        style: kFormSecondaryHeadingStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            kButtonPositiveColor, // Background color
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            // <-- Icon
                            Icons.upload,
                            size: 24.0,
                          ),
                          Text(
                            'Upload Soil Tests',
                          ),
                          // <-- Text
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      onPressed: () async {
                        await getImage(ImageSource.gallery);
                        setState(() {
                          // showProcessing = true;
                          buttonShow = true;
                        });
                      },
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    image != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                //to show image, you type like this.
                                File(image!.path),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                              ),
                            ),
                          )
                        : const Text(
                            "No image choosen",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 163, 163, 163)),
                          ),
                    SizedBox(
                      height: 30.0,
                    ),
                    if (buttonShow)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              kButtonNegativeColor, // Background color
                        ),
                        child: Text("Done",
                            style: TextStyle(
                                color: kButtonPositiveColor)), // <-- Text
                        onPressed: () async {
                          try {
                            await upload(image!);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CropPredictScreen(cropName: cropName, production: prod, probability: probabilty, price: price, crop2: crop2, crop3: crop3,)));

                          } catch (e) {
                            AlertDialog(
                              title: Text("Error"),
                              content: Text("Error with the server!"),
                              actions: [
                                TextButton(
                                  child: Text("Try Again"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
