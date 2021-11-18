//
//  HomeView.swift
//  UltimatePortfolio
//
//  Created by Erik Leon on 11/18/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataController: DataController
    var body: some View {
        NavigationView{
            VStack{
                Button("Add Data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
