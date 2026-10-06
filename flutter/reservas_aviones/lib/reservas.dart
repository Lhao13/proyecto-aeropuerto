import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pantalla1.dart';

class ReservasScreen extends StatefulWidget {
  final int pasajeroDni; // DNI del pasajero (pasado desde otra pantalla)
  const ReservasScreen({Key? key, required this.pasajeroDni}) : super(key: key);

  @override
  _ReservasScreenState createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  // Controladores y variables
  String tipoReserva = "Ida"; // Valor inicial del menú desplegable
  List<dynamic> reservas = []; // Lista de reservas del pasajero
  String mensaje = ""; // Mensaje para mostrar errores o éxito
  bool cargando = false; // Indica si se está cargando

  @override
  void initState() {
    super.initState();
    obtenerReservas(); // Cargar las reservas al inicio
  }

  String cambiarTipoviaje(String tipo) {
    if (tipo == 'Ida') {
      return "1";
    } else if (tipo == 'Ida y vuelta') {
      return "2";
    } else if (tipo == 'Múltiple') {
      return "3";
    }
    return "0"; // Default return value
  }

  // Método para crear una nueva reserva
  Future<void> crearReserva() async {
    final url =
        Uri.parse("http://10.0.2.2:8000/reserva/").replace(queryParameters: {
      "pasajero_dni": widget.pasajeroDni.toString(),
      "tipo_viaje_id": cambiarTipoviaje(tipoReserva),
    });

    setState(() {
      cargando = true;
      mensaje = "";
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          mensaje = "Reserva creada exitosamente.";
        });
        obtenerReservas(); // Recargar la lista de reservas
      } else {
        setState(() {
          mensaje = "Error al crear la reserva: ${response.body}";
        });
      }
    } catch (error) {
      setState(() {
        mensaje = "Error de conexión: $error";
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  // Método para obtener las reservas del pasajero
  Future<void> obtenerReservas() async {
    final url =
        Uri.parse("http://10.0.2.2:8000/reservas/${widget.pasajeroDni}");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          reservas = json.decode(response.body);
        });
      } else {
        setState(() {
          mensaje = "No se pudieron cargar las reservas.";
        });
      }
    } catch (e) {
      setState(() {
        mensaje = "Error de conexión: $e";
      });
    }
  }

  Future<void> eliminarReserva(int reservaId) async {
    final url = Uri.parse("http://10.0.2.2:8000/reserva/$reservaId");
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          mensaje = "Reserva eliminada exitosamente.";
        });
        obtenerReservas(); // Recargar las reservas
      } else {
        setState(() {
          mensaje = "Error al eliminar la reserva: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        mensaje = "Error de conexión: $e";
      });
    }
  }

  Future<void> eliminarUsuario(BuildContext context) async {
    final url =
        Uri.parse('http://10.0.2.2:8000/pasajero/${widget.pasajeroDni}');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Usuario eliminado correctamente
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario eliminado correctamente')),
      );
      Navigator.pop(context); // Regresar a la pantalla principal
    } else {
      // Error al eliminar el usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el usuario')),
      );
    }
  }

  // Función para actualizar usuario
  Future<void> actualizarUsuario(String nombre, String apellido,
      String fechaNacimiento, String correo, String telefono) async {
    final url =
        Uri.parse('http://10.0.2.2:8000/pasajero/').replace(queryParameters: {
      'dni': widget.pasajeroDni.toString(),
      'nombre': nombre,
      'apellido': apellido,
      'fecha_nacimiento': fechaNacimiento,
      'correo': correo,
      'telefono': telefono,
    });

    final response = await http.put(
      url,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario actualizado exitosamente')),
      );
      obtenerReservas(); // Recargar las reservas
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al actualizar usuario: ${response.body}')),
      );
    }
  }

    // Función para agregar maleta
  Future<void> agregarMaleta(String peso, String reservaId) async {
    final url =
        Uri.parse('http://10.0.2.2:8000/maleta/').replace(queryParameters: {
      'peso': peso,
      'reserva_id': reservaId,
    });

    final response = await http.post(
      url,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maleta de $peso kg agregada')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar maleta: ${response.body}')),
      );
    }
  }

  // Función para mostrar el diálogo de actualización de usuario
  void _showUpdateUserDialog() {
    final TextEditingController _nombreController = TextEditingController();
    final TextEditingController _apellidoController = TextEditingController();
    final TextEditingController _fechaNacimientoController =
        TextEditingController();
    final TextEditingController _correoController = TextEditingController();
    final TextEditingController _telefonoController = TextEditingController();

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
      if (picked != null && picked != DateTime.now()) {
        setState(() {
          _fechaNacimientoController.text = "${picked.toLocal()}".split(' ')[0];
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Actualizar Usuario'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: _apellidoController,
                  decoration: InputDecoration(labelText: 'Apellido'),
                ),
                TextField(
                  controller: _fechaNacimientoController,
                  decoration: InputDecoration(labelText: 'Fecha de Nacimiento'),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    await _selectDate(context);
                  },
                ),
                TextField(
                  controller: _correoController,
                  decoration: InputDecoration(labelText: 'Correo'),
                ),
                TextField(
                  controller: _telefonoController,
                  decoration: InputDecoration(labelText: 'Teléfono'),
                ),
              ],
            ),
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
                actualizarUsuario(
                  _nombreController.text,
                  _apellidoController.text,
                  _fechaNacimientoController.text,
                  _correoController.text,
                  _telefonoController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

    // Función para mostrar el diálogo de agregar maleta
  void _showAddLuggageDialog(String reservaId) {
    final TextEditingController _pesoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Maleta'),
          content: TextField(
            controller: _pesoController,
            decoration: InputDecoration(labelText: 'Peso de la maleta (kg)'),
            keyboardType: TextInputType.number,
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
                // Aquí puedes manejar la lógica para agregar la maleta
                final peso = _pesoController.text;
                if (peso.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Maleta de $peso kg agregada')),
                  );
                  agregarMaleta(peso, reservaId);
                }
                Navigator.of(context).pop();
              },
              child: Text('Agregar'),
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
        title: Text("Reservas del Pasajero"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: tipoReserva,
                  items: ["Ida", "Ida y vuelta", "Múltiple"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      tipoReserva = newValue!;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    await eliminarUsuario(context);
                  },
                  child: Text("Eliminar Usuario"),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Botón para crear nueva reserva
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: crearReserva,
                  child: Text("Crear Reserva"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showUpdateUserDialog();
                  },
                  child: Text("Actualizar Usuario"),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Mostrar mensaje (error o éxito)
            Text(
              mensaje,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20),

            // Lista de reservas

            Expanded(
              child: reservas.isEmpty
                  ? const Center(
                      child: Text(
                        "No hay reservas para este pasajero.",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: reservas.length,
                      itemBuilder: (context, index) {
                        final reserva = reservas[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewScreen(
                                    ID_Reserva: reserva['reserva_id']),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(
                                        "Reserva ID: ${reserva['reserva_id']}"),
                                    subtitle: Text(
                                      "Precio: ${reserva['precio_total_reserva']} - Fecha: ${reserva['fecha_creacion_reserva']}",
                                    ),
                                  ),
                                  if (reserva['numero_boletos'] >= 1)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.luggage,
                                              color: Colors.brown),
                                          SizedBox(width: 8.0),
                                          Text(
                                              "Número de boletos: ${reserva['numero_boletos']}"),
                                        ],
                                      ),
                                    ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () async {
                                            await eliminarReserva(
                                                reserva['reserva_id']);
                                          },
                                        ),
                                        if (reserva['numero_boletos'] >= 1)
                                          IconButton(
                                            icon: Icon(Icons.luggage,
                                                color: Colors.brown),
                                            onPressed: () {
                                              _showAddLuggageDialog(reserva['reserva_id'].toString());
                                            },
                                          ),
                                      ],
                                    ),
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
