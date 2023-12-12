import 'package:flutter/material.dart';
import '../models/list_etudiants.dart';
import '../models/scol_list.dart';
import '../utile/dbuse.dart';
import 'list_student_dialog.dart';

class StudentsScreen extends StatefulWidget {
  final ScolList scolList;

  StudentsScreen(this.scolList);

  @override
  _StudentsScreenState createState() =>
      _StudentsScreenState(this.scolList);
}

class _StudentsScreenState extends State<StudentsScreen> {
  final ScolList scolList;

  late dbuse helper; // Initialize the `helper` variable.
  late List<ListEtudiants> students; // Initialize the `students` variable.

  _StudentsScreenState(this.scolList);

  @override
  Widget build(BuildContext context) {
    helper = dbuse(); // Initialize the `helper` variable.
    ListStudentDialog dialog = new ListStudentDialog();
    showData(this.scolList.codClass);

    return Scaffold(
      appBar: AppBar(
        title: Text(scolList.nomClass),
      ),
      body: ListView.builder(
        itemCount: (students != null) ? students.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(students[index].nom),
            onDismissed: (direction) {
              String strName = students[index].nom; // Define the `strName` variable.
              helper.deleteStudent(students[index]);
              setState(() {
                students.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$strName deleted"))); // Use `ScaffoldMessenger.of()` instead of `Scaffold.of()`.
            },
            child: ListTile(
              title: Text(students[index].nom),
              subtitle: Text(
                  'Prenom: ${students[index].prenom} - Date Nais:${students[index].datNais}'),
              onTap: () {},
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        dialog.buildAlert(context, students[index], false),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => dialog.buildAlert(
                context, ListEtudiants(0, scolList.codClass, '', '', ''), true),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }

  Future showData(int idList) async {
    await helper.openDb();
    students = await helper.getEtudiants(idList);
    setState(() {
      students = students;
    });
    didUpdateWidget(StudentsScreen(scolList));
  }
}
