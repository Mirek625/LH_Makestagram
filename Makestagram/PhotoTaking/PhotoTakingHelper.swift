//
//  PhotoTakingHelper.swift
//  Makestagram
//
//  Created by Luca Hagel on 6/22/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

typealias PhotoTakingHelperCallback = UIImage? -> Void

class PhotoTakingHelper: NSObject {
    weak var viewController: UIViewController!
    var callBack: PhotoTakingHelperCallback
    var imagePickerController: UIImagePickerController?
    
    init(viewController: UIViewController, callback: PhotoTakingHelperCallback) {
        self.viewController = viewController
        self.callBack = callback
        
        super.init()
        
        showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection() {
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your Photos from?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default) { (action) in
            self.showImagePickerController(.PhotoLibrary)
        }
        alertController.addAction(photoLibraryAction)
        
        if UIImagePickerController.isCameraDeviceAvailable(.Rear) {
            let cameraAction = UIAlertAction(title: "Take a Photo", style: .Default) { (action) in
                self.showImagePickerController(.Camera)
            }
            alertController.addAction(cameraAction)
        }
        
        viewController.presentViewControllerFromTopViewController(alertController, animated: true, completion: nil)
        
    }
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
}

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        viewController.dismissViewControllerAnimated(false, completion: nil)
        callBack(image)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
