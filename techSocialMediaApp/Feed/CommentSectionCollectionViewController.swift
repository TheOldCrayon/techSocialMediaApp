//
//  CommentSectionCollectionViewController.swift
//  techSocialMediaApp
//
//  Created by Marek Neumarker on 2/21/24.


private let reuseIdentifier = "commentCell"
private let sectionIdentifier = "mainSection"

import UIKit

class CommentSectionCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
        
    
    //posts and configuration variables
    var postid: Int?
    var currentUser: Bool?
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    private var comments: [Comment] = []
        private var dataSource: UICollectionViewDiffableDataSource<String, Comment>!
        
        override func viewDidLoad() {
            if let currentUser = currentUser {
                if !currentUser {
                    editButton.isEnabled = false
                    deleteButton.isEnabled = false
                }
            }
            
            super.viewDidLoad()
            //data
            configureDataSource()
            //fetch request
            fetchComments()
        }
    
    //layout shenanigans
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let cellWidth = collectionView.bounds.width - 20
            let height = CGFloat(150)
            return CGSize(width: cellWidth, height: height)
        }


        // api call
        func fetchComments() {
            if let userSecret = User.current?.secret, let postid = postid {
                let queryParams = ["userSecret": "\(userSecret)", "postid": "\(postid)"]
                let url = API.commentURL!
                
                URLSession.shared.request(url: url, method: .get, body: nil, queryParams: queryParams) { [weak self] result in
                    switch result {
                    case .success(let data):
                        do {
                            // Decode response
                            let comments = try JSONDecoder().decode([Comment].self, from: data)
                            
                            DispatchQueue.main.async {
                                // Update UI on main thread
                                self?.comments = comments
                                self?.applySnapshot()
                                self?.collectionView.reloadData()
                            }
                        } catch {
                            print("Error decoding response data: \(error)")
                        }
                    case .failure(let error):
                        print("Error fetching posts: \(error)")
                    }
                }
            } else {
                print("User secret is nil or post id is nil")
            }
        }

        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return comments.count
        }
        
        // diffable data source configuration:
        
        private func applySnapshot() {
            var snapshot = NSDiffableDataSourceSnapshot<String, Comment>()
            snapshot.appendSections([sectionIdentifier])
            snapshot.appendItems(comments)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
        func configureDataSource() {
            dataSource = UICollectionViewDiffableDataSource<String, Comment>(collectionView: collectionView) { collectionView, indexPath, post in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCollectionViewCell
                
                cell.commentUsernameLabel.text = self.comments[indexPath.row].userName
                cell.commentBodyLabel.text = self.comments[indexPath.row].body
                cell.commentDateLabel.text  = self.comments[indexPath.row].createdDate
                
                return cell
            }
        }
    @IBAction func unwindEdit(segue: UIStoryboardSegue) {
    }
    
    func deleteRequest() {
        guard let url = API.deleteURL else { return }
        
        if let userSecret = User.current?.secret {
            if let postid = postid {
                let queryParams: [String: String] = [
                    "userSecret": "\(userSecret)",
                    "postid": "\(postid)"
                ]
                
                URLSession.shared.request(url: url, method: .post, body: nil, queryParams: queryParams) { result in
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
                print("postid don't wurk")
            }
        } else {
            print("current don't wurk")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postToComments" {
            let destination = segue.destination as? CreateCommentTableViewController
            
            destination?.postid = postid
        } else if segue.identifier == "editPost" {
            let destination = segue.destination as? PostingAndEditingTableViewController
            
            destination?.postid = postid
        } else if segue.identifier == "deleteUnwind" {
            deleteRequest()
        }
    }
        
}
