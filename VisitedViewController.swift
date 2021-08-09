//
//  FirstViewController.swift
//  ogawamachi
//
//  Created on 2021/07/23.
//

import UIKit
import SafariServices

class VisitedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var mapButton: UIBarButtonItem!
    var filterButton: UIBarButtonItem!
    
    var visitedData = omiseData.filter { $0.日時 != "-"}
    let backup = omiseData.filter { $0.日時 != "-"}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("omiseData: \(omiseData)")
        self.navigationItem.title = "小川町ランチ"
        
        // フォント種をTime New Roman、サイズを20に指定
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraginoSans-W6", size: 20)!]
        
        mapButton = UIBarButtonItem(title: "マップ", style: .plain, target: self, action: #selector(self.showMap))
        self.navigationItem.setLeftBarButtonItems([mapButton], animated: true)
        
        filterButton = UIBarButtonItem(title: "選択", style: .plain, target: self, action: #selector(self.options))
        self.navigationItem.setRightBarButtonItems([filterButton], animated: true)
        
        visitedData.sort(by: {$0.日時 < $1.日時})
    }
    
    @objc func showMap(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "MapView", bundle: nil)
        let mapViewController = storyboard.instantiateViewController(withIdentifier: "mapView") as! MapViewController
        mapViewController.type = visitedData
        mapViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    @objc func options(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) -> Void in })
        
        //restaurantData = restaurantDataAll
        visitedData = backup
        let action1 = UIAlertAction(title: "全表示", style: .default, handler: { (action: UIAlertAction!) -> Void in
            self.tableView!.reloadData()
        })
        
        //           let action2 = UIAlertAction(title: "カテゴリー", style: .default, handler: { (action: UIAlertAction!) -> Void in
        //               contentsData = contentsData.filter { $0.category.contains("json") }
        //               self.tableView!.reloadData()
        //           })
        //
        let action4 = UIAlertAction(title: "ランダム", style: .default, handler: { (action: UIAlertAction!) -> Void in
            
            if let contents = self.visitedData.randomElement() {
                self.visitedData = [contents]
            } else {
                print("Empty contents.")
            }
            self.tableView!.reloadData()
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(action1)
        //alertController.addAction(action2)
        alertController.addAction(action4)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - セル数
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitedData.count
    }
    
    // MARK: - セル内容
    @objc func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listViewCell") as? ListViewCell
        let data = visitedData[indexPath.row]
        
        cell?.date.text = String(data.日時)
        cell?.genre.text = String(data.ジャンル)
        cell?.area.text = String(data.エリア)
        cell?.genreIcon.image = UIImage(named: (cell?.genre.text)!)
        cell?.name.text = data.店名
        return cell!
    }
    // MARK: - ビュー遷移
    @objc func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        let data = visitedData[indexPath.row]
        
        let url = URL(string: data.食べログ)!
        let safariViewController = SFSafariViewController(url: url)
        tableView.deselectRow(at: indexPath, animated: false)
        self.present(safariViewController, animated: false, completion: nil)
    }
    
}
