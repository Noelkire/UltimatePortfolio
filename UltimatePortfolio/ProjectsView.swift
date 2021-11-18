//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Erik Leon on 11/18/21.
//

import SwiftUI

struct ProjectsView: View {
    let showClosedProjects: Bool
    let projects: FetchRequest<Project>
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        
        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [ NSSortDescriptor(keyPath: \Project.creationDate, ascending: false) ], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }
    
    var body: some View {
        NavigationView {
            List {
                //Since we used FetchRequest directly we have to read from its inner
                //value using .wrappedValue. Contains an array of all the projects
                // in our Core Data storage, sorted by creation date, and filtered by
                //either open or closed
                ForEach(projects.wrappedValue) { project in
                    //for each project, it will appear as a seperate section in the table
                    Section(header: Text(project.title ?? "")) {
                        //items are stored as a set when adding relationships so it doesnt
                        // allow duplicates. Since this is an obj-c set we have to typecast
                        ForEach(project.items?.allObjects as? [Item] ?? []) { item in
                            Text(item.title ?? "")
                        }
                    }
                }
            }
            //styling of the list, gives it an inset
            .listStyle(InsetGroupedListStyle())
            //name of the View based on where closed or open 
            .navigationTitle(showClosedProjects ? "Closed Projects": "Open Projects")
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectsView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
