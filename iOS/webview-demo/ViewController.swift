//
//  ViewController.swift
//  webview-demo
//
//  Created by Samuel Sanchez on 11/13/20.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {
    @IBOutlet weak var textLabel:UILabel?
    @IBOutlet weak var webView:WKWebView!
    @IBOutlet weak var textField:UITextField?
    
    let url = "https://tmh.red:8089"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        let contentController = webView.configuration.userContentController
        contentController.add(self, name: "share")
        contentController.add(self, name: "jsHandler")

        let request = URLRequest(url : URL(string: url)!)
        webView.load(request)
    }

    @IBAction func onButtonTap() {
        let msg = textField?.text ?? ""
        let jsCode = "debug('from app: " + msg + " ')"
        webView.evaluateJavaScript(jsCode, completionHandler: nil)
    }
    
    @IBAction func onButtonReload() {
        webView.reload()
    }
    
    func share (title: String?, text: String?, url: String?) {
        print(title!)
        print(text!)
        print(url!)
    
        let textToShare = [ text ]
        let ac = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
        //ac.popoverPresentationController?.sourceView = self.view
        present(ac, animated: true, completion: goToPostShare)
    }
    
    func goToPostShare() {
        webView.evaluateJavaScript("debug('triggered func goToPostShare()')", completionHandler: nil)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        if message.name == "share" {
            js_share(message: message)
        } else if message.name == "jsHandler" {
            js_jsHandler(message: message);
        }
    }
    
    func js_jsHandler(message: WKScriptMessage) {
        textLabel?.text = message.body as? String
    }
    
    func js_share(message: WKScriptMessage) {
        struct Share : Decodable {
            let title: String?
            let text: String?
            let url: String?
        }
        
        let oMessage = message.body as? String ?? ""
        let data = oMessage.data(using: .utf8)!
        let oShare: Share = try! JSONDecoder().decode(Share.self, from: data)

        print(oShare.url)
        
        share(title: oShare.title, text: oShare.text, url: oShare.url)
    }
}

