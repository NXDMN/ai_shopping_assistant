import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/screens/search/view_model/search_results_model.dart';
import 'package:ai_shopping_assistant/widgets/constants.dart';
import 'package:ai_shopping_assistant/widgets/myOutlinedButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({Key? key}) : super(key: key);

  @override
  _FilterSheetState createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchResultsModel>(
      builder: (context, model, child) => SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          color: MyColors.shadow,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter options',
                        style: MyTextStyle.largeBold,
                      ),
                      Container(
                        height: 30.0,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            child: const Icon(Icons.close),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const MyDivider(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Price',
                        style: MyTextStyle.mediumBold,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              initialValue: model.minPrice.toStringAsFixed(2),
                              onChanged: (value) {
                                model.updateMinPrice(
                                    double.parse(value != "" ? value : '0.0'));
                              },
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: MyInputDecoration.rounded,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(priceRegex),
                              ],
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Icon(Icons.horizontal_rule),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              initialValue: model.maxPrice.toStringAsFixed(2),
                              onChanged: (value) {
                                model.updateMaxPrice(double.parse(
                                    value != "" ? value : '9999.99'));
                              },
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: MyInputDecoration.rounded,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(priceRegex),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const MyDivider(),
                MyOutlinedButton(
                  text: 'Show results',
                  onPressed: () {
                    model.filterResults();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
