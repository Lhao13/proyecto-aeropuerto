import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'asientos.dart';

class NewScreen extends StatefulWidget {
  final int ID_Reserva;

  NewScreen({required this.ID_Reserva});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  List<dynamic> vuelos = [];
  String searchQuery = "";
  bool isLoading = false;
  List<dynamic> vueloData = [];
  String mensaje = ""; // Mensaje para errores o información

  // Función para obtener vuelos desde la API
  Future<void> fetchVuelos(String destino) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            "http://10.0.2.2:8000/vuelos/destino/?codigo_o_nombre=$destino"),
      );

      if (response.statusCode == 200) {
        setState(() {
          vuelos = json.decode(response.body);
        });
      } else if (response.statusCode == 404) {
        setState(() {
          vuelos = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "No se encontraron vuelos para el destino especificado.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al obtener vuelos: ${response.body}")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error de conexión: $error")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchVueloData(String vueloId) async {
    final url = Uri.parse("http://10.0.2.2:8000/data/$vueloId");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          vueloData = json.decode(response.body); // Guardar los datos del vuelo
          print(vueloData);
          print("HOLA");
          _showVueloInfoDialog();
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

    // Función para mostrar el diálogo con la información del vuelo
  void _showVueloInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final vueloDatas = vueloData[0];
        return AlertDialog(
          title: Text('Información del Vuelo'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Aerolinea: ${vueloDatas['Aerolinea']}"),
                Text("Peso máximo por maleta: ${vueloDatas['Peso_maximo_maleta']} kg"),
                Text("Precio por maleta: \$${vueloDatas['Precio_maleta']}"),
                Text("País de Origen de la Aerolínea: ${vueloDatas['Pais_Origen_Aerolinea']}"),
                Text("Modelo de Aeronave: ${vueloDatas['Modelo_Aeronave']}"),
                Text("Origen: ${vueloDatas['Origen']}"),
                Text("Destino: ${vueloDatas['Destino']}"),
                Text("Número de Puerta: ${vueloDatas['Numero_Puerta'] ?? 'N/A'}"),
                Text("Terminal: ${vueloDatas['Terminal'] ?? 'N/A'}"),
                Text("Tipo de Puerta: ${vueloDatas['Tipo_Puerta'] ?? 'N/A'}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vuelos"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Buscar destino",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (searchQuery.isNotEmpty) {
                      fetchVuelos(searchQuery);
                    }
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: vuelos.length,
                    itemBuilder: (context, index) {
                      final vuelo = vuelos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                              "Destino: ${vuelo['Destino']}, ${vuelo['Codigo_destino']}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Código: ${vuelo['Vuelo_ID']}"),
                              Text("Fecha: ${vuelo['Fecha_Salida']}"),
                              Text("Hora: ${vuelo['Hora_Salida']}"),
                              Text("Aerolinea: ${vuelo['Aerolinea']}"),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: Icon(Icons.info),
                            onPressed: () {
                              fetchVueloData(vuelo['Vuelo_ID'].toString());
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AsientosScreen(
                                    vueloId: vuelo['Vuelo_ID'],
                                    reservaId: widget.ID_Reserva),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
