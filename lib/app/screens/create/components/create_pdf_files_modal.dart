import 'dart:developer';

import 'package:big_qazaq_app/api/api.dart';
import 'package:big_qazaq_app/app/screens/create/bloc/create_bloc.dart';
import 'package:big_qazaq_app/app/screens/users/bloc/users_bloc.dart';
import 'package:big_qazaq_app/app/widgets/buttons/custom_button.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_phone_textfield.dart';
import 'package:big_qazaq_app/app/widgets/textfields/custom_textfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class CreatePdfFilesModal extends StatefulWidget {
  final data;
  CreatePdfFilesModal({required this.data});
  @override
  _CreatePdfFilesModalState createState() => _CreatePdfFilesModalState();
}

class _CreatePdfFilesModalState extends State<CreatePdfFilesModal> {
  TextEditingController fileName = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white, // Background color of the modal
          ),
          child: BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              if (state is UsersLoaded) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Файлдар',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close))
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    (widget.data.containsKey('pdfFiles'))
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.data['pdfFiles'].length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(widget.data['pdfFiles'][index]
                                            ['fileName']),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<CreateBloc>(context)
                                          ..add(CreateDeletePdf(
                                              index: index,
                                              moduleName:
                                                  widget.data['moduleName']));
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            })
                        : Text('Файлдар жоқ'),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextField(
                        hintText: 'Файлдың аты', controller: fileName),
                    SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                      text: 'Файл қосу',
                      function: () async {
                        BlocProvider.of<CreateBloc>(context)
                          ..add(CreateUploadPdf(
                              fileName: fileName.text,
                              moduleName: widget.data['moduleName']));
                        fileName.text = '';
                        setState(() {});
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ));
  }
}
