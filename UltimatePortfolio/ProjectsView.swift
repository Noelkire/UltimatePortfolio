//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Erik Leon on 11/18/21.
//

import SwiftUI

struct ProjectsView: View {
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    
    @State private var showingSortOrder = false
    @State private var sortOrder = Item.SortOrder.optimized
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let showClosedProjects: Bool
    let projects: FetchRequest<Project>
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        
        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [ NSSortDescriptor(keyPath: \Project.creationDate, ascending: false) ], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
    }
    func items(for project: Project) -> [Item] {
        switch sortOrder {
        case .optimized:
            return project.projectItemsDeafaultSorted
        case .title:
            return project.projectItems.sorted { $0.itemTitle < $1.itemTitle}
        case .creationDate:
            return project.projectItems.sorted { $0.itemCreationDate < $1.itemCreationDate }
        }
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
                    Section(header: ProjectHeaderView(project:project)) {
                        //items are stored as a set when adding relationships so it doesnt
                        // allow duplicates. Since this is an obj-c set we have to typecast
                        ForEach(items(for:project)) { item in
                            ItemRowView(item: item)
                        }
                        .onDelete { offsets in
                            let allItems = project.projectItems
                            
                            for offset in offsets {
                                let item = allItems[offset]
                                dataController.delete(item)
                            }
                            dataController.save()
                        }
                        if showClosedProjects == false {
                            Button {
                                withAnimation {
                                    let item = Item(context: managedObjectContext)
                                    item.project = project
                                    item.creationDate = Date()
                                    dataController.save()
                                }
                            } label: {
                                Label("Add New Item", systemImage: "plus")
                            }
                        }
                    }
                }
            }
            //styling of the list, gives it an inset
            .listStyle(InsetGroupedListStyle())
            //name of the View based on where closed or open
            .navigationTitle(showClosedProjects ? "Closed Projects": "Open Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showClosedProjects == false {
                        Button {
                            withAnimation {
                                let project = Project(context: managedObjectContext)
                                project.closed = false
                                project.creationDate = Date()
                                dataController.save()
                            }
                        } label: {
                            Label("Add Project", systemImage: "plus")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSortOrder.toggle()
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort items"),message: nil, buttons: [
                    .default(Text("Optimized")){ sortOrder = .optimized },
                    .default(Text("Creation Date")) { sortOrder = .creationDate },
                    .default(Text("Title")) { sortOrder = .title }
                ])
            }
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
