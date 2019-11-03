//
//  SceneDelegate.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-29.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        guard let navController = setInitialViewController() else { return }
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = navController
            self.window = window
            window.makeKeyAndVisible()
        }
        return
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

// The purpose of these functions is to log th user in on startup if there are valid tokens.  If there are no valid token
// the login screeen is shown.

extension SceneDelegate {
    
    private func setInitialViewController() -> NavController? {
        
        guard let savedRefreshToken = UserDefaults.standard.string(forKey: Constants.refresh_token.rawValue) else { return nil }
        guard let encodedRefreshToken = getEncodedRefreshToken(tokenString: savedRefreshToken) else {
            return nil
        }
        
        let newToken = RESTApiManager.sharedInstance.prepareSynchonousRequest(endPoint: Endpoints.refresh.rawValue, json: encodedRefreshToken, requestType: "POST")
        
        if newToken != nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let newTokens = AuthenticationTokens(jwt: newToken, refresh_token: savedRefreshToken)
            let ideaViewController = storyboard.instantiateViewController(withIdentifier: "IdeaViewController") as! IdeaViewController
            ideaViewController.authenticationTokens = newTokens
            let navController = NavController(rootViewController: ideaViewController)
            
            let loginController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LogInViewController
            navController.viewControllers.insert(loginController, at: 0)
            return navController
        }
        
        return nil
    }
    
    private func getEncodedRefreshToken(tokenString: String) -> Data?{
        let refreshToken = AuthenticationTokens(refresh_token: tokenString)
        var encodedRefreshToken: Data!
        do { encodedRefreshToken = try JSONEncoder().encode(refreshToken) }
        catch { fatalError("Could not encode") }
        return encodedRefreshToken
    }
}

