//
//  ContentView.swift
//  UltimatePortfolio
//
//  Created by Erik Leon on 11/17/21.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            ProjectsView(showClosedProjects: false)
                .tag(ProjectsView.openTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Open")
                }
            ProjectsView(showClosedProjects: true)
                .tag(ProjectsView.closedTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }
            SpatialView()
                .tag(SpatialView.tag)
                .tabItem {
                    Image(systemName: "cube.transparent")
                    Text("3D")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
