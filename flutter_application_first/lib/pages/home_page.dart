import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_first/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //firestore
  final FirestoreService firestoreServices = FirestoreService();

  //text controller
  final TextEditingController textController = TextEditingController();
  
  //abrir cuadro de dialogo
  void openNoteBox(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          //save
          ElevatedButton(
            onPressed: () {
              firestoreServices.addnote(textController.text);

              textController.clear();

              Navigator.pop(context);
            }, 
            child: Text("Add")
          )
        ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Notes"),
        backgroundColor: Theme.of(context).colorScheme.primary
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.file_open),
        ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreServices.readNoteStream(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List notesList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index){
                DocumentSnapshot document = notesList[index];

                //String docId = document.id;

                Map<String, dynamic> data = 
                  document.data() as Map<String, dynamic>;
                String noteText = data['note'];

                return ListTile(
                  title: Text(noteText),
                );
              });
          }else
          {
            return const Text("No Notes yet...");
          }
        },
      ),
    );
  }
}