//
//  DataController.swift
//  UltimatePortfolio
//
//  Created by Erik Leon on 11/18/21.
//

// Responsible for setting up Core Data and the interactions with it

import CoreData
import SwiftUI

//Conforms to ObservableObject which allows SwiftUI views to create an instance
// of this class and watch it if needed
class DataController: ObservableObject {
    //Given the class a property of NSPersistentCloudKitContainer
    // Responsible for loading and manging local data with Core Data
    // in addition to syncing with iCloud
    let container: NSPersistentCloudKitContainer
    
    //must contain an initializer since its class. Here we define the initializer
    init(inMemory: Bool = false) {
        //configuring container
        container = NSPersistentCloudKitContainer(name: "Main")
        
        //checks if the inMemory boolean is set to true
        // if true load the data or create the data in memory rather on disk
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        //load our data, this will load to disk or create if it doesnt exist. If failure,
        // we catch the error
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal errror loading store: \(error.localizedDescription)")
            }
        }
    }
    //function for creating sample data to test with, this function can throw
    // meaning it can error out so we must be able to catch the error
    func createSampleData() throws {
        // View context is the pool of data that has been loaded from disk into memory.
        // The view context holds all sorts of active objects in memory as we work
        // with them and only writes them back to the disk when we ask
        let viewContext = container.viewContext
        
        for i in 1...5 {
            //Project can be used as a class thanks to CoreData and Xcode automatically creating
            // that reference
            // We have to say in which context so it know where they were created to
            // then save them where they belong later on
            let project = Project(context: viewContext)
            project.title = "Project \(i)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()
            
            for j in 1...10 {
                //Item can be used as a class thanks to CoreData and Xcode automatically creating
                // that reference
                let item = Item(context: viewContext)
                item.title = "Item \(j)"
                item.creationDate = Date()
                item.completed = Bool.random()
                item.project = project
                item.priority = Int16.random(in: 1...3)
            }
        }
        // Once all the data has been generated and created we will "save" all these objects
        // using save() tells CoreData to write the objects into persistent storage
        try viewContext.save()
    }
    // For use with SwiftUI Previews
    // Static property
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }
        
        return dataController
    }()
    // Making a way to save changes
    // If other parts of the app has made changes to data it can write those out to disk
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    // Making a way to delete specifc project or items from the view context
    // We can pass directly to the view context's own delete method, it can be done all in one method
    // all Core Data classes inherit from a parent class called NSManagedObject
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    // Creating a way to delete all contents of the database
    // Using fetch requests to find and delete all items we have
    func deleteAll() {
        //look for Items without filter, Core Data looks for items without a filter (i.e all items)
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        //Wrap the fetch request in a batch delete request tells Core Data to delete all objects
        //that match the request
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        //Execture teh bath request on the view context
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        
        //look for Projects without a filter, all projects will be found
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        //the fetchrequest is wrapped into the batch delete request. Tell CoreData to delete all found objects
        // in this case all objects
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        //Execture the request to delete the objects found
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }
}
