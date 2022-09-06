//
//  SecureViewController.swift
//  Checkout
//
//  Created by Sergiy Kostrykin on 01/09/2022.
//

import UIKit
import WebKit

class SecureViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        var object = WKWebView(frame: .zero, configuration: configuration)
        object.translatesAutoresizingMaskIntoConstraints = false
        object.navigationDelegate = self
        object.uiDelegate = self
        return object
    }()
    
    private var url: URL
    private var onCompletion: ((_ controller: SecureViewController, _ isSuccess: Bool)->())?
    
    required init(url: URL, onCompletion: ((_ controller: SecureViewController, _ isSuccess: Bool)->())?) {
        self.url = url
        self.onCompletion = onCompletion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateConstraints()
    }

}

private extension SecureViewController {
    
    func setupUI() {
        view.addSubview(webView)
    }
    
    func updateConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func checkNavigationUrl(url: URL?) {
        if url?.absoluteString.contains(Link.success.rawValue) == true {
            onCompletion?(self, true)
        }
        
        if url?.absoluteString.contains(Link.failure.rawValue) == true {
            onCompletion?(self, false)
        }
    }
    
}

extension SecureViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WKWebView::: didFinishe navigation")
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("WKWebView::: webViewWebContentProcessDidTerminate")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        checkNavigationUrl(url: navigationAction.request.url)
        return .allow
    }

}

extension SecureViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("message::: \(message)")
    }
}

extension SecureViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        print("WKWebView::: navigationAction: \(navigationAction)")
//        if navigationAction.targetFrame == nil {
//            webView.load(navigationAction.request)
//        }
        return nil
    }
}



