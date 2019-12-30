//
//  HomeController.swift
//  mobile-social
//
//  Created by Yi Zheng on 2019-11-06.
//  Copyright © 2019 Yi Zheng. All rights reserved.
//

import LBTATools
import WebKit
import Alamofire
import SDWebImage//in the pod file

class HomeController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //if you want to run app on your actual device
    //use ip address on your computer
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showCookies()
        
        navigationItem.rightBarButtonItems = [
            .init(title: "Fetch posts", style: .plain, target: self, action: #selector(fetchPosts)),
            .init(title: "Create post", style: .plain, target: self, action: #selector(createPost))
            
        ]
        
        navigationItem.leftBarButtonItem = .init(title: "Log In", style: .plain, target: self, action: #selector(handleLogin))
    }
    
    fileprivate func showCookies() {
        HTTPCookieStorage.shared.cookies?.forEach({ (cookie) in
            print(cookie)
        })
    }
    
    @objc fileprivate func createPost() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        dismiss(animated: true) {
            let url = "http://localhost:1337/post"
            Alamofire.upload(multipartFormData: { (formData) in
                // post text
                formData.append(Data("temp text".utf8), withName: "postBody")
                //post image
                guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
                // withName matchs the name in Sails.js controller
                formData.append(imageData, withName: "imagefile", fileName: "DoesntMatter", mimeType: "image/jpg")
            }, to: url) { (res) in
                
                switch res {
                case .failure(let err):
                    print("Failed to hit server: ", err)
                case .success(let uploadRequest, _, _):
                    uploadRequest.uploadProgress { (progress) in
                        print("Upload progress: \(progress.fractionCompleted)")
                    }
                    uploadRequest.responseJSON { (dataResp) in
                        if let err = dataResp.error {
                            print("Faile to hit server: ", err)
                            return
                        }
                        
                        if let code = dataResp.response?.statusCode, code >= 300 {
                            print("Faile upload with status: ", code)
                            return
                        }
                        
                        let respString = String(data: dataResp.data ?? Data(), encoding: .utf8)
                        print("Successfully created post, here is the response: ")
                        print(respString ?? "")
                        
                        self.fetchPosts()
                    }
                }
                print("finished uploading")
            }
        }
    }
    
    @objc fileprivate func handleLogin() {
        let loginController = LoginController()
        let navLoginController = UINavigationController(rootViewController: loginController)
        present(navLoginController, animated: true, completion: nil)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func fetchPosts() {
        let url = "http://localhost:1337/post"
        Alamofire.request(url)
            .validate(statusCode: 200..<300)
            .responseData { (dataResp) in
                if let err = dataResp.error {
                    print("Failed to fetch post: ", err)
                    return
                }
                
                guard let data = dataResp.data else {return}
                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    self.posts = posts
                    self.tableView.reloadData()
                }catch {
                    print(error)
                }
        }
        
//        guard let url = URL(string: "http://localhost:1337/post") else {return}
////        guard let url = URL(string: "https://www.atb.com") else {return}
//        URLSession.shared.dataTask(with: url) { (data, resp, err) in
//            DispatchQueue.main.async {
//                if let err = err {
//                    print("Failed to hit server:", err)
//                    return
//                } else if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
//                    print("Failed to fetch posts")
//                    return
//                } else {
//                    let html = String(data: data ?? Data(), encoding: .utf8) ?? ""
//                    let vc = UIViewController()
//                    let webView = WKWebView()
//                    webView.loadHTMLString(html, baseURL: nil)
//                    vc.view.addSubview(webView)
//                    webView.fillSuperview()
//                    self.present(vc, animated: true)
//                }
//            }
//        }.resume()
        
    }
    
    var posts = [Post]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.user.fullName
        cell.textLabel?.font = .boldSystemFont(ofSize: 14)
        cell.detailTextLabel?.text = post.text
        cell.detailTextLabel?.numberOfLines = 0
        cell.imageView?.sd_setImage(with: URL(string: post.imageUrl))
        return cell
    }
}
