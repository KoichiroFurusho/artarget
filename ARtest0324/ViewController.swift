//
//  ViewController.swift
//  ARtest0324
//
//  Created by Kouichiro Furusho on 2021/03/24.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var sessionInfoLabel: UILabel!
    
    @IBOutlet weak var sceneView: ARSCNView!

    
    @IBAction func switchBoxOrientation(_ sender: Any) {
    }
    
    
    
    
    
    var targetNode : SCNNode!
        
        var screenCenter: CGPoint {
            let bounds = sceneView.bounds
            return CGPoint(x: bounds.midX, y: bounds.midY)
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // デリゲートになる
        sceneView.delegate = self
        

//         Create a new scene
        let scene = SCNScene(named: "art.scnassets/box1.scn")!
            if let box = scene.rootNode.childNode(withName: "box1", recursively: true) {
                box.opacity = 0
        }
    
    // Create a target
            let targetPlane = SCNPlane(width: 0.2, height: 0.2)
            targetPlane.cornerRadius = 1
            targetPlane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.8)
            targetNode = SCNNode(geometry: targetPlane)
            targetNode.isHidden = true
            targetNode.name = "target"
            targetNode.eulerAngles.x =  -Float.pi / 2
            scene.rootNode.addChildNode(targetNode)
            
//            // Setup Omni Light
//            let light = SCNLight()
//            light.type = .omni
//
//            let LightNode = SCNNode()
//            LightNode.light = light
//            LightNode.name = "light"
//            LightNode.position = SCNVector3(-1,2,-1)
//            scene.rootNode.addChildNode(LightNode)
            
            // Set the scene to the view
            sceneView.scene = scene
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
            tapRecognizer.delegate = self
            sceneView.addGestureRecognizer(tapRecognizer)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Create a session configuration
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = [.horizontal]
            
            // Run the view's session
            sceneView.session.run(configuration)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // Pause the view's session
            sceneView.session.pause()
        }

        @objc func tap(_ tapRecognizer: UITapGestureRecognizer) {
            let touchPoint = tapRecognizer.location(in: self.sceneView)
            
            let results = self.sceneView.hitTest(touchPoint, options: [SCNHitTestOption.searchMode : SCNHitTestSearchMode.all.rawValue])
            
            if let result = results.first {
                guard let hitNodeName = result.node.name else { return }
                
//                if hitNodeName == "boxMesh" {
//                    if let box = result.node.parent {
//                        let actMove = SCNAction.move(by: SCNVector3(0, 0, 0), duration: 0)
//                        box.runAction(actMove)
//                    }
//                } else
                if hitNodeName == "target" {
                    if let box = sceneView.scene.rootNode.childNode(withName: "box1", recursively: true) {
                        box.position = targetNode.position
                        
                        let configuration = ARWorldTrackingConfiguration()
                        sceneView.session.pause()
                        sceneView.session.run(configuration)
                        
//                        let completion = {
//                            let rotationAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0, z: 1, duration: 1))
//                            box.runAction(rotationAction)
//                        }
                        
//                        SCNTransaction.begin()
//                        SCNTransaction.animationDuration = 1.5
//                        SCNTransaction.completionBlock = completion
                        box.opacity = 1
//                        SCNTransaction.commit()
                        
                        targetNode.isHidden = true
                    }
                }
            }
            
            
            
            
            
            
            
        }
        
        // MARK: - ARSCNViewDelegate
        
    /*
        // Override to create and configure nodes for anchors added to the view's session.
        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            let node = SCNNode()
         
            return node
        }
    */
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            targetNode.isHidden = false
        }
        
        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            guard let lightEstimate = self.sceneView.session.currentFrame?.lightEstimate else { return }
            let ambientIntensity = lightEstimate.ambientIntensity
            let ambientColorTemperature = lightEstimate.ambientColorTemperature
            
            if let lightNode = self.sceneView.scene.rootNode.childNode(withName: "light", recursively: true) {
                guard let light = lightNode.light else { return }
                light.intensity = ambientIntensity
                light.temperature = ambientColorTemperature
            }
            
            DispatchQueue.main.async {
                let results = self.sceneView.hitTest(self.screenCenter, types: [.existingPlaneUsingGeometry])
                
                if let existingPlaneUsingGeometryResult = results.first(where: { $0.type == .existingPlaneUsingGeometry }) {
                    let result = existingPlaneUsingGeometryResult
                    let transform = result.worldTransform
                    let newPosition = transform.position
                    
                    self.targetNode.position = newPosition
                }
            }
        }
        
        func session(_ session: ARSession, didFailWithError error: Error) {
            // Present an error message to the user
            
        }
        
        func sessionWasInterrupted(_ session: ARSession) {
            // Inform the user that the session has been interrupted, for example, by presenting an overlay
            
        }
        
        func sessionInterruptionEnded(_ session: ARSession) {
            // Reset tracking and/or remove existing anchors if consistent tracking is required
            
        }
    }

    extension matrix_float4x4 {
        var position : SCNVector3 {
            get {
                return SCNVector3(columns.3.x, columns.3.y, columns.3.z)
            }
        }
        
        
        
        
        
        
        
    }


