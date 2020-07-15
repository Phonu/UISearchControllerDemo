//
//  ViewController.swift
//  UISearchControllerDemo
//
//  Created by mac admin on 22/06/20.
//  Copyright © 2020 Kunal. All rights reserved.
//

import UIKit

extension String:ExpressibleByStringLiteral{
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchContainerView: UIView!
    
    var searchController:UISearchController!
    
    
    
    var originalDataSourse:[String] = []
    var currentdataSourse:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addProductToDataSource(productCount: 20, product: "Mac Book pro")
        addProductToDataSource(productCount: 25, product: "iMac")
        addProductToDataSource(productCount: 40, product: "iPhone")
        
        currentdataSourse = originalDataSourse
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
        
        searchContainerView.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
    }

    func addProductToDataSource(productCount:Int, product:String) {
        for index in 1...productCount {
            originalDataSourse.append("\(product) £\(index)")
        }
    }
    
    func filterCurrentDatasource(searchTerm:String) {
        if searchTerm.count > 0 {
            currentdataSourse = originalDataSourse
            
            let filterResults = currentdataSourse.filter {
                $0.replacingOccurrences(of: " ", with: "").lowercased()
                    .contains(searchTerm.replacingOccurrences(of: " ", with: "").lowercased())
            }
            
            currentdataSourse = filterResults
            tableView.reloadData()
        }
    }
    
    
    func restoreCurrentDataSource() {
        currentdataSourse = originalDataSourse
        tableView.reloadData()
    }
    
    
    @IBAction func resetData(_ sender: Any) {
        restoreCurrentDataSource()
    }
    
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterCurrentDatasource(searchTerm: searchText)
        }
        
    }
    
    
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        if let searchText = searchBar.text {
            filterCurrentDatasource(searchTerm: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        if let searchText = searchBar.text, !searchText.isEmpty {
            restoreCurrentDataSource()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentdataSourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = currentdataSourse[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Selection", message: "\(currentdataSourse[indexPath.row])", preferredStyle: .alert)
        
        searchController.isActive = false
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true,completion: nil)
        
        
        
    }
    
    
    
}

