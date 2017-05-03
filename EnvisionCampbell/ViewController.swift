//
//  ViewController.swift
//  EnvisionCampbell
//
//  Created by Ari Chen on 1/5/16
//  Copyright © 2016 Ari Chen. All rights reserved.
//

import UIKit
import MessageUI
import AirshipKit

class MenuItemCell: UICollectionViewCell {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MFMailComposeViewControllerDelegate {
    
    let menuItems = [
        ["Documents", "icon-documents", "showDocuments"],
        ["Calendar", "icon-events", "showCalendar"],
        ["Discussion", "icon-discussion", "showWebview"],
        ["FAQ", "icon-faq", "showFaq"],
        ["Email", "icon-email", "showContact"],
        ["Website", "icon-website", "showWebview"]
    ]
    
    var margin : CGFloat = 0
    var resizeRatio : CGFloat = 1
    var bannerSize : CGSize = CGSizeZero
    var itemSize : CGSize = CGSizeZero
    var isInitialized = false
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Envision Campbell"
        
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !isInitialized {
            initializeViews()
            isInitialized = true
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
    
    func initializeViews() {
        let baseWidth = (UIDevice.currentDevice().userInterfaceIdiom == .Phone) ? 414 : 500 as CGFloat
        
        let viewSize : CGSize = self.view.bounds.size
        resizeRatio = viewSize.width / baseWidth
        margin = 57 * resizeRatio
        
        // layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20 * resizeRatio
        
        // banner size
        var width : CGFloat = 300 * resizeRatio
        var height : CGFloat = 109 * resizeRatio
        bannerSize = CGSizeMake(width, height)
        
        // item size
        width = 130 * resizeRatio
        height = width
        itemSize = CGSizeMake(width, height)
    }
    
    func openWebView(url : NSURL, title : String) {
        let webVC = self.storyboard?.instantiateViewControllerWithIdentifier("webview") as! WebViewController
        webVC.URL = url
        webVC.title = title
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    func openEmailComposer() {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["AskEnvisionCampbell@cityofcampbell.com"])
        composeVC.setSubject("Feedback for Envision Campbell")
        composeVC.setMessageBody("", isHTML: false)
        
        // Present the view controller modally.
        self.presentViewController(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Dismiss the mail compose view controller.
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (section == 1) ? menuItems.count : 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if (indexPath.section == 0) {
            return collectionView.dequeueReusableCellWithReuseIdentifier("bannerCell", forIndexPath: indexPath)
            
        } else if (indexPath.section == 1) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("itemCell", forIndexPath: indexPath) as! MenuItemCell
            let item = menuItems[indexPath.row] as Array
            cell.iconImage.image = UIImage(named: item[1])
            cell.titleLabel.text = item[0]
            
            return cell
            
        } else {
            return collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath)
        }
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 1) {
            let name : String = menuItems[indexPath.row][0]
            
            UAirship.shared().analytics.addEvent(UACustomEvent(name: name.lowercaseString))
            
            if name == "Email" {
                openEmailComposer()
            } else if name == "Discussion" {
                openWebView(NSURL(string: Config.shared.discussionURL()!)!, title: "Discussion")
            } else if name == "Website" {
                openWebView(NSURL(string: Config.shared.websiteURL()!)!, title: "EnvisionCampbell")
            } else {
                self.performSegueWithIdentifier(menuItems[indexPath.row][2], sender: indexPath)
            }
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if (section == 0) {
            return UIEdgeInsetsMake(36 * resizeRatio, margin * resizeRatio, 10 * resizeRatio, margin * resizeRatio)
            
        } else if (section == 1) {
            return UIEdgeInsetsMake(18 * resizeRatio, (margin + 20) * resizeRatio, 0, (margin + 20) * resizeRatio)
            
        } else {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if (indexPath.section == 0) {
            return bannerSize
        } else if (indexPath.section == 1) {
            return itemSize
        } else {
            return CGSizeMake(self.view.bounds.width, 153 * resizeRatio)
        }
    }
}

