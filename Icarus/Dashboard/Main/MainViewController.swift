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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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



