# Avacy CMP

Avacy CMP is the iOS library for the Smart Consent Solution provided by Avacy

## Requirements

* iOS 11.0+
* Xcode 12+
* Swift 5.1+



## CocoaPods


CocoaPods is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate AvacySdk into your Xcode project using CocoaPods, specify it in your Podfile:


```
pod 'AvacyCmpSdk', '1.0.11'
```

Next, run

```
pod update
```


## Initialize the SDK

Import AvacyCmpSdk and add the following to the application:didFinishLaunchingWithOptions: method in your AppDelegate.  
Note: BASE_URL is url of the consents page provided by Avacy.

```
AvacyCMP.configure(url: BASE_URL)
```
## Implement features

**Check for consent**

Add the following for check if consent has already been given to the latest version of the privacy policy, if not, show the consent banner.  
Note: viewController must necessarily be a UIViewController.

Add a property on your ViewController

```
let avacy = AvacyCMP()
```
and call the startCheck method on viewDidLoad
```
avacy.startCheck(on viewController: UIViewController,listener: OnCMPReady?)
```
you can pass a listener that implements OnCMPReady protocol for capture error on loading.



**Show Preference Center**

Add the following for show the Preference Center to edit current consents.  
Note: viewController must necessarily be a UIViewController.

Add a property on your ViewController

```
let avacy = AvacyCMP()
```
and call the showPreferences method on your custom event

```
avacy.showPreferences(on viewController: UIViewController,listener: OnCMPReady?)
```
