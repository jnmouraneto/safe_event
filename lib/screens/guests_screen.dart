import 'package:flutter/material.dart';
import 'package:safe_event/assets/colors/my_colors.dart';
import 'package:safe_event/controllers/navigation_controller.dart';
import 'package:safe_event/controllers/qr_code_controller.dart';
import 'package:safe_event/models/event_model.dart';
import 'package:safe_event/models/guest_model.dart';
import 'package:safe_event/service/guest_service.dart';

class GuestPage extends StatefulWidget {
  final Event event;

  GuestPage({required this.event});

  @override
  _MyGuestPageState createState() => _MyGuestPageState();
}

class _MyGuestPageState extends State<GuestPage> {
  String searchText = '';

  Color primaryColor = MyColors.primaryColor;
  Color backgroundColor = MyColors.backgroundColor;
  List<Guest> guests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Quando a tela é carregada, chamamos o método loadGuests para obter os convidados
    int eventId = widget.event.id as int;
    loadGuests(eventId);
  }

  @override
  Widget build(BuildContext context) {
    // List<Guest> guests = widget.event.guests;
    int confirmations = calculateConfirmations();
    int totalGuests = guests.length;
    int notArrivedCount = totalGuests - confirmations;
    //TODO: ao registar na API, confirmation poderia ser um parametro de convidado, ao invés de um objeto
    List<Guest> filteredGuests = guests
        .where((guest) =>
            guest.name!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("${widget.event.name}"),
      ),
      body: Column(
        children: [
          Container(
            color: primaryColor,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 110,
                  child: Card(
                    color: backgroundColor,
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people, size: 45, color: primaryColor),
                            const SizedBox(height: 8),
                            Text(
                              'Convidados: $totalGuests',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_off,
                                size: 45, color: primaryColor),
                            SizedBox(height: 8),
                            Text(
                              "Não chegaram: $notArrivedCount",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Encontre um convidado',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: backgroundColor,
                    prefixIcon: Icon(
                      Icons.search,
                      color: primaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: Container(
                    color: backgroundColor,
                    padding: const EdgeInsets.all(8),
                    child: filteredGuests.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhum convidado encontrado\nTem certeza de que essa pessoa está na lista?',
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredGuests.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  NavigationController.navigateToGuestDetail(context, filteredGuests[index], widget.event);
                                  
                                },
                                child: Card(
                                  elevation: 4.0,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 16.0,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      filteredGuests[index].name ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      "ID: ${filteredGuests[index].id}" ?? '',
                                    ),
                                    trailing:
                                        filteredGuests[index].confirmation !=
                                                null
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              )
                                            : const Icon(
                                                Icons.check_circle,
                                                color: Colors.red,
                                              ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // String qrData = await QRCodeController.readQRCode(context);
          // //Future<String> data = QRCodeController.readQRCode(context);
        },

        child: Icon(Icons
            .qr_code_scanner_outlined), // Ícone do botão (pode ser substituído por qualquer ícone desejado) [hild: Icon(Icons.add), // Ícone do botão (pode ser substituído por qualquer ícone desejado)]
        backgroundColor:
            primaryColor, // Cor de fundo do botão [backgroundColor: primaryColor, // Cor de fundo do botão]
      ),
    );
  }

  void loadGuests(int id) async {
    try {
      // Chama o serviço para obter a lista de convidados
      List<Guest> loadedGuests = await GuestService().getGuests(id);
      setState(() {
        guests = loadedGuests;
        calculateConfirmations();
        isLoading = false; // Define isLoading como false após o carregamento
      });
    } catch (e) {
      // Trate qualquer exceção que possa ocorrer durante o carregamento dos convidados
      print('Erro ao carregar os convidados: $e');
    }
  }

  int calculateConfirmations() {
    int confirmations =
        guests.where((guest) => guest.confirmation != null).length;
    return confirmations;
  }
}
