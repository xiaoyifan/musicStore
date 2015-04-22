//
//  DataManager.swift
//  musicStore
//
//  Created by Yifan Xiao on 4/21/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

import UIKit
import CoreData
import Parse

public class DataManager {
    
    public static let sharedInstance = DataManager()
    
    public init(){
        println("initializing data manager")
    }
    
    
    public func saveDataToCloud(objects:NSArray, context:NSManagedObjectContext){
        
        for user in objects as! [appItem]{
            
            var newApp: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("App", inManagedObjectContext: context)
            
            newApp.setValue(user.screenshotUrls, forKey: "screenshotUrls")
            newApp.setValue(user.artworkUrl60, forKey: "artworkUrl60")
            newApp.setValue(user.ipadScreenshotUrls, forKey: "ipadScreenshotUrls")
            newApp.setValue(user.features, forKey: "features")
            newApp.setValue(user.supportedDevices, forKey: "supportedDevices")
            newApp.setValue(user.trackCensoredName, forKey: "trackCensoredName")
            newApp.setValue(user.languageCodesISO2A, forKey: "languageCodesISO2A")
            newApp.setValue(user.contentAdvisoryRating, forKey: "contentAdvisoryRating")
            newApp.setValue(user.trackViewUrl, forKey: "trackViewUrl")
            newApp.setValue(user.currency, forKey: "currency")
            newApp.setValue(user.price, forKey: "price")
            newApp.setValue(user.version, forKey: "version")
            newApp.setValue(user.objDescription, forKey: "objDescription")
            newApp.setValue(user.minimumOsVersion, forKey: "minimumOsVersion")
            
            var err:NSError?
            if !context.save(&err){
                println(err)
            }
            else{
                println("saving succeeded")
            }
            
            var musicApp = PFObject(className:"musicStore")
            musicApp["screenshotUrls"] = user.screenshotUrls
            musicApp["artworkUrl60"] = user.artworkUrl60
            musicApp["ipadScreenshotUrls"] = user.ipadScreenshotUrls
            musicApp["features"] = user.features
            musicApp["supportedDevices"] = user.supportedDevices
            musicApp["trackCensoredName"] = user.trackCensoredName
            musicApp["languageCodesISO2A"] = user.languageCodesISO2A
            musicApp["contentAdvisoryRating"] = user.contentAdvisoryRating
            musicApp["trackViewUrl"] = user.trackViewUrl
            musicApp["currency"] = user.currency
            musicApp["price"] = user.price
            musicApp["version"] = user.version
            musicApp["objDescription"] = user.objDescription
            musicApp["minimumOsVersion"] = user.minimumOsVersion
            musicApp.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (!success) {
                    println(error?.description)
                }
            }
            //save the object
            
        }

        
    }
    
    public func clearData(entity:String, context: NSManagedObjectContext){
        
        var request = NSFetchRequest(entityName: entity)
        request.returnsObjectsAsFaults = false;
        
        request.includesPropertyValues = false
        
        var results:[NSManagedObject] = context.executeFetchRequest(request, error: nil) as! Array
        
        for res in results{
            context.deleteObject(res)
        }
        var err:NSError?
        if !context.save(&err){
            println(err)
        }
        else{
            println("clear succeeded")
        }
        
        
        let query = PFQuery(className: "musicStore")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error:NSError?) -> Void in
            
            for object in objects as! [PFObject] {
                object.delete(nil)
            }
        }
        
    }
    
    
    public func loadData(context: NSManagedObjectContext){
        
        var request = NSFetchRequest(entityName: "App")
        request.returnsObjectsAsFaults = false;
        
        var errorFet:NSError?
        
        var results:Array = context.executeFetchRequest(request, error: &errorFet)!
        
        println(errorFet)
        
        for res in results {
            println(res)
        }
    }
   
}
