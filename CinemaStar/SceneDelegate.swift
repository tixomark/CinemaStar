// SceneDelegate.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        createWindow(with: scene)
    }

    private func createWindow(with scene: UIScene) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let builder = ModuleBuilder(serviceLocator: createServiceLocator())
        appCoordinator = AppCoordinator(window: window, builder: builder)
        appCoordinator?.start()
        window?.makeKeyAndVisible()
    }

    private func createServiceLocator() -> ServiceLocatorProtocol {
        let networkService = NetworkService()
        let serviceDistributor = ServiceDistributor()
        serviceDistributor.registerService(service: networkService)
        return serviceDistributor
    }
}
