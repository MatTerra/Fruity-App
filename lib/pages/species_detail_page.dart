import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:fruity/domain/entities/species.dart';

class SpeciesDetailPage extends StatelessWidget {
  final Species species;
  late String title;

  String toMonthName(month) {
    const months = [
      "Janeiro",
      "Fevereiro",
      "Março",
      "Abril",
      "Maio",
      "Junho",
      "Julho",
      "Agosto",
      "Setembro",
      "Outubro",
      "Novembro",
      "Dezembro"
    ];
    return months[month - 1];
  }

  SpeciesDetailPage({Key? key, required this.species}) : super(key: key) {
    title = species.scientificName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text(
              title,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            expandedHeight: 350.0,
            flexibleSpace: FlexibleSpaceBar(
              background: species.picturesUrl!.isNotEmpty ? Swiper(
                itemBuilder: (context, index) {
                  final image = species.picturesUrl![index];
                  return Image.network(
                    image,
                    fit: BoxFit.fill,
                  );
                },
                indicatorLayout: PageIndicatorLayout.COLOR,
                autoplay: true,
                itemCount: species.picturesUrl!.length,
                pagination: const SwiperPagination(),
                control: const SwiperControl(),
              ) : Image.asset('assets/tree-silhouette.png'),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(species.popularNames!.join(", "),
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            const Padding(
                padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Text("Sobre",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey))),
            Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: Text(
                  species.description!,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                )),
            const Padding(
                padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Text("Temporada",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey))),
            Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: Text(
                  "De ${toMonthName(species.seasonStartMonth!)} à ${toMonthName(species.seasonEndMonth!)}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                )),
          ]))
        ],
      ),
    ));
  }
}
