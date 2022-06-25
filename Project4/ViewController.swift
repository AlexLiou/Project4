//
//  ViewController.swift
//  Project4
//
//  Created by Alex Liou on 6/25/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    var websiteToLoad: String?

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://" + websiteToLoad!)!
        navigationController?.navigationBar.prefersLargeTitles = true
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Open",
            style: .plain,
            target: self,
            action: #selector(openTapped))

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)

        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))

        let Forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))

        let Back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))

        toolbarItems = [Back, Forward, spacer, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

//        if let host = url?.host {
//            for website in websites {
//                if host.contains(website) {
//                    decisionHandler(.allow)
//                    return
//                }
//            }
//
//            let ac = UIAlertController(title: "This website is BLOCKED", message: nil, preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "SORRY", style: .cancel))
//            present(ac, animated: true)
//        }
        if let host = url?.host {
            if host.contains(websiteToLoad!) {
                decisionHandler(.allow)
                return
            }
        }
        let ac = UIAlertController(title: "This website is BLOCKED", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "SORRY", style: .cancel))
        present(ac, animated: true)

        decisionHandler(.cancel)
    }


}

