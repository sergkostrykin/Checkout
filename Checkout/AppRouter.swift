//
//  AppRouter.swift
//  Checkout
//
//  Created by Sergiy Kostrykin on 31/08/2022.
//

import UIKit

class AppRouter: NSObject {
    
    // MARK: - Properties
    static let shared = AppRouter()
    private var window: UIWindow!
    
    // MARK: - init
    override init () {
        self.window = UIWindow()
        self.window.makeKeyAndVisible()
        super.init()
        showCheckoutViewController()
    }
    
    func showCheckoutViewController() {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        window.rootViewController = CheckoutViewController()
    }
}
