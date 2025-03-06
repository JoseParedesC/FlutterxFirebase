import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
 
  // get collection

  final CollectionReference notes = 
    FirebaseFirestore.instance.collection("notes");
  
  //CREATE
  Future<void> addNote(String note, String details){
    return notes.add({
      'note': note,
      'details': details,
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
  Future<void> updateNote(String docId, String note, String detail){
    return notes.doc(docId).update({
      'note': note,
      'details': detail
    });
  }
  
  //DELETE
  Future<void> deleteNote(String docId){
    return notes.doc(docId).delete();
  }
  
}