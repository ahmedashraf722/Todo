import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/layout/cubits/cubits.dart';
import 'package:todo/layout/cubits/state.dart';
import 'package:todo/models/data_model.dart';
import 'package:todo/shared/components/components/components.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var nameController = TextEditingController();
  var desController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  void dateShow(BuildContext ctx) {
    showDatePicker(
      context: ctx,
      currentDate: DateTime.now(),
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    ).then((value) {
      dateController.text = DateFormat.yMMMd().format(value!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppInsertDatabaseState) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 20, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Task',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        'Added task now',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                      ),
                      const SizedBox(height: 25.0),
                      defaultFormFieldF(
                        controller: nameController,
                        contentPadding: const EdgeInsets.all(10.0),
                        type: TextInputType.name,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'enter your Name task';
                          }
                        },
                        label: 'Name',
                        iconPrefix: Icons.drive_file_rename_outline,
                        onTab: () {},
                      ),
                      const SizedBox(height: 20.0),
                      defaultFormFieldF(
                        controller: desController,
                        contentPadding: const EdgeInsets.all(10.0),
                        type: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'enter your description task';
                          }
                        },
                        label: 'Des',
                        iconPrefix: Icons.description,
                        onTab: () {},
                      ),
                      const SizedBox(height: 20.0),
                      defaultFormFieldF(
                        controller: dateController,
                        contentPadding: const EdgeInsets.all(10.0),
                        type: TextInputType.datetime,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'enter your date task';
                          }
                        },
                        label: 'Date',
                        readable: true,
                        iconPrefix: Icons.date_range,
                        onSubmit: (value) {},
                        onChanged: (value) {},
                        onTab: () {
                          dateShow(context);
                        },
                      ),
                      const SizedBox(height: 30.0),
                      state is AppInsertDatabaseState
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : defaultButton(
                              text: 'Submit Task',
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.insertToDatabase(
                                    data: Data(
                                      name: nameController.text,
                                      des: desController.text,
                                      date: dateController.text,
                                      status: 'new',
                                    ),
                                  );
                                }
                              },
                              radius: 40.0,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
