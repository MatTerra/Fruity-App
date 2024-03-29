import 'package:flutter_test/flutter_test.dart';
import 'package:fruity/domain/repository/species_repository.dart';
import 'package:fruity/infra/repository/species_http_repository.dart';

void main(){
  test('Should instantiate', () async {
    SpeciesRepository repository = await SpeciesHTTPRepository.create();
    expect(repository.runtimeType, SpeciesHTTPRepository);
  });

}