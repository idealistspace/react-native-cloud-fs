//
//  RNCloudFileLoader.swift
//  RNCloudFs
//
//  Created by Shaomeng Zhang on 10/2/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

import Foundation

@objc(RNCloudFileLoader)
class RNCloudFileLoader: NSObject {
    
    var query: NSMetadataQuery!
    var filePath: String!

    @objc override init() {
        super.init()
        
        initialiseQuery()
        addNotificationObservers()
    }
    
    func initialiseQuery() {
        
        query = NSMetadataQuery.init()
        query.operationQueue = .main
        query.searchScopes = [NSMetadataQueryUbiquitousDataScope]
        query.predicate = NSPredicate(format: "%K LIKE %@", NSMetadataItemFSNameKey, self.filePath)
    }
    
    func addNotificationObservers() {
                        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidStartGathering, object: query, queue: query.operationQueue) { (notification) in
            self.processCloudFiles()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryGatheringProgress, object: query, queue: query.operationQueue) { (notification) in
            self.processCloudFiles()
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidUpdate, object: query, queue: query.operationQueue) { (notification) in
            self.processCloudFiles()
        }
    }
    
    @objc func processCloudFiles() {
           
       if query.results.count == 0 { return }
       var fileItem: NSMetadataItem?
       var fileURL: URL?
       
       for item in query.results {
           
           guard let item = item as? NSMetadataItem else { continue }
           guard let fileItemURL = item.value(forAttribute: NSMetadataItemURLKey) as? URL else { continue }
           if fileItemURL.lastPathComponent.contains("sample.mp4") {
               fileItem = item
               fileURL = fileItemURL
           }
       }
       
       try? FileManager.default.startDownloadingUbiquitousItem(at: fileURL!)
       
       if let fileDownloaded = fileItem?.value(forAttribute: NSMetadataUbiquitousItemDownloadingStatusKey) as? String, fileDownloaded == NSMetadataUbiquitousItemDownloadingStatusCurrent {
           
           query.disableUpdates()
           query.operationQueue?.addOperation({ [weak self] in
               self?.query.stop()
           })
           print("Download complete")
       
       } else if let error = fileItem?.value(forAttribute: NSMetadataUbiquitousItemDownloadingErrorKey) as? NSError {
           print(error.localizedDescription)
       } else {
           if let keyProgress = fileItem?.value(forAttribute: NSMetadataUbiquitousItemPercentDownloadedKey) as? Double {
               print("File downloaded percent ---", keyProgress)
           }
       }
   }
    
    func load() {
        
        query.operationQueue?.addOperation({ [weak self] in
            self?.query.start()
            self?.query.enableUpdates()
        })
    }
}
