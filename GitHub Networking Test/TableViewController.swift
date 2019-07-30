//
//  TableViewController.swift
//  To-Do App
//
//  Created by Damian Roszczyk on 22/04/2019.
//  Copyright © 2019 Damian Roszczyk. All rights reserved.
//

import UIKit
import Foundation

class TableViewController: UITableViewController {

    var users : [GitHubUser] = []
    let imageCache = NSCache<AnyObject, UIImage>()
    let spinner = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.black
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationItem.title = "Github Users"
        fetchUsers()
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        self.tableView.backgroundView = spinner
    }
    
    func fetchUsers() -> Void {
        let requestURL = URL(string: "https://api.github.com/users")
        URLSession.shared.dataTask(with: requestURL!) { (data, response, error) in
            
            guard let data = data else { return }
            do {
                self.users = try JSONDecoder().decode([GitHubUser].self, from: data)
            } catch let jsonErr {
                print(jsonErr)
            }
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segue") {
            let destination = segue.destination as! DetailedViewController
            let tuple = sender as? (MovieTableViewCell, GitHubUser)
            destination.user = tuple?.1
            destination.cell = tuple?.0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell
        
        if let img = imageCache.object(forKey: user.avatar_url as AnyObject) {
            cell.movieIMage.image = img
        } else {
            if let url = URL(string: user.avatar_url) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.movieIMage.image = UIImage(data: data)
                            self.imageCache.setObject(cell.movieIMage.image!, forKey: user.avatar_url as AnyObject)
                        }
                    }
                }.resume()
            }
        }
        cell.movieTitle.text = user.login
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let cell : MovieTableViewCell = tableView.cellForRow(at: indexPath) as! MovieTableViewCell
        performSegue(withIdentifier: "segue", sender: (cell, user))
    }
}
