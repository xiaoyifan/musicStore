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
import Parse

class ViewController: UIViewController {
    
    var objects:NSArray!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        DataManager.sharedInstance.clearData("App", context: context)
        
        
        var request = NSMutableURLRequest(URL: NSURL(string: "https://itunes.apple.com/search?term=music&country=us&entity=software")!)
        Networking.sharedInstance.get(request){
            (data, error) -> Void in
            if error != nil {
                println(error)
            } else {
                
                
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                self.objects = dataParsing.sharedInstance.parse(data)
                
                var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                var context:NSManagedObjectContext = appDel.managedObjectContext!
                
                DataManager.sharedInstance.saveDataToCloud(self.objects, context: context)
                 })
                
                
            }
        }
    }
    
    
    
    @IBAction func loadData(sender: UIButton) {
        
        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context:NSManagedObjectContext = appDel.managedObjectContext!
        
        DataManager.sharedInstance.loadData(context)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

