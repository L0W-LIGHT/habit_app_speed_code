import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController habitNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: habitNameController,
              decoration: InputDecoration(
                labelText: 'Habit Name',
              ),
            ),
            ElevatedButton(
              onPressed: () => addHabitToFirestore(habitNameController.text),
              child: Text('Add Habit'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('habits').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final habit = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(habit['name']),
                        trailing: Checkbox(
                          value: habit['completionStatus'],
                          onChanged: (bool? value) {
                            updateHabitCompletion(habit.id, value!);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addHabitToFirestore(String habitName) async {
    CollectionReference habits =
        FirebaseFirestore.instance.collection('habits');
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    return habits
        .add({
          'name': habitName,
          'completionStatus': false,
          'completionDates': [],
          'completion_day': DateFormat('EEEE').format(now),
          'completion_month': DateFormat('MMMM').format(now),
          'day_of_month': now.day.toString(),
          'date_added': formattedDate,
        })
        .then((value) => print("Habit Added"))
        .catchError((error) => print("Failed to add habit: $error"));
  }

  Future<void> updateHabitCompletion(String habitId, bool isCompleted) async {
    CollectionReference habits =
        FirebaseFirestore.instance.collection('habits');
    DocumentSnapshot habitSnapshot = await habits.doc(habitId).get();

    if (habitSnapshot.exists) {
      // Check if the "completionStatus" field exists before updating it
      Map<String, dynamic>? data =
          habitSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('completionStatus')) {
        // Update the completion status
        return habits
            .doc(habitId)
            .update({
              'completionStatus': isCompleted,
              // Optionally update other fields related to completion
            })
            .then((value) => print("Habit Updated"))
            .catchError((error) => print("Failed to update habit: $error"));
      } else {
        print('Field "completionStatus" does not exist in the document.');
        // Handle the case where the field does not exist, if necessary
      }
    } else {
      print('No such document!');
      // Handle the case where the document does not exist, if necessary
    }
  }
}
