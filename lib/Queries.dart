import 'package:cloud_firestore/cloud_firestore.dart';

class Queries{

  static final Queries _instance = Queries.internal();
  Queries.internal();
  factory Queries() => _instance;

  UpdateVote(String Str, DocumentSnapshot Q) {
    var j = Q.data.keys.firstWhere((K) => Q.data[K] == Str, orElse: () => null);
    if (j == "A1") {
      Firestore.instance
          .collection("Poll Questions")
          .document(Q.documentID)
          .updateData({"V1": FieldValue.increment(1)});
    }
    if (j == "A2") {
      Firestore.instance
          .collection("Poll Questions")
          .document(Q.documentID)
          .updateData({"V2": FieldValue.increment(1)});
    }
    if (j == "A3") {
      Firestore.instance
          .collection("Poll Questions")
          .document(Q.documentID)
          .updateData({"V3": FieldValue.increment(1)});
    }
    if (j == "A4") {
      Firestore.instance
          .collection("Poll Questions")
          .document(Q.documentID)
          .updateData({"V4": FieldValue.increment(1)});
    }
  }
}
