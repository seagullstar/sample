//
//  SecondViewController.swift
//  ogawamachi
//
//  Created on 2021/07/23.
//

import UIKit
import SafariServices

class UnVisitedViewController: UIViewController {
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    var mapButton: UIBarButtonItem!
    var filterButton: UIBarButtonItem!
    
    var planData = omiseData
    let backup = omiseData
    
    var filteredOmises: [Omise] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "小川町ランチ"
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        self.tableView.hideSearchBar()

        // フォント種をTime New Roman、サイズを20に指定
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "HiraginoSans-W6", size: 20)!]
        
        mapButton = UIBarButtonItem(title: "マップ", style: .plain, target: self, action: #selector(self.showMap))
        self.navigationItem.setLeftBarButtonItems([mapButton], animated: true)
        
        filterButton = UIBarButtonItem(title: "選択", style: .plain, target: self, action: #selector(self.filterOptions))
        self.navigationItem.setRightBarButtonItems([filterButton], animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateView(notification:)), name: .updateView, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(random), name: .random, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clear), name: .clear, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sortByGenre), name: .sortByGenre, object: nil)
    }
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredOmises = omiseData.filter { (omise: Omise) -> Bool in
            return omise.タグ.contains(searchText.lowercased())
        }
        tableView.reloadData()
        self.tableView.hideSearchBar()
    }
    
    // ジャンル・エリアで絞り込んだお店を表示
    @objc func updateView(notification: NSNotification?) {
        planData = backup
        omiseData = planData
        
        if let keyword = notification?.userInfo!["ジャンル"] as? String {
            self.planData = omiseData.filter { $0.ジャンル.contains(keyword) }
        } else if let keyword = notification?.userInfo!["エリア"] as? String {
            self.planData = omiseData.filter { $0.エリア.contains(keyword) }
        } else if let keyword = notification?.userInfo!["タグ"] as? String {
            self.planData = omiseData.filter { $0.タグ.contains(keyword) }
        }
        
        omiseData = self.planData
        self.navigationItem.title = "\(omiseData.count) 件"
        self.tableView!.reloadData()
        self.tableView.hideSearchBar()
    }
    
    // ジャンルでソート
    @objc func sortByGenre(notification: NSNotification?) {
        planData = backup
        omiseData = planData
        
        if notification?.userInfo!["ソート"] as? String == "ジャンル（昇）" {
            planData.sort(by: {$0.ジャンル < $1.ジャンル})
        } else if notification?.userInfo!["ソート"] as? String == "ジャンル（降）" {
            planData.sort(by: {$0.ジャンル > $1.ジャンル})
        } else if notification?.userInfo!["ソート"] as? String == "エリア（昇）" {
            planData.sort(by: {$0.エリア < $1.エリア})
        } else {
            planData.sort(by: {$0.エリア > $1.エリア})
        }
        self.navigationItem.title = "小川町ランチ"
        self.tableView!.reloadData()
        self.tableView.hideSearchBar()
    }
    
    // ランダムで１件表示
    @objc func random() {
        planData = backup
        omiseData = planData
        if let contents = self.planData.randomElement() {
            self.planData = [contents]
            omiseData = self.planData
        } else {
            print("Empty contents.")
        }
        self.navigationItem.title = "小川町ランチ"
        self.tableView!.reloadData()
        self.tableView.hideSearchBar()
    }
    
    // 条件をクリアして、全件表示
    @objc func clear() {
        planData = backup
        omiseData = planData
        self.navigationItem.title = "小川町ランチ"
        self.tableView!.reloadData()
        self.tableView.hideSearchBar()
    }
    
    @objc func showMap(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "MapView", bundle: nil)
        let mapViewController = storyboard.instantiateViewController(withIdentifier: "mapView")
        mapViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    @objc func filterOptions(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "FilterView", bundle: nil)
        let filterViewController = storyboard.instantiateViewController(withIdentifier: "filterView")
        filterViewController.hidesBottomBarWhenPushed = true
        present(filterViewController, animated: true)
    }
    
    // MARK: - セル数
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
          return filteredOmises.count
        }
        return omiseData.count
    }
    
    // MARK: - セル内容
    @objc func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listViewCell") as? ListViewCell
        let data: Omise
        if isFiltering {
            data = filteredOmises[indexPath.row]
        } else {
            data = omiseData[indexPath.row]
        }
        cell?.date.text = String(data.日時)
        cell?.genre.text = String(data.ジャンル)
        cell?.area.text = String(data.エリア)
        cell?.genreIcon.image = UIImage(named: (cell?.genre.text)!)
        cell?.name.text = data.店名
        if String(data.タグ) .contains("遅昼") {
            cell?.tagList.text = "[遅昼]"
        } else {
            cell?.tagList.text = ""
        }
        return cell!
    }
    
    // MARK: - ビュー遷移
    @objc func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let data: Omise
        if isFiltering {
            data = filteredOmises[indexPath.row]
        } else {
            data = omiseData[indexPath.row]
        }
        let url = URL(string: data.食べログ)!
        let safariViewController = SFSafariViewController(url: url)
        tableView.deselectRow(at: indexPath, animated: false)
        self.present(safariViewController, animated: false, completion: nil)
    }
    
}

// サーチバーを非表示にする
extension UITableView {
    func hideSearchBar() {
        if let bar = self.tableHeaderView as? UISearchBar {
            let height = bar.frame.height
            let offset = self.contentOffset.y
            if offset < height {
                self.contentOffset = CGPoint(x: 0, y: height)
            }
        }
    }
}

extension UnVisitedViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}
