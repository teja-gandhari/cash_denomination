import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appbar.dart';
import 'conveter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // List of available note denominations in descending order
  final List<int> notes = [500, 200, 100, 50, 20, 10, 5, 2, 1];

  // Controllers to handle input for each denomination
  late List<TextEditingController> controllers;
  String _convertedText = 'Zero Rupees';

  // shared_preference
  Future<void> saveData()async{
    final prefs = await SharedPreferences.getInstance();

    //save counts
    List<String> counts = controllers.map((c) => c.text).toList();

    prefs.setStringList('notes_count', counts);
    prefs.setInt('total_amout',calculateTotal() );
    prefs.setString('converted_text', _convertedText);
  }
  //load data from shared_preference
  Future<void>loadData()async{
    final prefs = await SharedPreferences.getInstance();

    List<String>? savedCount = prefs.getStringList('notes_count');
    if(savedCount != null){
      for(int i = 0; i < controllers.length; i++){
        controllers[i].text = savedCount[i];
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    controllers = List.generate(
        notes.length,
            (index) => TextEditingController()
    );
    loadData();
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Calculate the total value based on note counts
  int calculateTotal() {
    int total = 0;
    for (int i = 0; i < notes.length; i++) {
      int count = int.tryParse(controllers[i].text) ?? 0;
      total += notes[i] * count;
    }
    return total;
  }

  // Convert total to words
  void _convertToWords() {
    final total = calculateTotal();
    setState(() {
      _convertedText = NumberToTextConverter.convertToIndianText(total);
    });
  }

  // Clear all input fields
  void clearAll() {
    for (var controller in controllers) {
      controller.clear();

    }
    _convertToWords(); // Update the text after clearing
    saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, clearAll),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header section with converted text
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.blue[50],
            child: Column(
              children: [
                //
                Text(
                  "In words:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                //
                Text(
                  _convertedText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
//list of notes
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final count = int.tryParse(controllers[index].text) ?? 0;
                final value = note * count;
//design
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Denomination label
                        Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "₹$note",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[900],
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Multiplication symbol
                        Text(
                          "×",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Quantity input field
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: controllers[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "0",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                            ),
                            onChanged: (value) {
                              // Update the conversion whenever input changes
                              _convertToWords();
                              setState(() {});
                              saveData();
                            },
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Equals symbol
                        Text(
                          "=",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Calculated value display
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: value > 0 ? Colors.green[50] : Colors.grey[50],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: value > 0 ? Colors.green[100]! : Colors.grey[300]!,
                              ),
                            ),
                            child: Text(
                              "₹$value",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: value > 0 ? Colors.green[800] : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Total amount display section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Total Amount",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "₹${calculateTotal()}",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}