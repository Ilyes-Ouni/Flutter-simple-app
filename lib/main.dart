import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tp5/ui/scol_list_dialog.dart';
import 'package:tp5/ui/students_screen.dart';
import 'package:tp5/utile/dbuse.dart';
import 'models/list_etudiants.dart';
import 'models/scol_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Classes List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShList(),
    );
  }
}

class ShList extends StatefulWidget {
  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  List<ScolList> scolList = [];
  ScolListDialog? dialog ; // Add this line
  dbuse helper = dbuse();

  @override
  void initState() {
    super.initState();
    helper = dbuse();
    showData();
    dialog = ScolListDialog(); // Initialize the dialog
// Call showData to populate the class list
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => dialog!.buildDialog(context, ScolList(0, '', 0), true),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
      appBar: AppBar(
        title: Text('Classes list'),
      ),
      body: ListView.builder(
        itemCount: (scolList != null) ? scolList.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
              key: Key(scolList[index].nomClass),
            onDismissed: (direction) {
                String strName = scolList[index].nomClass;
                helper.deleteClass(scolList[index].codClass);
                setState(() {
                  scolList.removeAt(index);
                }
                );
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("$strName deleted"),
                    )
                );
              },
            child: ListTile(
              title: Text(scolList[index].nomClass),
              leading: CircleAvatar(
                child: Text(scolList[index].codClass.toString()),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Navigate to the StudentsScreen with the selected class
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentsScreen(scolList[index]),
                    ),
                  );
                },
              ),
            ),
          );
        },
      )
    );
  }

  Future showData() async {
    await helper.openDb();
    ScolList list1 = ScolList(11, "DSI31", 30);
    int ClassId1 = await helper.insertClass(list1);
    ScolList list2 = ScolList(12, "DSI32", 26);
    int ClassId2 = await helper.insertClass(list2);
    ScolList list3 = ScolList(13, "DSI33", 28);
    int ClassId3 = await helper.insertClass(list3);
    String dateStart = '22-04-2021';
    DateFormat inputFormat = DateFormat('dd-MM-yyyy');
    DateTime input = inputFormat.parse(dateStart);
//String datee = DateFormat('hh:mm a').format(input);
    String datee = DateFormat('dd-MM-yyyy').format(input);
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    ListEtudiants etud =
    ListEtudiants(1, ClassId1, "Ali", "Ben Mohamed", datee);
    int etudId1 = await helper.insertEtudiants(etud);
    print('classe Id: ' + ClassId1.toString());
    print('etudiant Id: ' + etudId1.toString());
    etud = ListEtudiants(2, ClassId2, "Salah", "Ben Salah", datee);
    etudId1 = await helper.insertEtudiants(etud);
    etud = ListEtudiants(3, ClassId2, "Slim", "Ben Slim", datee);
    etudId1 = await helper.insertEtudiants(etud);
    etud = ListEtudiants(4, ClassId3, "Foulen", "Ben Foulen", datee);
    etudId1 = await helper.insertEtudiants(etud);

    scolList = await helper.getClasses();
    setState(() {
      scolList = scolList;
    });
  }
}