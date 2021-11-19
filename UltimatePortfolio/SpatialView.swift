//
//  SpatialView.swift
//  UltimatePortfolio
//
//  Created by Erik Leon on 11/18/21.
//

import SwiftUI
import SceneKit

struct SpatialView: View {
    static let tag: String? = "3D"
    
    //creating the scene
    static func makeScene() -> SCNScene? {
        let scene = SCNScene(named: "test.scn")
        scene?.background.contents = Color.clear
        return scene
    }
    let scene = makeScene()
    
    var cameraNode: SCNNode? {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 3)
        return cameraNode
    }
    func createBox() -> SCNNode {
        let geometry = SCNBox(width:1,height:1,length: 1,chamferRadius: 0.2)
        let material = SCNMaterial()
        let boxNode = SCNNode(geometry: geometry)
        material.diffuse.contents = Color.teal
        
        boxNode.name = "box"
        boxNode.position = SCNVector3(x: 1, y:0, z: 1)
        boxNode.geometry?.materials = [material]
        return boxNode
    }
    func addBox() {
        scene?.rootNode.addChildNode(createBox())
    }
    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    SceneView(
                        scene: scene,
                        pointOfView: cameraNode,
                        options: [.allowsCameraControl]
                    )
                        .frame(width: 400, height: 400)
                    Text("Cone")
                        .font(.title)
                }
                HStack {
                    Button(action: {
                        addBox()
                    }, label: {
                        Image(systemName: "plus.viewfinder")
                    })
                    
                }
            }
        }
    }
}

struct SpatialView_Previews: PreviewProvider {
    static var previews: some View {
        SpatialView()
    }
}
