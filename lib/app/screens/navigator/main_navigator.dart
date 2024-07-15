import 'package:big_qazaq_app/app/data/const/app_colors.dart';
import 'package:big_qazaq_app/app/screens/navigator/bloc/main_navigator_bloc.dart';
import 'package:big_qazaq_app/app/screens/navigator/components/navigator_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainNavigatorBloc, MainNavigatorState>(
      builder: (context, state) {
        if (state is MainNavigatorLoaded) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.kPrimaryBackgroundColor,
            body: Column(
              children: [
                Expanded(child: state.screens[state.index]),
                Container(
                  height: 80,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: AppColors.kSecondartBackgroundColor,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: (state.isAdmin != true)
                          ? [
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<MainNavigatorBloc>(context)
                                      .add(MainNavigatorChangePage(index: 0));
                                },
                                child: NavigationItem(
                                  assetImage: 'assets/icons/dashboard.svg',
                                  isSelected: (state.index == 0) ? true : false,
                                  text: 'Басты',
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<MainNavigatorBloc>(context)
                                      .add(MainNavigatorChangePage(index: 1));
                                },
                                child: NavigationItem(
                                  assetImage: 'assets/icons/book.svg',
                                  isSelected: (state.index == 1) ? true : false,
                                  text: "Курстар",
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<MainNavigatorBloc>(context)
                                      .add(MainNavigatorChangePage(index: 2));
                                },
                                child: NavigationItem(
                                    assetImage: 'assets/icons/user.svg',
                                    isSelected:
                                        (state.index == 2) ? true : false,
                                    text: 'Профиль'),
                              ),
                            ]
                          : [
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<MainNavigatorBloc>(context)
                                      .add(MainNavigatorChangePage(index: 0));
                                },
                                child: NavigationItem(
                                  assetImage: 'assets/icons/book.svg',
                                  isSelected: (state.index == 0) ? true : false,
                                  text: 'Курстар',
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<MainNavigatorBloc>(context)
                                      .add(MainNavigatorChangePage(index: 1));
                                },
                                child: NavigationItem(
                                  assetImage: 'assets/icons/user.svg',
                                  isSelected: (state.index == 1) ? true : false,
                                  text: "Колданушылар",
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<MainNavigatorBloc>(context)
                                      .add(MainNavigatorChangePage(index: 2));
                                },
                                child: NavigationItem(
                                    assetImage: 'assets/icons/dashboard.svg',
                                    isSelected:
                                        (state.index == 2) ? true : false,
                                    text: 'Баннер'),
                              ),
                            ]),
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
