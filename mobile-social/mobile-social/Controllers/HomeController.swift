//
//  HomeController.swift
//  mobile-social
//
//  Created by Yi Zheng on 2019-11-06.
//  Copyright © 2019 Yi Zheng. All rights reserved.
//

import LBTATools
import WebKit

class HomeController: UITableViewController {
    //if you want to run app on your actual device
    //use ip address on your computer
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showCookies()
        
        navigationItem.rightBarButtonItem = .init(title: "Fetch posts", style: .plain, target: self, action: #selector(fetchPosts))
        
        navigationItem.leftBarButtonItem = .init(title: "Log In", style: .plain, target: self, action: #selector(handleLogin))
    }
    
    fileprivate func showCookies() {
        HTTPCookieStorage.shared.cookies?.forEach({ (cookie) in
            print(cookie)
        })
    }
    
    @objc fileprivate func handleLogin() {
        let loginController = LoginController()
        let navLoginController = UINavigationController(rootViewController: loginController)
        present(navLoginController, animated: true, completion: nil)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func fetchPosts() {
        guard let url = URL(string: "http://localhost:1337/post") else {return}
//        guard let url = URL(string: "https://www.atb.com") else {return}
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to hit server:", err)
                    return
                } else if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
                    print("Failed to fetch posts")
                    return
                } else {
                    let html = String(data: data ?? Data(), encoding: .utf8) ?? ""
                    let vc = UIViewController()
                    let webView = WKWebView()
                    webView.loadHTMLString(html, baseURL: nil)
                    vc.view.addSubview(webView)
                    webView.fillSuperview()
                    self.present(vc, animated: true)
                }
            }
        }.resume()
        
    }
}
