import 'package:flutter/material.dart';

AppBar buildCustomAppBar(context, onClearNotes, String dateOnly) {
  return AppBar(
    backgroundColor: Colors.blue[100], // Example background color
    title: Text(dateOnly,style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Confirm to clear all notes?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue[100],
                        padding: EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Cancel",),
                    ),
                    const SizedBox(
                      width: 120,
                    ),
                    TextButton(onPressed: () {
                      onClearNotes(); // callback to clear notes
                      Navigator.pop(context);
                    },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white70,
                        padding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("Clear"),),

                  ],
                );
              },
            );
          },
          child: const Text("Clear All", style: TextStyle(fontSize: 8)),
        ),
      ),

    ],

  );
}
