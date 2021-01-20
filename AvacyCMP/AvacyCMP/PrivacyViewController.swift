//
//  PrivacyViewController.swift
//  AvacyCMPTest
//
//  Created by Luciano Ollio on 12/01/2021.
//

import UIKit
import WebKit

class PrivacyViewController: UIViewController, WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler {
//    var webView: WKWebView!
//    var url = ""
    var avacy:AvacyPopup?
    
//    @IBOutlet weak var contentView: UIView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//            //let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
//            //view.addConstraints([ heightConstraint])
//        // Do any additional setup after loading the view.
//    }
    
//    override func loadView() {
//        super.loadView()
//    }

//    @IBAction func closeButtonClicked(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        //self.view.isHidden = true
//        //loadUrl()
//    }
//
//    func loadUrl(){
//        prepareWebView(url: url)
//    }
    
//    func prepareWebView(url: String){
//        let url = URL(string: self.url)!
//        webView.load(URLRequest(url: url))
//    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        //This function handles the events coming from javascript. We'll configure the javascript side of this later.
        //We can access properties through the message body, like this:
        guard let body = message.body as? [String: Any] else { return }
        guard let command = body["command"] as? String else { return }
        print(command)
        switch command {
        case "read":
            guard let key = body["key"] as? String else { return }
            let message = "Comando ricevuto: \(command) Chiave: \(key)"
            let read = avacy?.read(key: key)
            print("read \(read)")
            avacy?.showAlertResponse(message: message)
            //todo evaluateJavascript
        case "write":
            let key = body["key"] as? String ?? ""
            let value = body["value"] as? String ?? ""
            let message = "Comando ricevuto: \(command) Chiave: \(key) Valore: \(value)"
            let write = avacy?.write(key: key, value: value)
            print("write \(write)")
            avacy?.showAlertResponse(message: message)
        case "show":
            let message = "Comando ricevuto: \(command)"
            avacy?.showAlert()
            avacy?.showAlertResponse(message: message)
        case "destroy":
            let message = "Comando ricevuto: \(command)"
            avacy?.showAlertResponse(message: message)
            avacy?.dismiss()
            //avacy.show()
            //showAlert(message: message)
            //self.dismiss(animated: true, completion: nil)
            return
        default:
            print("Unrecognized command")
            //
        }
        
      }
      
      func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //This function is called when the webview finishes navigating to the webpage.
        //We use this to send data to the webview when it's loaded.
      }
   
}
