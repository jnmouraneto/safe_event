import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:safe_event/assets/colors/my_colors.dart';
import 'package:safe_event/models/event_model.dart';
import 'package:safe_event/models/guest_model.dart';

class GuestDetail extends StatefulWidget {
  final Guest guest;
  final Event event;

  const GuestDetail({Key? key, required this.guest, required this.event})
      : super(key: key);

  @override
  State<GuestDetail> createState() => _GuestDetail();
}

class _GuestDetail extends State<GuestDetail> {
  TextEditingController _additionalInfoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.guest.name}"),
        backgroundColor: MyColors.primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                      radius: 40.0,
                      backgroundImage: AssetImage(
                          "C:/Users/Micro/OneDrive/Projetos/Evento Seguro/safe_event/lib/assets/images/icon_avatar.png")),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nome: ${widget.guest.name}',
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'ID: ${widget.guest.id}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 40.0,
                            color: MyColors.primaryColor,
                          ),
                          const SizedBox(width: 20),
                          if (widget.guest.confirmation == null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chegando às ${getCurrentTime()} hrs.',
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Faz ${elapsedTime()}\nque o evento começou',
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                              ],
                            ),
                          if (widget.guest.confirmation != null)  
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'O convidado já está no evento.',
                                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Entrada registrada em:\n${getStringConfirmation()} ',
                                style: const TextStyle(fontSize: 18.0),
                              ),
                              
                            ],
                          ),
                          

                        ],
                        
                      ),
                      if (widget.guest.confirmation != null)  
                                  const SizedBox(height: 8.0),
        Text(
          'Detalhes da confirmação: ${widget.guest.confirmation?.detailsConfirm}',
          style: const TextStyle(fontSize: 18.0),
        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 80),
              if (widget.guest.confirmation == null)
                TextField(
                  controller: _additionalInfoController,
                  decoration: const InputDecoration(
                    labelText: "Inserir Informações adicionais",
                    border: OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 80),
              if (widget.guest.confirmation == null)
                ElevatedButton(
                  onPressed: () {
                    // Ação ao pressionar o botão de confirmação
                    // Exemplo: Confirmar presença
                    print("Confirmando presença para ${widget.guest.name}");
                    print(
                        "Informações adicionais: ${_additionalInfoController.text}");
                  },
                  child: Text(
                    "Confirmar Presença",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30), // Define a cor primária aqui
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String getStringConfirmation() {
    final confirmation = widget.guest.confirmation!;
    final formattedDateTime =
        DateFormat('dd/MM/yyyy HH:mm').format(confirmation.createdAt!);
print("aaaaaaaaaaaaaaaaaaaaaaaaa$formattedDateTime");
    return formattedDateTime;
  }
  

  String elapsedTime() {
    Duration timeElapsed = DateTime.now().difference(widget.event.eventAt);
    int hours = timeElapsed.inHours;
    int minutes = timeElapsed.inMinutes % 60;

    if (hours < 1) {
      return '$minutes';
    }
    return '$hours horas e $minutes minutos';
  }

  String getCurrentTime() {
    return DateFormat.Hm().format(DateTime.now());
  }
}
