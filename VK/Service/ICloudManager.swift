//
//  ICloudManager.swift
//  VK
//
//  Created by Maxim Tolstikov on 07/04/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.
//

import CloudKit

class ICloudManager {
    
    let conteiner: CKContainer
    let containerDatabase: CKDatabase
    let recordId: CKRecordID
    
    init(recordName: String) {
        
        self.conteiner = CKContainer.default()
        self.containerDatabase = conteiner.privateCloudDatabase
        self.recordId = CKRecordID(recordName: recordName)
    }
    
    func saveCloud(id: Int) {
        
        let record = String(id)
        
        let publicationRecord = CKRecord(recordType: "Publication", recordID: recordId)
        publicationRecord.setValue(record, forKey: "Friend ID")
        
        containerDatabase.save(publicationRecord) { (record, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            print("Запись успешно сохранена в iCloud")
        }
    }
    
    func loadCloud(complitionHandler: @escaping (Int) -> (Void)) {
        
        containerDatabase.fetch(withRecordID: recordId) { (record, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            let id = record!.value(forKey: "Friend ID") as! Int
            complitionHandler(id)
            
        }
    }
}
