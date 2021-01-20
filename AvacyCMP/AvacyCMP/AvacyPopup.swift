//
//  AvacyPopup.swift
//  AvacyCMPTest
//
//  Created by Luciano Ollio on 19/01/2021.
//

import Foundation
import UIKit
import WebKit

class AvacyPopup {
    
    struct Constants {
        static let backgroundAlphaTo: CGFloat = 0.6
    }
    
    private let backgroundView:UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    private let alertView:UIView = {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.masksToBounds = true
        alert.layer.cornerRadius = 12
        return alert
    }()
    
    private var webView:WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    private var myTargetView: UIView?
    var parentViewController:UIViewController?
    
    func tryToLoadWebView(on viewController: UIViewController){
        let url = URL(string: "https://avacy-banner-d24ozpfr4.vercel.app/demos/rai-b.html")
        //let url = URL(string: "https://posytron.com/avacy.html")
        let request = URLRequest(url: url!)
        let privacyVC = PrivacyViewController()
        let contentController = WKUserContentController()
        privacyVC.avacy = self
        contentController.add(privacyVC, name: "CMPWebInterface")
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        webView = WKWebView(frame: .zero, configuration: config)
        webView.layer.masksToBounds = true
        
        webView.load(request)
        parentViewController = viewController
    }
    
    func showAlert(){
        guard let targetView = parentViewController?.view else {
            return
        }
        myTargetView = targetView
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        alertView.frame = CGRect(x: 40, y: -300, width: targetView.frame.size.width-60, height: targetView.frame.size.height-200)
        let button = UIButton(frame: CGRect(x: 0, y: alertView.frame.size.height-50, width: alertView.frame.size.width, height: 50))
        alertView.addSubview(button)
        
        self.alertView.center = targetView.center
//        button.setTitle("Dismiss", for: .normal)
//        button.setTitleColor(.link, for: .normal)
//        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
//        alertView.addSubview(button)
        webView.frame = CGRect(x: 0, y: 0, width: alertView.frame.size.width, height: alertView.frame.size.height)
        alertView.addSubview(webView)
        
        UIView.animate(withDuration: 0.25,animations:  {
            self.backgroundView.alpha = Constants.backgroundAlphaTo
        }) { done in
            if done {
                self.alertView.center = targetView.center
            }
        }
    }
    
    @objc func dismiss(){
        guard let targetView = myTargetView else {
            return
        }
        UIView.animate(withDuration: 0.25,animations:  {
            self.alertView.frame = CGRect(x: 40, y: -300, width: targetView.frame.size.width-80, height: 350)
        }) { done in
            if done {
                self.backgroundView.alpha = 0
                self.alertView.removeFromSuperview()
                self.backgroundView.removeFromSuperview()
            }
        }
    }
    func read(key: String) -> String{
        let preferences = UserDefaults.standard
        if preferences.string(forKey: key) != nil {
            return preferences.string(forKey: key)!
        }
        return "";
    }
    func write(key:String,value:String) -> String{
        let preferences = UserDefaults.standard
        preferences.setValue(value, forKeyPath: key)
        //  Save to disk
        let didSave = preferences.synchronize()
        if !didSave {
            return ""
        }
        return preferences.string(forKey: key) ?? ""
    }
    func showAlertResponse(message: String) {
        let alertController = UIAlertController(title: "Avacy", message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alertController.addAction(alertAction)
        parentViewController?.present(alertController, animated: true,completion: nil)
    }
}
