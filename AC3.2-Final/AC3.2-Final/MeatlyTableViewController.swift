//
//  MeatlyTableViewController.swift
//  AC3.2-Final
//
//  Created by Tom Seymour on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class MeatlyTableViewController: UITableViewController {
    
    var databaseReference: FIRDatabaseReference!
    
    var loggedIn: Bool = false
    
    var meatlyPosts: [MeatlyPost] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.databaseReference = FIRDatabase.database().reference().child("posts")
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        getPosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !loggedIn {
            loggedIn = true
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyBoard.instantiateViewController(withIdentifier: "loginViewController")
            self.present(loginVC, animated: false, completion: nil)
        }
    }
    
    
    func getPosts() {
        databaseReference.observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            var gottenPosts: [MeatlyPost] = []
            for child in snapshot.children {
                if let snap = child as? FIRDataSnapshot, let valueDict = snap.value as? [String: AnyObject] {
                    if let comment = valueDict["comment"] as? String, let userID = valueDict["userId"] as? String {
                        let post = MeatlyPost(postID: snap.key, comment: comment, userID: userID)
                        gottenPosts.append(post)
                    }
                }
            }
            // chronological order
            self.meatlyPosts = gottenPosts.reversed()
            self.tableView.reloadData()
        })
    }
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meatlyPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meatlyPostCell", for: indexPath) as! MeatlyTableViewCell
        let post = meatlyPosts[indexPath.row]
        
        cell.meatlyImageView.image = nil
        cell.meatlyCommentLabel.text = post.comment
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.hidesWhenStopped = true
        
        let storage = FIRStorage.storage()
        
        // Create a storage reference from our storage service
        let storageRef = storage.reference()//forURL: "gs://barebonesfirebase-6883d.appspot.com/")
        let spaceRef = storageRef.child("images/\(post.postID)")
        spaceRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                cell.meatlyImageView.image = image
                cell.activityIndicator.stopAnimating()
            }
        }
        return cell
    }
}
