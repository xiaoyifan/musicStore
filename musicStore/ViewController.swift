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

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var objects:NSArray!
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemCollectionView.delegate =  self
        itemCollectionView.dataSource = self
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
    
    
    
//    @IBAction func loadData(sender: UIButton) {
//        
//        var appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        var context:NSManagedObjectContext = appDel.managedObjectContext!
//        
//        DataManager.sharedInstance.loadData(context)
//        
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! UICollectionViewCell
        var image : UIImage = UIImage(named:"sad")!
        let bgImage = UIImageView(image: image)
        bgImage.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        cell.addSubview(bgImage)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let side = (self.view!.frame.width - 80)/2.0
        
        return CGSizeMake(side, side)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 40, 10, 40)
    }


}

