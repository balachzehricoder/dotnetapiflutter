import 'package:dotnetapiflutter/api_hendler.dart';
import 'package:dotnetapiflutter/modle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;

class EditPage extends StatefulWidget {
  final User user;

  const EditPage({super.key, required this.user});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formkey = GlobalKey<FormBuilderState>();

  api_hendler apihendler = api_hendler();
  late http.Response response;
  // Function to handle refreshing data
  void updatedata() async {
    if (_formkey.currentState!.saveAndValidate()) {
      final data = _formkey.currentState!.value;

      final user = User(
          userId: widget.user.userId,
          name: data['name'],
          address: data['address']);

      response =
          await apihendler.updateUser(userId: widget.user.userId, user: user);
    }
    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit apge"),
        centerTitle: true,
        backgroundColor: Colors.black, // Use Color class directly
        foregroundColor: Colors.yellowAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              updatedata();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FormBuilder(
          key: _formkey,
          initialValue: {
            'name': widget.user.name,
            'address': widget.user.address,
          },
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'name',
                validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required()],
                ),
                decoration: InputDecoration(labelText: 'edit your name'),
              ),

              SizedBox(
                height: 20,
              ),

              FormBuilderTextField(
                name: 'address',
                validator: FormBuilderValidators.compose(
                  [FormBuilderValidators.required()],
                ),
                decoration: InputDecoration(labelText: 'edit your address'),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updatedata,
                
                child: Text('Update'),
              ),
              // Add more FormBuilderFields as needed
            ],
          ),
        ),
      ),
    );
  }
}
