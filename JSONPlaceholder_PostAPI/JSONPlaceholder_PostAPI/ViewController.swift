//
//  ViewController.swift
//  JSONPlaceholder_PostAPI
//
//  Created by Mac on 10/03/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var postTableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       tableViewDelegateAndDataSource()
        registerXIB()
        fetchingAPI()
    }
    func tableViewDelegateAndDataSource(){
        postTableView.delegate = self
        postTableView.dataSource = self
    }
    func registerXIB(){
        let uiNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        self.postTableView.register(uiNib, forCellReuseIdentifier: "PostTableViewCell")
        
    }
    func fetchingAPI(){
        let urlString = "https://jsonplaceholder.typicode.com/posts"
        let url = URL(string: urlString)
        var
        request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request){ data , response , error in
            print("data")
            print("response")
            print("error")
            
            let getJSONObject = try! JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
            
            for dictionary in getJSONObject{
                let eachDictionary = dictionary as! [String:Any]
                let postid = eachDictionary["id"] as! Int
                let postTitle = eachDictionary["title"] as! String
                let postBody = eachDictionary["body"] as! String
                
                var newposts = Post(id: postid, title: postTitle, body: postBody)
                self.posts.append(newposts)
                
            }
            DispatchQueue.main.async {
                self.postTableView.reloadData()
            }
        }
        dataTask.resume()
    }
}
extension ViewController : UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        200
    }
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.postTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        var eachPost = posts[indexPath.row]
        cell.idlbl.text = "\(eachPost.id)"
        cell.titlelbl.text = eachPost.title
        cell.bodylbl.text = eachPost.body
        
        return cell
    }
}
