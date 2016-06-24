//
//  PostTableViewCell.swift
//  Makestagram
//
//  Created by Luca Hagel on 6/23/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Bond
import Parse

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesIconImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    @IBAction func moreButtonTapped(sender: UIButton) {
    }
    @IBAction func likeButtonTapped(sender: UIButton) {
        post?.toggleLikePost(PFUser.currentUser()!, post: post!)
    }
    
    var postDisposable: DisposableType?
    var likeDisposable: DisposableType?
    
    
    var post: Post? {
        didSet {
            postDisposable?.dispose()
            likeDisposable?.dispose()
            
            if let post = post {
                postDisposable = post.image.bindTo(postImageView.bnd_image)
                likeDisposable = post.likes.observe { (value: [PFUser]?) -> () in
                    if let value = value {
                        self.likesLabel.text = self.stringFromUserList(value)
                        self.likeButton.selected = value.contains(PFUser.currentUser()!)
                        self.likesIconImageView.hidden = (value.count == 0)
                    } else {
                        self.likesLabel.text = ""
                        self.likeButton.selected = false
                        self.likesIconImageView.hidden = true

                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func stringFromUserList(userList: [PFUser]) -> String {
        let userNameList = userList.map { user in user.username! }
        let commaSeperatedList = userNameList.joinWithSeparator(", ")
        return commaSeperatedList
    }

}
