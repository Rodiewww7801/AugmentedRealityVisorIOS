//
//  FirebaseManager.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 12.05.2022.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Combine
import SwiftUI

class FirebaseManager: NSObject {
    let auth: Auth
    let firestore: Firestore
    let storage: Storage
    static let _shared =  FirebaseManager()
    private var subscriptions = Set<AnyCancellable>()
    
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.storage = Storage.storage()
        super.init()
    }
    
    func downloadPDFFromFirabase(relativePath: String, completion: @escaping(_ fileURL: URL) -> Void) {
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = docsURL.appendingPathComponent(relativePath)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            completion(fileURL)
            return
        }
        
        let storageRef = self.storage.reference(withPath: relativePath)
        
        storageRef.write(toFile: fileURL) { url, error in
            guard let localURL = url else {
                print("Error download file with the path: \(relativePath) \(String(describing: error?.localizedDescription))")
                return
            }
            
            completion(localURL)
        }.resume()
    }
}
