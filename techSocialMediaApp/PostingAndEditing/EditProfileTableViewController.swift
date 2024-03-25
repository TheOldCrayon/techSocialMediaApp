//
//  EditProfileTableViewController.swift
//  techSocialMediaApp
//
//  Created by Marek Neumarker on 2/21/24.
//

import UIKit

class EditProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var usernameEditLabel: UITextField!
    @IBOutlet weak var bioEditLabel: UITextField!
    @IBOutlet weak var techEditLabel: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func updateSaveButton() {
        let userText = usernameEditLabel.text ?? ""
        let bioText = bioEditLabel.text ?? ""
        let techText = techEditLabel.text ?? ""
        saveButton.isEnabled = !userText.isEmpty && !bioText.isEmpty && !techText.isEmpty
    }
    
    @IBAction func editingHappened(_ sender: Any) {
        updateSaveButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        let username = usernameEditLabel.text ?? ""
        let bio = bioEditLabel.text ?? ""
        let techInterests = techEditLabel.text ?? ""
        
        updateProfileRequest(username: username, bio: bio, techInterests: techInterests)
    }
    
    func updateProfileRequest(username: String, bio: String, techInterests: String) {
        guard let url = API.updateProfileURL else { return }
        
        if let userSecret = User.current?.secret {
            let bodyParams: [String: String] = [
                "userName": username,
                "bio": bio,
                "techInterests": techInterests
            ]
            let requestBody: [String: Any] = [
                "userSecret": "\(userSecret)",
                "profile": bodyParams
            ]
            
            URLSession.shared.request(url: url, method: .post, body: requestBody, queryParams: nil) { result in
                switch result {
                case .success(let data):
                    // Handle success
                    print("Success: \(data)")
                case .failure(let error):
                    // Handle failure
                    print("Error: \(error)")
                }
            }
        } else {
            print("User secret is nil")
        }
    }
}
