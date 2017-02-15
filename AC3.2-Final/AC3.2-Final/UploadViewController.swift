//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by Tom Seymour on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var uploadImageView: UIImageView!
    
    
    var databaseReference: FIRDatabaseReference!
    
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseReference = FIRDatabase.database().reference().child("posts")
        setTextView()
    }
    
    
    func setTextView() {
        commentTextView.delegate = self
        commentTextView.text = "Add a description..."
        commentTextView.textColor = UIColor.lightGray
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.gray.cgColor
    }
    
    //MARK: - TextView Delegate Methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add a description..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    //MARK: - Button Actions

    @IBAction func didTapUploadImage(_ sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        if let postImage = selectedImage,
            let postComment = commentTextView.text,
            let imageData = UIImageJPEGRepresentation(postImage, 0.5) {
            
            let postRef = self.databaseReference.childByAutoId()
            let storageReference: FIRStorageReference = FIRStorage.storage().reference(forURL: "gs://ac-32-final.appspot.com/")
            let spaceRef = storageReference.child("images/\(postRef.key)")
            let metadata = FIRStorageMetadata()
            metadata.cacheControl = "public,max-age=300"
            metadata.contentType = "image/jpeg"
            
            _ = spaceRef.put(imageData, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print("Error putting image to storage")
                }
            })
            
            let post = MeatlyPost(postID: postRef.key, comment: postComment, userID: (FIRAuth.auth()?.currentUser?.uid)!)
            dump(post)
            let postDict = post.asDictionary
            
            postRef.setValue(postDict, withCompletionBlock: { (error, reference) in
                if let error = error {
                    print(error)
                }
                else {
                    print(reference)
                    self.showOKAlert(title: "Success!", message: "Photo Uploaded to Meatly Successfuly", completion: { 
                        //go to feed
                        self.tabBarController?.selectedIndex = 0
                    })
                }
            })
        } else {
            showOKAlert(title: "Whoops!", message: "Please select a photo to upload.")
        }
    }
    
    //MARK: - ImagePickerController Delegate Method
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.uploadImageView.contentMode = .scaleAspectFit
            self.uploadImageView.image = image
            self.selectedImage = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions
    
    func showOKAlert(title: String, message: String?, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel) { (_) in
            if let completionAction = completion {
                completionAction()
            }
        }
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }

    
}
