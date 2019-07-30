//
//  UserViewController.swift
//  To-Do App
//
//  Created by Damian Roszczyk on 28/04/2019.
//  Copyright © 2019 Damian Roszczyk. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    
    let spinner = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    
        if let text = textField.text {
            fetchUser(username: text)
            spinner.startAnimating()
        } else {
            self.userNotFound()
        }
        return true
    }
    
    func fetchUser(username : String) -> Void {
        let url = "https://api.github.com/users/" + username
        if let requestUrl = URL(string: url) {
            URLSession.shared.dataTask(with: requestUrl) { (data, response, error) in
                do {
                    if let data = data {
                        let user = try JSONDecoder().decode(GitHubUser.self, from: data)
                        
                        DispatchQueue.main.async {
                            self.spinner.stopAnimating()
                            do {
                                if let url = URL(string: user.avatar_url) {
                                    let imgData = try Data(contentsOf: url)
                                    self.userImage.image = UIImage(data: imgData)
                                    self.userName.text = user.login
                                } else {
                                    self.userNotFound()
                                }
                            } catch let error {
                                print(error)
                                self.userNotFound()
                            }
                        }
                    }
                } catch let error {
                    print(error)
                    self.userNotFound()
                }
            }.resume()
        }
    }
    
    func userNotFound() -> Void {
        DispatchQueue.main.async {
            self.userName.text = "User not found"
            self.userImage.image = UIImage(imageLiteralResourceName: "error")
        }
    }
}
