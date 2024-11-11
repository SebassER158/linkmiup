import 'package:flutter/material.dart';
import '../services/app_state.dart';

class InfoScreen extends StatefulWidget {
  final String extractedText;

  const InfoScreen({Key? key, required this.extractedText}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen>
    with SingleTickerProviderStateMixin {
  // Variables para almacenar la información extraída
  String nombre = '';
  String apellidoPaterno = '';
  String apellidoMaterno = '';
  String curp = '';
  String fechaNacimiento = '';
  String sexo = '';
  late TabController _tabController;
  // Variables para la dirección
  TextEditingController calleController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController coloniaController = TextEditingController();
  TextEditingController municipioController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController codigoPostalController = TextEditingController();

  // Lista de palabras detectadas
  List<String> _detectedWords = [];
  Map<String, String> extractedInfo = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    AppState.saveLastRoute('/general_info');

    // Inicializar la lista de palabras detectadas
    _detectedWords = widget.extractedText.split(RegExp(r'\s+'));
    _extractInformation(widget.extractedText);
  }

  // Método para extraer información específica usando expresiones regulares
  void _extractInformation(String text) {
    print("El texto extraido");
    print(text);
    print("fin del texto");
    RegExp curpRegex = RegExp(r'([A-Z]{4}\d{6}[HM][A-Z]{5}\d{2})');
    RegExp cpRegex = RegExp(r'CP[:\s]?(\d{5})');
    RegExp fechaNacimientoRegex = RegExp(r'(\d{2}/\d{2}/\d{4})');
    RegExp sexoRegex = RegExp(r'\b(H|M)\b');

    // Extraer CURP
    var curpMatch = curpRegex.firstMatch(text);
    if (curpMatch != null) {
      curp = curpMatch.group(1)!.trim();
    }

    // Extraer Fecha de Nacimiento
    var fechaMatch = fechaNacimientoRegex.firstMatch(text);
    if (fechaMatch != null) {
      fechaNacimiento = fechaMatch.group(1)!.trim();
    }

    // Extraer Sexo
    var sexoMatch = sexoRegex.firstMatch(text);
    if (sexoMatch != null) {
      sexo = sexoMatch.group(1)!.trim();
    }

    setState(() {}); // Actualizar la UI con los datos extraídos
  }

  // Método para seleccionar una palabra de la lista con buscador
  void _selectWordForField(String field) {
    if (_detectedWords.isEmpty) return;

    // Filtrar palabras que ya se han seleccionado en algún campo
    List<String> usedWords = [
      nombre,
      apellidoPaterno,
      apellidoMaterno,
      curp,
      fechaNacimiento,
      sexo,
    ].where((word) => word.isNotEmpty).toList();

    // Excluir palabras ya usadas
    List<String> availableWords =
        _detectedWords.where((word) => !usedWords.contains(word)).toList();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<String> filteredWords = List.from(availableWords);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (value) {
                      setModalState(() {
                        filteredWords = availableWords
                            .where((word) => word
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredWords.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredWords[index]),
                        onTap: () {
                          setState(() {
                            switch (field) {
                              case 'nombre':
                                nombre = filteredWords[index];
                                break;
                              case 'apellidoPaterno':
                                apellidoPaterno = filteredWords[index];
                                break;
                              case 'apellidoMaterno':
                                apellidoMaterno = filteredWords[index];
                                break;
                              case 'curp':
                                curp = filteredWords[index];
                                break;
                              case 'fechaNacimiento':
                                fechaNacimiento = filteredWords[index];
                                break;
                              case 'sexo':
                                sexo = filteredWords[index];
                                break;
                            }
                            // Remover la palabra seleccionada de _detectedWords
                            _detectedWords.remove(filteredWords[index]);
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void printAllData() {
    // Información extraída
    print('Nombre: $nombre');
    print('Apellido Paterno: $apellidoPaterno');
    print('Apellido Materno: $apellidoMaterno');
    print('CURP: $curp');
    print('Fecha de Nacimiento: $fechaNacimiento');
    print('Sexo: $sexo');

    // Información de la dirección (desde los controladores de texto)
    print('Calle: ${calleController.text}');
    print('Número: ${numeroController.text}');
    print('Colonia: ${coloniaController.text}');
    print('Municipio: ${municipioController.text}');
    print('Estado: ${estadoController.text}');
    print('Código Postal: ${codigoPostalController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(
                    "assets/guide_image_3.png",
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 40,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              TabBar(
                controller: _tabController,
                labelColor: Colors.blue[900],
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue[900],
                tabs: const [
                  Tab(text: 'Datos Personales'),
                  Tab(text: 'Dirección'),
                ],
              ),

              // TabBarView dentro de Expanded
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Información Extraída',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          // Inputs para la información extraída
                          _buildEditableField('Nombre', nombre, 'nombre'),
                          _buildEditableField('Apellido Paterno',
                              apellidoPaterno, 'apellidoPaterno'),
                          _buildEditableField('Apellido Materno',
                              apellidoMaterno, 'apellidoMaterno'),
                          _buildEditableField('CURP', curp, 'curp'),
                          _buildEditableField('Fecha de Nacimiento',
                              fechaNacimiento, 'fechaNacimiento'),
                          _buildEditableField('Sexo', sexo, 'sexo'),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            child: const Text(
                              'Confirmar y Continuar',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Información confirmada')),
                              );

                              // Cambia a la segunda pestaña
                              _tabController.animateTo(1);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[900],
                              minimumSize: const Size(double.infinity, 50),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dirección',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            // Inputs para la información extraída
                            _buildTextField('Calle', calleController),
                            _buildTextField('Número', numeroController),
                            _buildTextField('Colonia', coloniaController),
                            _buildTextField('Municipio', municipioController),
                            _buildTextField('Estado', estadoController),
                            _buildTextField(
                                'Código Postal', codigoPostalController),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              child: const Text('Enviar'),
                              onPressed: () {
                                // Llamar a la función que imprime todos los datos
                                printAllData();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Información enviada')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[900],
                                minimumSize: const Size(double.infinity, 50),
                              ),
                            ),
                            // ElevatedButton(
                            //   child: const Text('Enviar'),
                            //   onPressed: () {
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       const SnackBar(
                            //           content: Text('Información confirmada')),
                            //     );
                            //   },
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: Colors.blue[900],
                            //     minimumSize: const Size(double.infinity, 50),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para campos editables
  Widget _buildEditableField(String label, String value, String field,
      {bool isEditable = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: isEditable ? () => _selectWordForField(field) : null,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  value.isNotEmpty ? value : 'No disponible',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    // return Padding(
    //   padding: const EdgeInsets.only(bottom: 12.0),
    //   child: TextField(
    //     controller: controller,
    //     decoration: InputDecoration(
    //       labelText: label,
    //       border: const OutlineInputBorder(),
    //     ),
    //   ),
    // );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16.0), // Espacio entre el título y el campo
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
