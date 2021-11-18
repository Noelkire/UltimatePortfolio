//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by Erik Leon on 11/17/21.
//

import SwiftUI

@main
struct UltimatePortfolioApp: App {
    //Our entire project needs access to a DataController instance
    // We created one inside our @main/App Struct
    @StateObject var dataController: DataController
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    func save(_ note: Notification) {
        dataController.save()
    }
    var body: some Scene {
        WindowGroup {
            //sending our data controller into the ContentView environment
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save)
        }
    }
}
