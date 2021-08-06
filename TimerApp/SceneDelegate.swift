//
//  SceneDelegate.swift
//  TimerApp
//
//  Created by Michał Dunajski on 03/08/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        let navigationVC = UINavigationController()
        navigationVC.isNavigationBarHidden = true
        window?.rootViewController = navigationVC
        navigationVC.pushViewController(ViewController(), animated: false)
        window?.makeKeyAndVisible()
    }

}
