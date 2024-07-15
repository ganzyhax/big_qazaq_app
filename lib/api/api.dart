import 'package:cloud_firestore/cloud_firestore.dart';

class ApiClient {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<dynamic> login(String phone, pass) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('users')
        .where('phone', isEqualTo: phone)
        .where('password', isEqualTo: pass)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return {
        'userId': snapshot.docs.first.id,
        'isVerified': snapshot.docs.first['isVerified'] ?? false,
        'isAdmin': snapshot.docs.first['isAdmin'] ?? false,
      };
    } else {
      return null;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentById(
      String collection, String id) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firestore.collection(collection).doc(id).get();

    return documentSnapshot;
  }

  Future<void> updateFieldById(String collectionName, String documentId,
      String fieldName, dynamic newValue) async {
    try {
      // Construct the document reference using the documentId
      DocumentReference documentReference =
          _firestore.collection(collectionName).doc(documentId);

      // Update the specific field
      await documentReference.update({fieldName: newValue});

      print(
          'Field $fieldName updated successfully for document with ID $documentId.');
    } catch (e) {
      print('Error updating field: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllDocuments(
      String collectionName) async {
    List<Map<String, dynamic>> documents = [];

    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collectionName).get();

      querySnapshot.docs.forEach((doc) {
        // Check if doc.data() is not null and is of type Map<String, dynamic>
        if (doc.data() is Map<String, dynamic>) {
          documents.add(doc.data() as Map<String, dynamic>);
        } else {
          print(
              'Document data is not of type Map<String, dynamic>: ${doc.data()}');
        }
      });

      return documents;
    } catch (e) {
      print('Error retrieving documents: $e');
      return [];
    }
  }

  Future<dynamic> addDocument(String collection, var data, bool withId) async {
    try {
      // Replace 'users' with your collection name
      DocumentReference documentReference =
          _firestore.collection(collection).doc();

      // Set the document with the provided data
      if (withId) {
        data['id'] = documentReference.id;
        await documentReference.set(data);
      } else {
        await documentReference.set(data);
      }

      // Return a map with success status and document ID
      return documentReference.id;
    } catch (e) {
      // Return a map with success status and error message
      return null;
    }
  }

  Future<bool> deleteDocument(String collection, String documentId) async {
    try {
      // Reference to the document
      DocumentReference docRef =
          _firestore.collection(collection).doc(documentId);

      // Delete the document
      await docRef.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDocument(
      String collection, String documentId, Map<String, dynamic> data) async {
    try {
      // Reference to the document in the specified collection
      DocumentReference documentReference =
          _firestore.collection(collection).doc(documentId);

      // Update the document with the provided data
      await documentReference.update(data);

      return true; // Return true on successful update
    } catch (e) {
      return false; // Return false if there's an error
    }
  }

  Future<dynamic> checkFieldExist(
      String collection, String field, String value) async {
    final QuerySnapshot snapshot = await _firestore
        .collection(collection)
        .where(field, isEqualTo: value)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<String?> getUniqueFieldId(
      String collection, String field, String value) async {
    final QuerySnapshot snapshot = await _firestore
        .collection(collection)
        .where(field, isEqualTo: value)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    } else {
      return null;
    }
  }

  Future<String> getBundleVersion() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await firestore.collection('utils').doc('HmCKlTRpJFRDs24Ufvm5').get();

    return documentSnapshot['currentAppVersion'];
  }
}
