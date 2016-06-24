//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Luca Hagel on 6/22/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var timelineTableView: UITableView!
    var photoTakingHelper: PhotoTakingHelper?
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        ParseHelper.timeLineRequestForCurrentUser {
            (result: [PFObject]?, error: NSError?) -> Void in
            
            self.posts = result as? [Post] ?? []
            
            self.timelineTableView.reloadData()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func takePhoto() {
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
            let post = Post()
            post.image.value = image!
            post.uploadPost()
        }
    }
}

extension TimelineViewController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController is PhotoViewController {
            takePhoto()
            return false
        } else {
            return true
        }
    }
}

extension TimelineViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
        let post = posts[indexPath.row]
        
        post.downloadImage()
        cell.post = post
        
        return cell
    }
}