//
//  PrivacyViewController.swift
//  AvacyCMPTest
//

import UIKit
import WebKit

class PrivacyViewController: UIViewController, WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler {

    var avacy:AvacyCMP?
    var listener: OnCMPReady?
    
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
            let callback = body["callback"] as? String ?? ""
            if callback != ""{
                let js = "\(callback)('\(read ?? "")')"
                avacy?.evaluateJavascritp(javascript: js)
            }
            avacy?.showAlertResponse(message: message)
            //todo evaluateJavascript
        case "write":
            let key = body["key"] as? String ?? ""
            let bodyValue = body["value"] as? String ?? ""
            let value = String(describing: bodyValue)
            let message = "Comando ricevuto: \(command) Chiave: \(key) Valore: \(value)"
            let write = avacy?.write(key: key, value: value)
            let callback = body["callback"] as? String ?? ""
            if callback != ""{
                let js = "\(callback)('\(write ?? "")')"
                avacy?.evaluateJavascritp(javascript: js)
            }
            print("write \(message)")
            avacy?.showAlertResponse(message: message)
        case "show":
            let message = "Comando ricevuto: \(command)"
            avacy?.showAlert()
            avacy?.showAlertResponse(message: message)
        case "destroy":
            let message = "Comando ricevuto: \(command)"
            avacy?.showAlertResponse(message: message)
            avacy?.dismiss()
            return
        case "readAll":
            let callback = body["callback"] as? String ?? ""
            let message = "Comando ricevuto: \(command)"
            let read = avacy?.readAll()
            //print("read \(read)")
            if callback != ""{
                let js = "\(callback)('\(read ?? "")')"
                avacy?.evaluateJavascritp(javascript: js)
            }
            avacy?.showAlertResponse(message: message)
        case "writeAll":
            let key = body["key"] as? String ?? ""
//          let value = "\(body["value"] ?? "")"
            let bodyValue = body["values"] as? String ?? ""
            let value = String(describing: bodyValue)
            let message = "Comando ricevuto: \(command) Chiave: \(key) Valore: \(value)"
            let write = avacy?.writeAll(values: value)
            let callback = body["callback"] as? String ?? ""
            if callback != ""{
                let js = "\(callback)('\(write ?? "")')"
                avacy?.evaluateJavascritp(javascript: js)
            }
            print("write \(message)")
            avacy?.showAlertResponse(message: message)
        default:
            print("Unrecognized command")
            //
        }
        
      }
      
      func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if((listener) != nil){
            listener?.onSuccess()
        }
      }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if((listener) != nil){
            listener?.onError(error: error.localizedDescription)
        }
    }
   
}

