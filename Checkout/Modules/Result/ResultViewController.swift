//
//  ResultViewController.swift
//  Checkout
//
//  Created by Sergiy Kostrykin on 01/09/2022.
//

import UIKit

class ResultViewController: UIViewController {
    
    private var isSuccess: Bool
    
    required init(isSuccess: Bool) {
        self.isSuccess = isSuccess
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = isSuccess ? .green : .red
    }
}
