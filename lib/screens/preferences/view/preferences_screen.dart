import 'package:ai_shopping_assistant/constants.dart';
import 'package:ai_shopping_assistant/screens/preferences/view_model/preferences_model.dart';
import 'package:ai_shopping_assistant/widgets/constants.dart';
import 'package:ai_shopping_assistant/widgets/myDrawer.dart';
import 'package:ai_shopping_assistant/widgets/myMainSliverAppBar.dart';
import 'package:ai_shopping_assistant/widgets/myOutlinedButton.dart';
import 'package:ai_shopping_assistant/widgets/myUnderlineTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreferencesScreen extends StatefulWidget {
  static const id = 'preferences_screen';
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String preferences = "";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PreferencesModel(),
      child: Consumer<PreferencesModel>(
        builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          drawer: MyDrawer(
            preferencesSelected: true,
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                MyMainSliverAppBar(),
                model.isLoading
                    ? SliverFillViewport(
                        delegate: SliverChildListDelegate([
                        const Center(
                          child: CircularProgressIndicator(),
                        )
                      ]))
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 20.0, 20.0, 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Preferences labels',
                                    style: MyTextStyle.mediumBold,
                                  ),
                                  GestureDetector(
                                    child: const Icon(Icons.add_box),
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              elevation: 0,
                                              backgroundColor: Colors.white,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    MyUnderlineTextFormField(
                                                      text: 'Enter preferences',
                                                      onChanged: (value) {
                                                        preferences = value;
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                    MyOutlinedButton(
                                                      text: 'Add',
                                                      onPressed: () async {
                                                        await model
                                                            .addPreferences(
                                                                preferences);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const MyDivider(),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: model.preferencesList.length,
                              itemBuilder: (context, index) {
                                String preferences =
                                    model.preferencesList[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  dense: true,
                                  title: Wrap(
                                    children: [
                                      Text(
                                        preferences,
                                        style: MyTextStyle.mediumSmall,
                                      ),
                                    ],
                                  ),
                                  trailing: GestureDetector(
                                    child: Icon(Icons.close),
                                    onTap: () async {
                                      await model
                                          .removePreferences(preferences);
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
