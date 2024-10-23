import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fruity/app/components/fruity_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruity/pages/species_detail_page.dart';

import '../domain/entities/species.dart';
import '../domain/repository/species_repository.dart';
import '../infra/repository/species_http_repository.dart';

class ProposeSpeciesPage extends StatefulWidget {
  const ProposeSpeciesPage({Key? key}) : super(key: key);

  @override
  State<ProposeSpeciesPage> createState() => _ProposeSpeciesPageState();
}

class _ProposeSpeciesPageState extends State<ProposeSpeciesPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late SpeciesRepository repository;
  bool loading = false;

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

    SpeciesHTTPRepository.create().then((repository) {
      this.repository = repository;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez'
    ];
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
                            Text("Temporada:", style: TextStyle(fontSize: 15.0))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: FormBuilderDropdown(
                                        name: "begin",
                                        validator:
                                            FormBuilderValidators.required(),
                                        decoration: const InputDecoration(
                                          label: Text('Início'),
                                        ),
                                        items: monthsDropdownItems(months)))),
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: FormBuilderDropdown(
                                        name: "end",
                                        validator:
                                            FormBuilderValidators.required(),
                                        decoration: const InputDecoration(
                                          label: Text('Fim'),
                                        ),
                                        items: monthsDropdownItems(months)))),
                          ],
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
                          maxLength: 255,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          decoration:
                              const InputDecoration(label: Text('Descrição')),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: !loading
                                  ? MaterialButton(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      onPressed: submit,
                                      child: const Text(
                                        "Enviar",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  : MaterialButton(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      onPressed: () {},
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      )),
                            ),
                          ],
                        ),
                      ],
                    )))));
  }

  List<DropdownMenuItem<int>> monthsDropdownItems(List<String> months) {
    return months
        .asMap()
        .entries
        .map((m) => DropdownMenuItem(value: m.key + 1, child: Text(m.value)))
        .toList();
  }

  void submit() {
    setState(() {
      loading = true;
    });
    _formKey.currentState!.saveAndValidate();
    var formValues = _formKey.currentState!.value;
    List<String> popularNamesValues = [];
    formValues.forEach((key, value) {
      if (key.startsWith("popularName_")) {
        popularNamesValues.add(value);
      }
    });
    var species = Species(
        creator: FirebaseAuth.instance.currentUser!.uid,
        scientificName: formValues['scientificName'],
        popularNames: popularNamesValues,
        description: formValues['description'] ?? '',
        links: [],
        picturesUrl: [],
        seasonStartMonth: formValues['begin'],
        seasonEndMonth: formValues['end']);
    if (_formKey.currentState!.isValid) {
      repository
          .createSpecies(species)
          .then(goToNewSpeciesDetails)
          .catchError((err) {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Ocorreu um erro ao criar a espécies.")));
      });
    }
  }

  void goToNewSpeciesDetails(value) {
    _formKey.currentState?.reset();
    setState(() {
      savedValue = '';
      popularNames = [""];
      loading = false;
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => SpeciesDetailPage(species: value)),
        ModalRoute.withName("/home"));
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
