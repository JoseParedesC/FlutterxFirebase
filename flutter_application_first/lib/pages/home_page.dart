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
  TextEditingController textController = TextEditingController();
  TextEditingController detController = TextEditingController();
  

  //abrir cuadro de dialogo
  void openNoteBox({String? docId, String? noteText, String? noteDet}){

    textController = TextEditingController(text: noteText);
    detController = TextEditingController(text: noteDet);

    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nota'),
              controller: textController,
            ),
            
            TextField(
              decoration: InputDecoration(labelText: 'Descripcion'),
              controller: detController,
              maxLines: 3,
            ),
          ]
        ),
        actions: [
          //save
          ElevatedButton(
            onPressed: () {

              if(docId == null){
                firestoreServices.addNote(textController.text, detController.text);
              }

              else{
                firestoreServices.updateNote(docId, textController.text, detController.text);
              }

              textController.clear();

              Navigator.pop(context);
            }, 
            child: Text("Add")
          )
        ],
    ));
  }


void deleteandClear({required String docId}){
  Navigator.pop(context);
  firestoreServices.deleteNote(docId);
}


  void openConfirmBox({required String docId, required String noteText}){

    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Quiere eliminar el documento $docId - $noteText?'),
        actions: [
          //save

          ElevatedButton(
            onPressed: () => deleteandClear(docId: docId),
            child: Text('Aceptar')
            //backgroundColor: Colors.red
          ),

          ElevatedButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('Cancelar'),
            //backgroundColor: Colors.red
          )
        ]

      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
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
                String docId = document.id;

                Map<String, dynamic> data = 
                  document.data() as Map<String, dynamic>;
                String noteText = data['note'];
                String? noteDet = data['details'];

                return ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      IconButton(
                        onPressed:() => openNoteBox(docId : docId, noteText:noteText, noteDet:noteDet), 
                        icon: const Icon(Icons.edit)
                      ),

                      IconButton(
                        onPressed:() => openConfirmBox(docId: docId, noteText:noteText), 
                        icon: const Icon(Icons.delete)
                      ),

                    ],
                  )
                      
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