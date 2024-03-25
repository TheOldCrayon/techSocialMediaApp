//
//  FeedCollectionViewController.swift
//  techSocialMediaApp
//
//  Created by Marek Neumarker on 2/14/24.
//

import UIKit

//identifiers
private let reuseIdentifier = "feedPostCell"
private let sectionIdentifier = "mainSection"

class FeedCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //posts and configuration variables
    private var posts: [Post] = []
    private var dataSource: UICollectionViewDiffableDataSource<String, Post>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //data
        configureDataSource()
        //fetch request
        fetchPosts()
    }
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    //layout shenanigans
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width - 20
        let height = CGFloat(150)
        return CGSize(width: cellWidth, height: height)
    }


    // api call
    func fetchPosts() {
        if let userSecret = User.current?.secret {
            let queryParams = ["userSecret": "\(userSecret)"]
            let url = API.postsURl!
            
            URLSession.shared.request(url: url, method: .get, body: nil, queryParams: queryParams) { [weak self] result in
                switch result {
                case .success(let data):
                    do {
                        // Decode response
                        let posts = try JSONDecoder().decode([Post].self, from: data)
                        
                        DispatchQueue.main.async {
                            // Update UI on main thread
                            self?.posts = posts
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
            print("User secret is nil")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // diffable data source configuration:
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, Post>()
        snapshot.appendSections([sectionIdentifier])
        snapshot.appendItems(posts)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<String, Post>(collectionView: collectionView) { collectionView, indexPath, post in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedPostCollectionViewCell
            cell.postTitleLabel.text = self.posts[indexPath.row].title
            cell.postUsernameLabel.text = self.posts[indexPath.row].authorUserName
            cell.postBodyLabel.text = self.posts[indexPath.row].body
            cell.postDateLabel.text = self.posts[indexPath.row].createdDate
            
            cell.postCommentLabel.text = "\(self.posts[indexPath.row].numComments)"
            cell.postLikesLabel.text = "\(self.posts[indexPath.row].likes)"
            
            return cell
        }
    }
    @IBAction func unwindFromCommentSection(segue: UIStoryboardSegue) {
        guard segue.identifier == "commentUnwind", let sourceViewController = segue.source as? CommentSectionCollectionViewController else { return }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "postToComments" else {return}
        if let cell = sender as? FeedPostCollectionViewCell, let indexpath = collectionView.indexPath(for: cell) {
            let destination = segue.destination as? CommentSectionCollectionViewController
            destination?.postid = posts[indexpath.row].postid
            destination?.currentUser = posts[indexpath.row].authorUserName == User.current?.userName
        }
    }
}
