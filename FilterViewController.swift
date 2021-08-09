//
//  FilterViewController.swift
//  ogawamachi
//
//  Created on 2021/07/24.
//

import UIKit

class FilterViewController: UIViewController, UITextFieldDelegate {
            
    @IBOutlet weak var genreButton: UIButton!
    @IBOutlet weak var genreTableView: UITableView!
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var areaTableView: UITableView!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var sortTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genreTableView.isHidden = true
        areaTableView.isHidden = true
        tagTableView.isHidden = true
        sortTableView.isHidden = true
    }
    
    @IBAction func onClickGenreButton(_ sender: Any) {
        if genreTableView.isHidden {
            animate(toggle: true, type: genreButton)
        } else {
            animate(toggle: false, type: genreButton)
        }
    }
    
    @IBAction func onClickAreaButton(_ sender: Any) {
        if areaTableView.isHidden {
            animate(toggle: true, type: areaButton)
        } else {
            animate(toggle: false, type: areaButton)
        }
    }
    
    @IBAction func onClickTagButton(_ sender: Any) {
        if tagTableView.isHidden {
            animate(toggle: true, type: tagButton)
        } else {
            animate(toggle: false, type: tagButton)
        }
    }
    
    @IBAction func onClickSortButton(_ sender: Any) {
        if sortTableView.isHidden {
            animate(toggle: true, type: sortButton)
        } else {
            animate(toggle: false, type: sortButton)
        }
    }
    
    func animate(toggle: Bool, type: UIButton) {
        if type == genreButton {
            if toggle {
                UIView.animate(withDuration: 0.3) {
                    self.genreTableView.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.genreTableView.isHidden = true
                }
            }
        } else if type == areaButton {
            if toggle {
                UIView.animate(withDuration: 0.3) {
                    self.areaTableView.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.areaTableView.isHidden = true
                }
            }
        } else if type == tagButton {
            if toggle {
                UIView.animate(withDuration: 0.3) {
                    self.tagTableView.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.tagTableView.isHidden = true
                }
            }
        } else {
            if toggle {
                UIView.animate(withDuration: 0.3) {
                    self.sortTableView.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.sortTableView.isHidden = true
                }
            }
        }
    }
    
    @IBAction func sortByGenre(_ sender: Any) {
        NotificationCenter.default.post(name: .sortByGenre, object: nil)
        dismissModalView()
    }
    
    @IBAction func randomSelect(_ sender: Any) {
        NotificationCenter.default.post(name: .random, object: nil)
        dismissModalView()
    }
    
    @IBAction func clear(_ sender: Any) {
        NotificationCenter.default.post(name: .clear, object: nil)
        dismissModalView()
    }
    
    private func dismissModalView() {
        guard
            let vc = presentingViewController
            else { return }
        vc.dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == genreTableView {
            return genreList.count
        } else if tableView == areaTableView {
            return areaList.count
        } else if tableView == tagTableView {
            return tagList.count
        } else {
            return sortList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if tableView == genreTableView {
            cell.textLabel?.text = genreList[indexPath.row]
        } else if tableView == areaTableView {
            cell.textLabel?.text = areaList[indexPath.row]
        } else if tableView == tagTableView {
            cell.textLabel?.text = tagList[indexPath.row]
        } else {
            cell.textLabel?.text = sortList[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == genreTableView {
            genreButton.setTitle("\(genreList[indexPath.row])", for: .normal)
            animate(toggle: false, type: genreButton)
            NotificationCenter.default.post(name: .updateView, object: nil, userInfo: ["ジャンル": genreList[indexPath.row]])
        } else if tableView == areaTableView {
            areaButton.setTitle("\(areaList[indexPath.row])", for: .normal)
            animate(toggle: false, type: areaButton)
            NotificationCenter.default.post(name: .updateView, object: nil, userInfo: ["エリア": areaList[indexPath.row]])
        } else if tableView == tagTableView {
            tagButton.setTitle("\(tagList[indexPath.row])", for: .normal)
            animate(toggle: false, type: tagButton)
            NotificationCenter.default.post(name: .updateView, object: nil, userInfo: ["タグ": tagList[indexPath.row]])
        } else {
            sortButton.setTitle("\(sortList[indexPath.row])", for: .normal)
            animate(toggle: false, type: sortButton)
            NotificationCenter.default.post(name: .sortByGenre, object: nil, userInfo: ["ソート": sortList[indexPath.row]])
        }
        dismissModalView()
    }
}
