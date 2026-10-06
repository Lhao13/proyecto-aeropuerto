import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AsientosScreen extends StatefulWidget {
  final int vueloId; // ID del vuelo, pasado desde otra pantalla
  final int reservaId; // ID de la reserva, pasado desde otra pantalla
  const AsientosScreen({Key? key, required this.vueloId, required this.reservaId }) : super(key: key);

  @override
  _AsientosScreenState createState() => _AsientosScreenState();
}

class _AsientosScreenState extends State<AsientosScreen> {
  List<dynamic> asientos = []; // Lista de asientos del vuelo
  String mensaje = ""; // Mensaje para errores o información

  @override
  void initState() {
    super.initState();
    obtenerAsientos(); // Cargar los asientos al inicio
  }

  // Método para obtener los asientos del vuelo desde la API
  Future<void> obtenerAsientos() async {
    final url = Uri.parse("http://10.0.2.2:8000/asientos/${widget.vueloId}");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          asientos = json.decode(response.body); // Guardar los asientos
        });
      } else {
        setState(() {
          mensaje = "No se pudieron cargar los asientos del vuelo.";
        });
      }
    } catch (e) {
      setState(() {
        mensaje = "Error de conexión: $e";
      });
    }
  }

    // Función para agregar boleto
  Future<void> agregarBoleto(int numeroAsiento, bool boletoFisico) async {
    final url = Uri.parse('http://10.0.2.2:8000/boleto/').replace(queryParameters: {
      'fisico': boletoFisico? '1' : '0', // Convertir true a 1 y false a 0
      'Reserva_ID': widget.reservaId.toString(),
      'Asiento_Vuelo_ID': widget.vueloId.toString(),
      'Asiento_numero_asiento': numeroAsiento.toString(),
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Boleto para asiento $numeroAsiento agregado')),
      );
      obtenerAsientos(); // Recargar la lista de asientos
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar boleto: ${response.body}')),
      );
    }
  }

    // Función para mostrar el diálogo de selección de boleto
void _showBoletoDialog(int numeroAsiento) {
  bool boletoFisico = true;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Seleccionar Boleto'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('¿Desea un boleto físico?'),
                SwitchListTile(
                  title: Text('Boleto Físico'),
                  value: boletoFisico,
                  onChanged: (bool? value) {
                    setState(() {
                      boletoFisico = value!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  agregarBoleto(numeroAsiento, boletoFisico);
                  Navigator.of(context).pop();
                },
                child: Text('Confirmar'),
              ),
            ],
          );
        },
      );
    },
  );
}


  // Colores dinámicos según el estado del asiento
  Color obtenerColorEstado(int estadoAsiento) {
    if (estadoAsiento == 0) {
      return Colors.green;
    } else if (estadoAsiento == 1) {
      return Colors.red;
    }
    return Colors.grey; // Color por defecto para otros estados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Asientos del Vuelo ${widget.vueloId}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Mostrar mensaje de error si existe
            if (mensaje.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  mensaje,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            // GridView de los asientos
            asientos.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text(
                        "No hay asientos disponibles para este vuelo.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6, // 6 asientos por fila
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: asientos.length,
                      itemBuilder: (context, index) {
                        final asiento = asientos[index];
                        return GestureDetector(
                          onTap: () {
                            _showBoletoDialog(asiento['numero_asiento']);
                            // Acciones al seleccionar un asiento
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Asiento ${asiento['numero_asiento']} seleccionado.",
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  obtenerColorEstado(asiento['Estado_Asiento']),
                              borderRadius: BorderRadius.circular(8.0),
                              border:
                                  Border.all(color: Colors.black12, width: 1.0),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Nº ${asiento['numero_asiento']}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "\$${asiento['Precio_Asiento']}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
