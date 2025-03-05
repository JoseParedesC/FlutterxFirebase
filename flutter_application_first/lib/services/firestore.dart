import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
 
  // get collection

  final CollectionReference notes = 
    FirebaseFirestore.instance.collection("notes");
  
  //CREATE
  Future<void> addnote(String note){
    return notes.add({
      'note': note,
      'Timestamp' : Timestamp.now()
    });
  }
  
  //READ
  Stream<QuerySnapshot> readNoteStream(){
    final notesStream = 
      notes.orderBy('Timestamp', descending: true).snapshots();

    return notesStream;
  }
  
  //UPDATE
  
  
  //DELETE
}