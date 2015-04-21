//
//  ViewController.swift
//  musicStore
//
//  Created by Yifan Xiao on 4/20/15.
//  Copyright (c) 2015 Yifan Xiao. All rights reserved.
//

import UIKit
import musicStoreKit
import CoreData

class ViewController: UIViewController {
    
    var objects:NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        clearData("App", context: context)
        
        var request = NSMutableURLRequest(URL: NSURL(string: "https://itunes.apple.com/search?term=music&country=us&entity=software")!)
        Networking.sharedInstance.get(request){
            (data, error) -> Void in
            if error != nil {
                println(error)
            } else {
                //println(data)
                self.objects = dataParsing.sharedInstance.parse(data)
                
                var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                var context:NSManagedObjectContext = appDel.managedObjectContext!
                
                for user in self.objects as! [appItem]{
                    
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
                    
                    println(newApp)
                    
                }
                
                var err:NSError?
                if !context.save(&err){
                    println(err)
                }
                else{
                    println("saving succeeded")
                }
                
            }
        }
    }
    
    func clearData(entity:String, context: NSManagedObjectContext){
        
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
        
    }
    
    
    @IBAction func loadData(sender: UIButton) {
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "App")
        request.returnsObjectsAsFaults = false;
        
        var errorFet:NSError?
        
        var results:Array = context.executeFetchRequest(request, error: &errorFet)!
        
        println(errorFet)
        
        for res in results {
            println(res)
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
