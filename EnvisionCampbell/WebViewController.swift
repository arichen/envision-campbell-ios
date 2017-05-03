//
//  WebViewController.swift
//  EnvisionCampbell
//
//  Created by Ari Chen on 1/6/16.
//  Copyright © 2016 Ari Chen. All rights reserved.
//

import UIKit
import TUSafariActivity
import WebKit

class WebViewController: UIViewController {
    var webView = WKWebView()
    var progressView = UIProgressView(progressViewStyle: .Bar)
    
    var URL : NSURL?
    var isDocumentView : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add webView
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[top][webView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["webView": webView, "top": self.topLayoutGuide]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["webView": webView]))
        
        // add progressView
        let navBar = self.navigationController?.navigationBar
        navBar!.addSubview(progressView)
        let progressBarHeight : CGFloat = 2.0;
        let navigationBarBounds : CGRect = self.navigationController!.navigationBar.bounds;
        let barFrame : CGRect = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        progressView.frame = barFrame
        progressView.autoresizingMask = [.FlexibleWidth, .FlexibleTopMargin]
        progressView.progressTintColor = UIColor.yellowColor()

//        navBar?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[progressView(2)]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["progressView": progressView]))
//        navBar?.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[progressView]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["progressView": progressView]))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButtonClicked:")
        self.navigationItem.rightBarButtonItem = shareButton
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        // load web request
        self.loadRequest()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.removeFromSuperview()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            
            if progressView.progress == 1 {
                UIView.animateWithDuration(0.1, animations: { 
                    self.progressView.alpha = 0
                })
            }
        }
    }
    
    func shareButtonClicked(sender: AnyObject) {
        // prepare message
        var message = ""
        if (isDocumentView == true && self.title != nil) {
            message += "\"\(self.title!)\", "
        } else {
            message += "Visit AppStore"
        }
        message += (self.URL?.absoluteString)!
        message += ". Shared from Envision Campbell iOS."
        
//        let link = NSURL(string: "http://itunes.com/apps/campbell")
        
        // share activity
        let safari = TUSafariActivity()
        let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: [safari])
        self.navigationController?.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func loadRequest() {
        if (URL != nil) {
            progressView.progress = 0
            progressView.alpha = 1
            
            self.webView.loadRequest(NSURLRequest(URL: URL!))
        }
    }
    
}
