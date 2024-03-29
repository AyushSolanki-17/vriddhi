import 'package:flutter/material.dart';
import 'package:vriddhi_0/constants.dart';
import 'package:vriddhi_0/data_lists/allDataList.dart';
import 'package:vriddhi_0/utilities/all_cards.dart';
import 'package:vriddhi_0/widgets/reusable_widgets.dart';


class ExploreScreen extends StatefulWidget {
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  void onTapped(int index){
    switch(index){
      case 0: {
        Navigator.pushNamed(context, '/crop_classification');
      }
      break;
      case 1: {
        Navigator.pushNamed(context, '/basic_details');
      }
      break;
      case 2: {
        Navigator.pushNamed(context, '/disease_detection');
      }
      break;
      case 3: {
        Navigator.pushNamed(context, '/weather');
      }
      break;
      case 4: {
        Navigator.pushNamed(context, '/blog_info');
      }
      break;
      case 5: {
        Navigator.pushNamed(context,'/agri_pool');
      }
      break;
      case 6: {
        Navigator.pushNamed(context, '/disease_guide');
      }
      break;
      case 7: {
        Navigator.pushNamed(context, '/news');
      }
      break;
      case 8: {
        Navigator.pushNamed(context, '/farming_technique');
      }
      break;
    }

  }

  List<SmallSquareCard> featureList = AllDataList.allFeaturesList;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: ReusableWidgets.smallAppBar('Explore'),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8
            ),
            itemBuilder: (BuildContext context, int index) {

              final current_feature = featureList[index];
              return SmallSquareCard(title: current_feature.title, imagePath: current_feature.imagePath,onTapCard: () => onTapped(index));
            },
            itemCount: featureList.length,
          ),
        ),
      ),
    );
  }
}




