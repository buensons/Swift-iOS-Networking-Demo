//
//  DetailedViewController.swift
//  To-Do App
//
//  Created by Damian Roszczyk on 22/04/2019.
//  Copyright © 2019 Damian Roszczyk. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var table: UITableView!
    
    var user : GitHubUser? 
    var cell : MovieTableViewCell?
    var repos : [Repository] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = user?.login
        setUI()
        table.dataSource = self
        table.delegate = self
    }
    
    func setUI() {
        movieTitle.text = cell?.movieTitle.text
        movieImage.image = cell?.movieIMage.image
        if let user = user {
            URLSession.shared.dataTask(with: URL(string: user.repos_url)!) { dat, resp, err in
                guard let dat = dat else {return}
                do {
                    self.repos = try JSONDecoder().decode([Repository].self, from: dat)
                    self.user?.repos = self.repos
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                } catch let jsonError {
                    print(jsonError)
                }
            }.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let repoCell = tableView.dequeueReusableCell(withIdentifier: "RepoCell") as! RepoTableViewCell
        repoCell.repoName.text = user?.repos?[indexPath.row].name
        return repoCell
    }
}
