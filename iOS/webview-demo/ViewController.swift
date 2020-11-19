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
    
    struct LogMessage : Decodable {
        let message: String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        let contentController = webView.configuration.userContentController
        contentController.add(self, name: "jsOnShare")
        contentController.add(self, name: "jsOnBackPressed")
        contentController.add(self, name: "jsHandler")
        contentController.add(self, name: "jsLog")

        let request = URLRequest(url : URL(string: url)!)
        self.webView.load(request)
    }

    @IBAction func onButtonTap() {
        _log(message: "Buttont tap")
        
        let msg = textField?.text ?? ""
        let jsCode = "document.getElementById('fromNativeAppText').innerHTML = (+new Date()) + ' from app: [" + msg + "]'"
        self.webView.evaluateJavaScript(jsCode, completionHandler: nil)
    }
    
    @IBAction func onButtonReload() {
        _log(message: "Reloading")
        self.webView.reload()
    }
    
    func _log(message: String) {
        self.webView.evaluateJavaScript("debug('NATIVELOG: " + message + "')", completionHandler: nil)
        print(message)
    }


    func share (title: String?, text: String?, url: String?) {
        _log(message: "Sharing")
        
        let textToShare = [ text ]
        let ac = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
        present(ac, animated: true, completion: goToPostShare)
    }
    
    func goToPostShare() {
        let message = "debug('triggered func goToPostShare()')";
        self.webView.evaluateJavaScript(message, completionHandler: nil)

        _log(message: message);
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive json: WKScriptMessage) {
        if json.name == "jsOnShare" {
            self.jsOnShare(json: json)
        } else if json.name == "jsOnBackPressed" {
            self.jsOnBackPressed(json: json)
        } else if json.name == "jsHandler" {
            self.jsHandler(json: json);
        } else if json.name == "jsLog" {
            self.jsLog(json: json);
        }
    }
    
    func jsOnShare(json: WKScriptMessage) {
        struct Share : Decodable {
            let title: String?
            let text: String?
            let url: String?
        }
        
        let oMessage = json.body as? String ?? ""
        let data = oMessage.data(using: .utf8)!
        let oShare: Share = try! JSONDecoder().decode(Share.self, from: data)
        
        self.share(title: oShare.title, text: oShare.text, url: oShare.url)

        print("called jsOnShare()")
    }
    
    func jsOnBackPressed(json: WKScriptMessage) {
        print("called jsOnBackPressed()")
    }
    
    func jsHandler(json: WKScriptMessage) {
        let oMessage = json.body as? String ?? ""
        let data = oMessage.data(using: .utf8)!
        let oLogMessage: LogMessage = try! JSONDecoder().decode(LogMessage.self, from: data);

        self.textLabel?.text = oLogMessage.message

        print("called jsHandler()")
    }

    func jsLog(json: WKScriptMessage) {
        let oMessage = json.body as? String ?? ""
        let data = oMessage.data(using: .utf8)!
        let oLogMessage: LogMessage = try! JSONDecoder().decode(LogMessage.self, from: data);
        
        print("called jsLog(): " + (oLogMessage.message ?? ""))
    }
}

