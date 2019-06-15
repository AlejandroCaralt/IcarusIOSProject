//
//  MainViewController.swift
//  Icarus
//
//  Created by MacOS on 11/06/2019.
//  Copyright © 2019 MacOS. All rights reserved.
//

import UIKit
import Mapbox
import MapboxDirections

class MainViewController: UIViewController {
    
    // MARK: Variables
    
    // Container views
    @IBOutlet weak var routesCircle: UIView!
    @IBOutlet weak var kmCircle: UIView!
    @IBOutlet weak var minCircle: UIView!
    
    // Data to charge
    @IBOutlet weak var routesNumber: UILabel!
    @IBOutlet weak var kmNumber: UILabel!
    @IBOutlet weak var minNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        putDashboardStyle()
        
    }
    

    func putDashboardStyle() {
    
        self.routesCircle.layer.cornerRadius = self.routesCircle.bounds.width / 2
        self.routesCircle.layer.borderWidth = 4
        self.routesCircle.layer.borderColor = UIColor.black.withAlphaComponent(0.7).cgColor
        
        self.kmCircle.layer.cornerRadius = self.kmCircle.bounds.width / 2
        self.kmCircle.layer.borderWidth = 5
        self.kmCircle.layer.borderColor =  UIColor.black.withAlphaComponent(0.7).cgColor

        
        self.minCircle.layer.cornerRadius = self.minCircle.bounds.width / 2
        self.minCircle.layer.borderWidth = 4
        self.minCircle.layer.borderColor =  UIColor.black.withAlphaComponent(0.7).cgColor

    }
    
}


class ThemeTableViewCell: UITableViewCell {
    @IBOutlet weak var themeImageView: UIImageView!
    @IBOutlet weak var themeMarkerImageView: UIImageView!
}

class ThemePickerViewController: UITableViewController {
    
    @IBOutlet weak var themeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theme = MBXTheme.themes[1]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "example", for: indexPath) as! ThemeTableViewCell

        
        cell.themeImageView = UIImageView(image: UIImage(named: "LoginBackground"))
        
        cell.themeMarkerImageView.image = theme.defaultMarker
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = ThemeViewController()
//        vc.viewControllerTheme = MBXTheme.themes[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}



