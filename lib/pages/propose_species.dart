import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fruity/app/components/fruityAppBar.dart';

class ProposeSpeciesPage extends StatefulWidget {
  const ProposeSpeciesPage({Key? key}) : super(key: key);

  @override
  State<ProposeSpeciesPage> createState() => _ProposeSpeciesPageState();
}

class _ProposeSpeciesPageState extends State<ProposeSpeciesPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  static List<String> popularNames = [];

  String savedValue = '';

  List<Widget> _getPopularNames() {
    List<Widget> popularNamesTextFieldList = [];
    for (int i = 0; i < popularNames.length; i++) {
      popularNamesTextFieldList.add(PopularNameTextField(
        i,
        onAdd: () => setState(() {
          popularNames.add("");
        }),
        onDelete: () => setState(() {
          popularNames.removeAt(i);
        }),
      ));
    }
    return popularNamesTextFieldList;
  }

  @override
  void initState() {
    savedValue = _formKey.currentState?.value.toString() ?? '';

    if (popularNames.isEmpty) {
      setState(() {
        popularNames.add("");
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const FruityAppBar('Propor nova espécie'),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        FormBuilderTextField(
                          name: 'scientificName',
                          validator: FormBuilderValidators.required(),
                          decoration: const InputDecoration(
                            label: Text('Nome científico'),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Row(
                          children: [
                            Text("Nomes Populares:",
                                style: TextStyle(fontSize: 15.0))
                          ],
                        ),
                        ..._getPopularNames(),
                        const SizedBox(height: 10),
                        FormBuilderTextField(
                          name: "description",
                          keyboardType: TextInputType.multiline,
                          validator: FormBuilderValidators.required(),
                          minLines: 1,
                          maxLines: 5,
                          decoration:
                              const InputDecoration(label: Text('Descrição')),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: MaterialButton(
                                color: Theme.of(context).colorScheme.secondary,
                                child: const Text(
                                  "Enviar",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  _formKey.currentState!.saveAndValidate();
                                  setState(() {
                                    savedValue = _formKey.currentState?.value
                                            .toString() ??
                                        '';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    )))));
  }
}

class PopularNameTextField extends StatefulWidget {
  final int index;
  final VoidCallback? onDelete;
  final VoidCallback? onAdd;

  const PopularNameTextField(this.index,
      {super.key, required this.onDelete, required this.onAdd});

  @override
  _PopularNameTextFieldState createState() => _PopularNameTextFieldState();
}

class _PopularNameTextFieldState extends State<PopularNameTextField> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text =
          _ProposeSpeciesPageState.popularNames[widget.index] ?? '';
    });

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FormBuilderTextField(
              name: 'popularName_${widget.index}',
              controller: _nameController,
              validator: FormBuilderValidators.minLength(3),
              onChanged: (v) =>
                  _ProposeSpeciesPageState.popularNames[widget.index] = v!,
              decoration: InputDecoration(
                label: Text('Nome popular ${widget.index + 1}'),
              ),
            ),
          ),
          isLast()
              ? IconButton(
                  icon: const Icon(Icons.add_box),
                  onPressed: widget.onAdd,
                )
              : Container(),
          isNotFirst()
              ? IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: widget.onDelete,
                )
              : Container(),
        ],
      ),
    );
  }

  bool isNotFirst() => widget.index != 0;

  bool isLast() =>
      widget.index + 1 == _ProposeSpeciesPageState.popularNames.length;
}
