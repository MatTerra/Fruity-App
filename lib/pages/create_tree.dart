import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fruity/app/components/fruity_app_bar.dart';
import 'package:fruity/app/components/location_handler.dart';
import 'package:fruity/domain/entities/species.dart';
import 'package:fruity/domain/entities/tree.dart';
import 'package:fruity/domain/repository/tree_repository.dart';
import 'package:fruity/infra/repository/tree_http_repository.dart';
import 'package:fruity/pages/tree_map_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateTreePage extends StatefulWidget {
  Species species;

  CreateTreePage({Key? key, required this.species}) : super(key: key);

  @override
  State<CreateTreePage> createState() => _CreateTreePageState();
}

class _CreateTreePageState extends State<CreateTreePage> with LocationHandler {
  Position? _currentPosition;
  Set<Marker> treeMarker = {};
  final _formKey = GlobalKey<FormBuilderState>();
  late TreeRepository repository;
  late GoogleMapController mapController;
  late LatLng location;
  bool loading = false;

  String savedValue = '';

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    var repositoryFuture = TreeHTTPRepository.create();
    repository = (await repositoryFuture) as TreeRepository;

    Position? position = await getCurrentPosition();
    if (position == null) return;
    var marker = Marker(
        markerId: const MarkerId("newTree"),
        position: LatLng(position.latitude, position.longitude),
        draggable: true,
        onDragEnd: (value) {
          setState(() {
            location = value;
          });
        },
        infoWindow: const InfoWindow(title: "Nova árvore"));
    setState(() {
      _currentPosition = position;
      location = LatLng(position.latitude, position.longitude);
      treeMarker.add(marker);
    });
  }

  @override
  void initState() {
    savedValue = _formKey.currentState?.value.toString() ?? '';

    TreeHTTPRepository.create().then((repository) {
      this.repository = repository;
    });

    getCurrentPosition().then((value) => setState(() {
          _currentPosition = value;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FruityAppBar('Criar árvore'),
      body: SingleChildScrollView(
          child: Column(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                        _currentPosition?.latitude ?? -15.79082045623587,
                        _currentPosition?.longitude ?? -47.86114020307252),
                    zoom: 20.0),
                markers: treeMarker)),
        const Text(
          "Para arrastar o marcador, clique e segure.",
          style: TextStyle(fontSize: 10),
        ),
        const SizedBox(height: 30),
        Text("Nova árvore de ${widget.species.popularNames?[0]}",
            style:
                const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        FormBuilder(
            key: _formKey,
            child: Column(
              children: <Widget>[
                FormBuilderCheckbox(
                  name: 'producing',
                  title: const Text("Produzindo?"),
                ),
                FormBuilderTextField(
                  name: "description",
                  keyboardType: TextInputType.multiline,
                  validator: FormBuilderValidators.required(),
                  minLines: 1,
                  maxLines: 5,
                  maxLength: 255,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  decoration: const InputDecoration(label: Text('Descrição')),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: submit,
                        child: !loading
                            ? const Text(
                                "Enviar",
                                style: TextStyle(color: Colors.white),
                              )
                            : const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ))
      ])),
    );
  }

  void submit() {
    setState(() {
      loading = true;
    });
    _formKey.currentState!.saveAndValidate();
    var formValues = _formKey.currentState!.value;
    var tree = Tree(
      species: widget.species,
      location: location,
      description: formValues['description'],
      producing: formValues['producing'],
    );
    if (_formKey.currentState!.isValid) {
      repository.createTree(tree).then(goToNewTreeDetails).catchError((err) {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Ocorreu um erro ao criar a árvore.")));
      });
    }
  }

  void goToNewTreeDetails(value) {
    _formKey.currentState?.reset();
    setState(() {
      savedValue = '';
      loading = false;
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const TreeMapPage()),
        ModalRoute.withName("/home"));
  }
}
