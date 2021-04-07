//
//  Info.swift
//  ARtest0324
//
//  Created by Kouichiro Furusho on 2021/04/01.
//

import SceneKit
import ARKit

extension ViewController {
    // トラッキングステータスの更新
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }

    // セッション情報のラベル表示
    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        let sessionInfoMessage: String
        switch trackingState {

        case .normal where frame.anchors.isEmpty:
            sessionInfoMessage = "カメラを左右にゆっくり動かして、箱を置く場所をタップしてください。"

        case .notAvailable:
            sessionInfoMessage = "カメラを左右にゆっくり動かしてください"
            
        case .limited(.excessiveMotion):
            sessionInfoMessage = "ゆっくり動かしてください。"

        case .limited(.insufficientFeatures):
            sessionInfoMessage = "特徴点をトラッキングできません。"


        case .limited(.relocalizing):
            sessionInfoMessage = "リジューム中..."

        case .limited(.initializing):
            sessionInfoMessage = "AR起動中..."
        default:
            sessionInfoMessage = ""
        }
        sessionInfoLabel.text = sessionInfoMessage // メッセージの表示
        sessionInfoLabel.isHidden = sessionInfoMessage.isEmpty // メッセージが空のときは消す
    }

}
