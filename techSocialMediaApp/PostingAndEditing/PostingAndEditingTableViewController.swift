//
//  PostingAndEditingTableViewController.swift
//  techSocialMediaApp
//
//  Created by Marek Neumarker on 2/21/24.
//

import UIKit

class PostingAndEditingTableViewController: UITableViewController {
    
    var post: Post?
    var postid: Int?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    
    @IBOutlet weak var createSaveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = post {
            titleTextField.text = post.title
            bodyTextField.text = post.body
            title = "Edit Post"
        } else {
            title = "Create Post"
        }
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        updateSavebutton()
    }
    //make sure the save button doesn't allow blank messages
    func updateSavebutton() {
        let titleText = titleTextField.text ?? ""
        let bodyText = bodyTextField.text ?? ""
        
        createSaveButton.isEnabled = !titleText.isEmpty && !bodyText.isEmpty
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        let titleText = titleTextField.text ?? ""
        let bodyText = bodyTextField.text ?? ""
        if let postid = postid {
            editPostRequest(title: titleText, text: bodyText, postid: postid)
        } else {
            createPostRequest(title: titleText, text: bodyText)
        }
        tabBarController?.selectedIndex = 0
    }
    func createPostRequest(title: String, text: String) {
        guard let url = API.createPostURL else { return }
        
        if let userSecret = User.current?.secret {
            let bodyParams: [String: String] = [
                "title": title,
                "body": text,
            ]
            let requestBody: [String: Any] = [
                "userSecret": "\(userSecret)",
                "post": bodyParams
            ]
            
            URLSession.shared.request(url: url, method: .post, body: requestBody, queryParams: nil) { result in
                switch result {
                case .success(let data):
                    // Handle success
                    print("Success: \(data)")
                case .failure(let error):
                    // Handle failure
                    print("Error: \(error.localizedDescription)")
                }
            }
        } else {
            print("User secret is nil")
        }
    }
    func editPostRequest(title: String, text: String, postid: Int) {
        guard let url = API.editPost else { return }
        if let userSecret = User.current?.secret {
            let bodyParams: [String: String] = [
                "postid": "\(postid)",
                "title": title,
                "body": text,
            ]
            let requestBody: [String: Any] = [
                "userSecret": "\(userSecret)",
                "post": bodyParams
            ]
            
            URLSession.shared.request(url: url, method: .post, body: requestBody, queryParams: nil) { result in
                switch result {
                case .success(let data):
                    // Handle success
                    print("Success: \(data)")
                case .failure(let error):
                    // Handle failure
                    print("Error: \(error.localizedDescription)")
                }
            }
        } else {
            print("User secret is nil")
        }
    }
}
