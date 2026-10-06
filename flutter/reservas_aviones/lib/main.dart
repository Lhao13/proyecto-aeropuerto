import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';
import 'reservas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AddPassengerScreen(),
    );
  }
}

class AddPassengerScreen extends StatefulWidget {
  const AddPassengerScreen({super.key});

  @override
  _AddPassengerScreenState createState() => _AddPassengerScreenState();
}

class _AddPassengerScreenState extends State<AddPassengerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;

  // Controladores para los campos del formulario
  final _dniController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _fechaNacimientoController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();

  final _dniController2 = TextEditingController();
  final _nombreController2 = TextEditingController();

  String _mensaje = '';

  // Método para verificar si el pasajero existe
  Future<void> verificarPasajero() async {
    final dni = _dniController2.text;
    final nombre = _nombreController2.text;

    if (dni.isEmpty || nombre.isEmpty) {
      setState(() {
        _mensaje = "Por favor, complete ambos campos.";
      });
      return;
    }

    final url = Uri.parse(
        "http://10.0.2.2:8000/pasajero/existe/?dni=$dni&nombre=$nombre");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _mensaje =
              "Bienvenido, ${data['pasajero']['nombre']} ${data['pasajero']['apellido']}.";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_mensaje)),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ReservasScreen(pasajeroDni: data['pasajero']['DNI']),
            ),
          );
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _mensaje = "Pasajero no encontrado. Verifique los datos.";
        });
      } else {
        setState(() {
          _mensaje = "Error del servidor. Intente nuevamente.";
        });
      }
    } catch (error) {
      setState(() {
        _mensaje = "Error de conexión: $error";
      });
    }
  }

  // Método para enviar los datos al servidor
  Future<void> _submitPassenger(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/pasajero/').replace(queryParameters: {
            'dni': _dniController.text,
            'nombre': _nombreController.text,
            'apellido': _apellidoController.text,
            'fecha_nacimiento': _fechaNacimientoController.text,
            'correo': _correoController.text,
            'telefono': _telefonoController.text,
          }),
        );

        if (response.statusCode == 200) {
          // Éxito: pasajero agregado
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pasajero agregado exitosamente')),
          );
          String dni = _dniController.text;
          // Limpiar los campos
          _dniController.clear();
          _nombreController.clear();
          _apellidoController.clear();
          _fechaNacimientoController.clear();
          _correoController.clear();
          _telefonoController.clear();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReservasScreen(pasajeroDni: int.parse(dni)),
            ),
          );
        } else {
          // Error: mostrar mensaje de error
          final error = jsonDecode(response.body)['detail'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Pasajero'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Image.asset(
                'assets/avion.png', // Ruta de la imagen en tu proyecto
                height:100, // Ajusta el tamaño de la imagen según sea necesario
              ),
              TextFormField(
                controller: _dniController,
                decoration: const InputDecoration(labelText: 'DNI'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el DNI';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fechaNacimientoController,
                decoration: const InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la fecha de nacimiento';
                  }
                  // Validar formato básico
                  final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                  if (!regex.hasMatch(value)) {
                    return 'Formato incorrecto: usa YYYY-MM-DD';
                  }
                  return null;
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                      _fechaNacimientoController.text =
                          "${picked.toLocal()}".split(' ')[0];
                    });
                  }
                },
              ),
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el correo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el teléfono';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitPassenger(context),
                child: const Text('Crear Pasajero'),
              ),

              // Añadir un botón para verificar pasajero

              Text(
                "Ingrese como pasajero registrado:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _dniController2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "DNI",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _nombreController2,
                decoration: InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: verificarPasajero,
                child: Text("Ingresar"),
              ),
              SizedBox(height: 10),
              Text(
                _mensaje,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
