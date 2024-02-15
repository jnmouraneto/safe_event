import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safe_event/assets/images/colors/my_colors.dart';
import 'package:safe_event/controllers/credentials_controller.dart';
import 'package:safe_event/controllers/exit_controller.dart';
import 'package:safe_event/controllers/expiration_controller.dart';
import 'package:safe_event/controllers/navigation_controller.dart';
import 'package:safe_event/models/event_model.dart';
import 'package:safe_event/models/guest_model.dart';
import 'package:safe_event/screens/guests_screen.dart';
import 'package:safe_event/service/event_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  final String businessName;
  final String businessLogo;
  final ApiServiceEvent apiService;

  DashboardPage({required this.businessName, required this.businessLogo})
      : apiService = ApiServiceEvent();

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const Color primaryColor = MyColors.primaryColor;
  static const Color backgroundColor = MyColors.backgroundColor;
  CredentialsController credentialsController = CredentialsController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: loadEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body:
                Center(child: Text('Error loading events: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('Nenhum evento a exbir')),
          );
        } else {
          List<Event> events = snapshot.data!;
          //ordenar
          events.sort((a,b) => a.eventAt.compareTo(b.eventAt));
          List<Event> eventsOfToday = loadEventsOfToday(events);
          List<Event> eventsNextsDays = loadEventsForNextsDays(events);

          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: primaryColor,
              title: const Text("Painel de eventos"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    showLogoutConfirmationDialog(context);
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    builHeader(),
                    const SizedBox(height: 20),
                    const Text(
                      "Hoje,",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    buildHorizontalCalendar(),
                    const SizedBox(height: 20),
                    if (eventsOfToday.isEmpty)
                      const Text(
                        "Nenhum evento programado.",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    else
                      EventListBuilder(events: eventsOfToday),
                    const SizedBox(height: 80),
                    const Text(
                      "Para os próximos dias,",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    if (eventsNextsDays.isEmpty)
                      const Text(
                        "Nenhum evento programado.",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    else
                      EventListBuilder(events: eventsNextsDays),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget builHeader() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                      'C:/Users/Micro/OneDrive/Projetos/Evento Seguro/safe_event/lib/assets/images/assuncaofestas.jpg'))),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Oi, ${widget.businessName}.',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text("Aqui está uma visão\ngeral dos seus eventos",
                style: TextStyle(
                  fontSize: 16,
                ))
          ],
        )
      ],
    );
  }

  Widget buildSubtitle() {
    DateTime now = DateTime.now();
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hoje,",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildHorizontalCalendar() {
    DateTime currentDate = DateTime.now();
    DateTime yesterday = currentDate.subtract(Duration(days: 1));
    DateTime tomorrow = currentDate.add(Duration(days: 1));
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      buildDayCard(yesterday),
      buildDayCard(currentDate, isCurrentDay: true),
      buildDayCard(tomorrow)
    ]);
  }

  Widget buildDayCard(DateTime day, {bool isCurrentDay = false}) {
    String dayFormated = DateFormat('E', 'pt_BR').format(day);
    return Container(
      width: 80,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isCurrentDay ? primaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayFormated.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCurrentDay ? Colors.white : Colors.black),
          ),
          SizedBox(height: 4),
          Text(
            DateFormat('d').format(day),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isCurrentDay ? Colors.white : Colors.black,
            ),
          )
        ],
      ),
    );
  }

  Future<List<Event>> loadEvents() async {
    List<Event> events = await widget.apiService.getEvents();
    if (events == null) {
      ExpirationController.verifyExpiration(context);
    }
    return events;
  }

  Future<void> showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Saída'),
          content: const Text('Tem certeza de que deseja sair?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o AlertDialog
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await ExitController.logout(context);
              },
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }
}

List<Event> loadEventsOfToday(List<Event> allEvents) {
  DateTime currentDate = DateTime.now();
  DateTime todayStart =
      DateTime(currentDate.year, currentDate.month, currentDate.day);
  DateTime todayEnd = todayStart.add(Duration(days: 1));

  List<Event> eventsOfToday = allEvents.where((event) {
    return event.eventAt.isAfter(todayStart) &&
        event.eventAt.isBefore(todayEnd);
  }).toList();

  return eventsOfToday;
}

List<Event> loadEventsForNextsDays(List<Event> allEvents) {
  DateTime currentDate = DateTime.now();
  DateTime todayEnd =
      DateTime(currentDate.year, currentDate.month, currentDate.day + 1);

  List<Event> eventsForNextsDays = allEvents.where((event) {
    return event.eventAt.isAfter(todayEnd);
  }).toList();

  return eventsForNextsDays;
}

class EventListBuilder extends StatelessWidget {
  final List<Event> events;

  EventListBuilder({required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: events.map((event) {
        return GestureDetector(
          onTap: () {
            if (!event.isStarted) {
              print("evento nao comecou");
              showEventDetails(event, context);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GuestPage(
                      event:
                          event), // Correct syntax for navigating to GuestsPage
                ),
              );

              //vai direto para a pagina do evento porque ele ja comecou
            }
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        event.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (event.isStarted)
                        const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: MyColors.primaryColor,
                        ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.admin_panel_settings_outlined),
                      const SizedBox(width: 8),
                      const Text(
                        "Responsável: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${event.responsible?.name}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      const Text(
                        "Data: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(DateFormat('dd/MM/yyyy')
                          .format(event.eventAt.toLocal())),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      openImageViewer(event.coverImage, context);
                      print("Clicou no btn");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryColor,
                    ),
                    child: Container(
                      alignment: Alignment
                          .center, // Centraliza o conteúdo do Container
                      child: Text('Banner de divulgação do evento'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void showEventDetails(Event event, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Detalhes do Evento\n\n"),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          content: Container(
            constraints: BoxConstraints(maxHeight: 300),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nome: ${event.name}\n"),
                Text("Responsável:"),
                Text(
                    "Data: ${DateFormat('dd/MM/yyyy').format(event.eventAt.toLocal())}\n"),
                Text("Local:"),
                Text("Número de Convidados:"),
                Text("Evento Iniciado: 'Sim' : 'Não'}\n"),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await startEvent(event);
                Navigator.of(context).pop();
                //setState(() {});
              },
              child: Text("Iniciar Evento"),
            ),
          ],
        );
      },
    );
  }

  Future<void> startEvent(Event event) async {
    try {} catch (e) {
      print("Error starting event: $e");
      // Handle the error appropriately
    }
  }

  void openImageViewer(String coverImage, BuildContext context) {
    // Substitua o URL da imagem pelo seu próprio URL

    // Abre o visualizador de imagem
    showImageViewer(
      context,
      Image.network(coverImage).image,
      onViewerDismissed: () {
        print("Dismissed");
      },
    );
  }
}
