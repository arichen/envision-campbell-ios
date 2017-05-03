//
//  Config.swift
//  EnvisionCampbell
//
//  Created by Ari Chen on 4/6/16.
//  Copyright © 2016 Ari Chen. All rights reserved.
//

import Foundation
import ContentfulDeliveryAPI

class Config: NSObject {
    let KEY_CONFIG = "CONFIG"
    
    let KEY_DISCUSSION_URL = "DISCUSSION_URL"
    let KEY_WEBSITE_URL = "WEBSITE_URL"
    let KEY_DATE_UPDATED = "DATE_UPDATED"
    
    // singleton
    static let shared = Config()
    
    private let client : CDAClient! = AppDelegate.shared.client
    
    private var _discussionURL : String?
    func discussionURL() -> String? {
        return _discussionURL
    }
    
    private var _websiteURL : String?
    func websiteURL() -> String? {
        return _websiteURL
    }
    
    private var _lastUpdate : NSDate?
    func lastUpdate() -> NSDate? {
        return _lastUpdate
    }
    
    override init() {
        super.init()
        
        if NSUserDefaults.standardUserDefaults().dictionaryForKey(KEY_CONFIG) == nil {
            initConfigs() // init user default
        }
        loadConfigs()
        
        //async get contentful config file
        self.client.fetchEntriesMatching(
            [
                "content_type" : "config",
                "order" : "-sys.updatedAt"
            ],
            success: { (response: CDAResponse, array: CDAArray) -> Void in
                NSLog("EC Config retrieved")
                self.setConfigsWithCDAEntry(array.items.first as? CDAEntry)
            },
            failure: { (response: CDAResponse?, error: NSError) -> Void in
            
            })
    }
    
    func initConfigs() -> Void {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        setConfigsWithDict([
            KEY_DISCUSSION_URL  : "http://EnvisionCampbell.peakdemocracy.com/",
            KEY_WEBSITE_URL     : "http://www.cityofcampbell.com/643/Envision-Campbell/",
            KEY_DATE_UPDATED    : df.dateFromString("2016-04-01")!
        ])
    }
    
    func setConfigsWithCDAEntry(item : CDAEntry?) -> Void {
        if item == nil { return }
        
        let newUpdate = item!.sys["updatedAt"] as! NSDate
        if self.lastUpdate()!.compare(newUpdate) == .OrderedAscending {
            setConfigsWithDict([
                KEY_DISCUSSION_URL  : item!.fields["discussion"] as! String,
                KEY_WEBSITE_URL     : item!.fields["website"] as! String,
                KEY_DATE_UPDATED    : newUpdate
            ])
        }
    }
    
    func setConfigsWithDict(dict : [String:AnyObject]) -> Void {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        userDefaults.setObject(dict, forKey: KEY_CONFIG)
        userDefaults.synchronize()
    }
    
    func loadConfigs() -> Void {
        if let configs = NSUserDefaults.standardUserDefaults().dictionaryForKey(KEY_CONFIG) {
            self._discussionURL = configs[KEY_DISCUSSION_URL] as? String
            self._websiteURL = configs[KEY_WEBSITE_URL] as? String
            self._lastUpdate = configs[KEY_DATE_UPDATED] as? NSDate
        }
    }
}