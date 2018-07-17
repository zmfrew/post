//
//  PostListTableViewController.swift
//  Post
//
//  Created by Zachary Frew on 7/16/18.
//  Copyright © 2018 Zachary Frew. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        postController.fetchPosts {
            self.reloadTableView()
        }
    }
    
    // MARK: - Actions
    @IBAction func refreshControlActivated(_ sender: UIRefreshControl) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts {
            self.reloadTableView()
            DispatchQueue.main.async {
                sender.endRefreshing()
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        presentNewPostAlert()
    }
    
    // MARK: - Properties
    let postController = PostController()
    
    // MARK: - Methods
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    func presentNewPostAlert() {
        let alertController = UIAlertController(title: "New Post", message: nil, preferredStyle: .alert)
        
        var usernameTextField: UITextField?
        var messageTextField: UITextField?
        
        alertController.addTextField { (usernameField) in
            usernameField.placeholder = "Username"
            usernameTextField = usernameField
        }
        
        alertController.addTextField { (messageField) in
            messageField.placeholder = "What's on your mind?"
            messageTextField = messageField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let username = usernameTextField?.text, !username.isEmpty, username != " ", let text = messageTextField?.text, !text.isEmpty, text != " " else {
                self.presentErrorAlert()
                return
            }
            
            self.postController.addNewPostWith(username: username, text: text, completion: {
                self.reloadTableView()
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func presentErrorAlert() {
        let alertController = UIAlertController(title: "Oops!", message: "Check to make sure you entered all info.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = postController.posts[indexPath.row]
        let date = Date(timeIntervalSince1970: post.timestamp)
        
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "User: \(post.username) \n \(date.stringValue())"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= postController.posts.count - 1 {
            postController.fetchPosts(reset: false, completion: {
                self.reloadTableView()
            })
        }
    }

}