//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        // コンフィグを作る
//        let configuration = ARWorldTrackingConfiguration()
//        // 平面の検出を有効化する（水平面のみ）
//        configuration.planeDetection = [.horizontal]
//        // セッションを開始する
//        sceneView.session.run(configuration)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        // セッションを止める
//        sceneView.session.pause()
//    }
    
    
    
//    @IBAction func tapSceneView(_ sender: UITapGestureRecognizer) {
//
//        // タップした2D座標
//        let tapLoc = sender.location(in: sceneView)
//        // 検知平面とタップ座標のヒットテスト
//        let results = sceneView.hitTest(tapLoc, types: .existingPlaneUsingExtent)
//        // 検知平面をタップしていたら最前面のヒットデータをresultに入れる
//        guard let result = results.first else {
//            return
//        }
//        // ヒットテストの結果からAR空間のワールド座標を取り出す
//        let pos = result.worldTransform.columns.3
//        // 箱ノードを作る
//        let boxNode = BoxNode()
//        // ノードの高さを求める
//        let height = boxNode.boundingBox.max.y - boxNode.boundingBox.min.y
//        let y = pos.y + Float(height/2.0) // 水平面と箱の底を合わせる
//        // 位置決めする
//        boxNode.position = SCNVector3(pos.x, y, pos.z)
//
//        for node in sceneView.scene.rootNode.childNodes {
//            node.removeFromParentNode()
//        }
//        // シーンに箱ノードを追加する
//        sceneView.scene.rootNode.addChildNode(boxNode)
//    }
    
    
    
    
    
    
    
//    // MARK: - ARSCNViewDelegate
//    // ノードが追加された
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        // 平面アンカーではないときは中断する
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {
//            return
//        }
//        // アンカーが示す位置に平面ノードを追加する
//        node.addChildNode(PlaneNode(anchor: planeAnchor))
//    }
//
//    // ノードが更新された
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        // 平面アンカーではないときは中断する
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {
//            return
//        }
//        // PlaneNodeではないときは中断する
//        guard let planeNode = node.childNodes.first as? PlaneNode else {
//            return
//        }
//        // ノードの位置とサイズを更新する
//        planeNode.update(anchor: planeAnchor)
//
//        // フレーム毎に繰り返し実行する（ARSessionDelegateデリゲートメソッド）
//        func session(_ session: ARSession, didUpdate frame: ARFrame){
//            // カメラのトランスフォーム
//            let tf = frame.camera.transform
//            // カメラの位置
//            let x = tf.columns.3.x
//            let z = tf.columns.3.z
//            // shipNodeを取り出す
//            for node in sceneView.scene.rootNode.childNodes {
//                if node is PlaneNode {
//                    // 機首を水平に保つためにY軸はshipNodeの値を利用する
//                    let pos = SCNVector3(x, node.position.y, z)
//                    // カメラの方向を向く
//                     node.look(at: pos)
//                }
//            }
//
//    }
//
//
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        // Present an error message to the user
//
//    }
//
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Inform the user that the session has been interrupted, for example, by presenting an overlay
//
//    }
//
//    func sessionInterruptionEnded(_ session: ARSession) {
//        // Reset tracking and/or remove existing anchors if consistent tracking is required
//
//    }
//
//}

