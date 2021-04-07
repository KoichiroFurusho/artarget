//
//  planeNode.swift
//  ARtest0324
//
//  Created by Kouichiro Furusho on 2021/03/31.
//

//import SceneKit
//import ARKit
//
//class PlaneNode: SCNNode {
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    init(anchor: ARPlaneAnchor) {
//        super.init()
//        // 平面のジオメトリを作る
//        let plane = SCNPlane(width: 0.1, height: 0.1)
//        // 緑で塗りは半透明（ワイヤーフレームはsceneViewで設定、白色）
////        plane.firstMaterial?.diffuse.contents = UIColor.yellow.withAlphaComponent(0.5)
//        plane.widthSegmentCount = 10
//        plane.heightSegmentCount = 10
//        // ノードのgeometryプロパティに設定する
//        geometry = plane
//        // 向きはX軸回りで90度回転
//        rotation = SCNVector4(1, 0, 0, -0.5 * Float.pi)
//        // 位置決めする
//        position = SCNVector3(anchor.center.x, 0, anchor.center.z)
//    }
//    
//    // 位置とサイズを更新する
//    func update(anchor: ARPlaneAnchor) {
//        // ダウンキャストする
//        let plane = geometry as! SCNPlane
//        // アンカーから平面の幅、高さを更新する
//        plane.width = 0.1
//        plane.height = 0.1
//        // 座標を更新する
//        position = SCNVector3(anchor.center.x, 0, anchor.center.z)
//    }
//}
