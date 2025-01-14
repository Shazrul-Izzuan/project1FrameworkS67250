import 'package:flutter/material.dart';

void main() {
  runApp(const CarbonFootprintCalculatorApp());
}

class CarbonFootprintCalculatorApp extends StatelessWidget {
  const CarbonFootprintCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carbon Footprint Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
      ),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade400, Colors.green.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Carbon Footprint\nCalculator',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  double _distance = 0.0;
  String _transportationMode = 'Car';
  final Map<String, double> _emissionFactors = {
    'Car': 0.411,
    'Public Transport': 0.036,
    'Bike': 0.0,
  };
  double _carbonEmission = 0.0;

  void _calculateCarbonFootprint() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _carbonEmission = _distance * _emissionFactors[_transportationMode]!;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnergyUsePage(
            initialTravelEmission: _carbonEmission,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carbon Footprint Calculator')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Enter your weekly travel distance:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Distance (in km)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _distance = double.tryParse(value) ?? 0.0;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a distance.';
                    }
                    if (double.tryParse(value) == null || double.parse(value) <= 0) {
                      return 'Enter a valid distance greater than 0.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _transportationMode,
                  onChanged: (String? newValue) {
                    setState(() {
                      _transportationMode = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Transportation Mode',
                    border: OutlineInputBorder(),
                  ),
                  items: _emissionFactors.keys
                      .map((String mode) => DropdownMenuItem<String>(
                            value: mode,
                            child: Text(mode),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _calculateCarbonFootprint,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EnergyUsePage extends StatefulWidget {
  final double initialTravelEmission;

  const EnergyUsePage({super.key, required this.initialTravelEmission});

  @override
  _EnergyUsePageState createState() => _EnergyUsePageState();
}

class _EnergyUsePageState extends State<EnergyUsePage> {
  final _formKey = GlobalKey<FormState>();
  double _electricityConsumption = 0.0;
  String _energySource = 'Renewable';
  final Map<String, double> _energyEmissionFactors = {
    'Renewable': 0.0,
    'Fossil Fuels': 0.9,
    'Mixed': 0.5,
  };
  double _energyEmission = 0.0;

  void _calculateEnergyEmission() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _energyEmission = _electricityConsumption * _energyEmissionFactors[_energySource]!;
      });

      double totalEmission = widget.initialTravelEmission + _energyEmission;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            travelEmission: widget.initialTravelEmission,
            energyEmission: _energyEmission,
            totalEmission: totalEmission,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carbon Footprint Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Enter your monthly electricity usage:',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Electricity (kWh)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _electricityConsumption = double.tryParse(value) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter electricity usage.';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Enter a valid number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _energySource,
                onChanged: (String? newValue) {
                  setState(() {
                    _energySource = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Energy Source',
                  border: OutlineInputBorder(),
                ),
                items: _energyEmissionFactors.keys
                    .map((String source) => DropdownMenuItem<String>(
                          value: source,
                          child: Text(source),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _calculateEnergyEmission,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final double travelEmission;
  final double energyEmission;
  final double totalEmission;

  const ResultPage({
    super.key,
    required this.travelEmission,
    required this.energyEmission,
    required this.totalEmission,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Carbon Footprint:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Travel Emissions: ${travelEmission.toStringAsFixed(2)} kg CO₂'),
            const SizedBox(height: 10),
            Text('Energy Emissions: ${energyEmission.toStringAsFixed(2)} kg CO₂'),
            const SizedBox(height: 10),
            Text('Total Emissions: ${totalEmission.toStringAsFixed(2)} kg CO₂',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Back to Start'),
            ),
          ],
        ),
      ),
    );
  }
}
