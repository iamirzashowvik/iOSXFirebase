//
//  CloudDBManager.swift
//  SwiftUI_Firebase
//
//  Created by Mirza Showvik on 25/11/23.
//

import Foundation
import FirebaseFirestore

struct CloudDBManager{
    let db = Firestore.firestore()
    func addData(){
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        
        ref = db.collection("users").addDocument(data: [
          "first": "Ada",
          "last": "Lovelace",
          "born": 1815
        ]) { err in
          if let err = err {
            print("Error adding document: \(err)")
          } else {
            print("Document added with ID: \(ref!.documentID)")
          }
        }
    }
    
    
    func getData(){
        db.collection("users").getDocuments() { (querySnapshot, err) in
          if let err = err {
            print("Error getting documents: \(err)")
          } else {
            for document in querySnapshot!.documents {
              print("\(document.documentID) => \(document.data())")
            }
          }
        }
    }
}
