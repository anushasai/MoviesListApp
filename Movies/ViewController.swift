//
//  ViewController.swift
//  Movies
//
//  Created by anusha rani on 5/3/17.
//  Copyright © 2017 Apple. All rights reserved.
//


// I've so many thoughts to present this application  but I don't have time to implement the fuctionality.


import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CustomSearchViewControllerDelegate
{

    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    @IBOutlet weak var tblSearchResults: UITableView!
    
    var dataArray = [String]()
   
    var pageNo = 1
    
    var totalPages = 0
    
    var serachString : String = String()
    
    var customSearchController: CustomSearchViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        
        configureCustomSearchController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // UITableView Delegate and Datasource functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrRes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCustomTableViewCell", for: indexPath) as! MoviesCustomTableViewCell

        var dict = arrRes[(indexPath as NSIndexPath).row]
        cell.titleLabel?.text = dict["title"] as? String
        let lang = dict["original_language"]as?String
        if lang == "en"
        {
            cell.languageLbl.text = "Language : English"
        }else{
            cell.languageLbl.text = String(format:  "Language: %@,", lang!)
        }
        
        let image = dict["poster_path"] as? String
        
        
        let placeholderImage = UIImage(named: "Placeholder")!
        
        if(image != nil){
        
            let urlImg = URL(string: imageUrl+image!)
            cell.movieImageView?.contentMode = .scaleAspectFit;

            cell.movieImageView?.af_setImage(withURL: urlImg!, placeholderImage: placeholderImage)
        
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let detailView = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        var dict = arrRes[(indexPath as NSIndexPath).row]
        
        detailView.overview = (dict["overview"] as? String)!
        detailView.movieDeatils = dict as NSDictionary 
        navigationController?.pushViewController(detailView, animated: true)
    }
    
    
    // Custom functions
    
    func loadListOfMovies(_ searchStr: String) {
        

        let queryStr = searchStr
        
        let url = URL(string: ("\(pagenoUrl)\(pageNo)\(queryUrl)\(queryStr)"))
        
        Alamofire.request(url!).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                 print(swiftyJsonVar)
                
                self.totalPages = swiftyJsonVar["total_pages"].int!
                if let resData = swiftyJsonVar["results"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
            }
        
           
            self.tblSearchResults.reloadData()
        }
         tblSearchResults.reloadData()
        
    }
    
    func configureCustomSearchController() {
        
        customSearchController = CustomSearchViewController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: tblSearchResults.frame.size.width, height: 50.0), searchBarFont: UIFont(name: "Futura", size: 16.0)!, searchBarTextColor: UIColor.black, searchBarTintColor: UIColor.white)
        
        customSearchController.customSearchBar.placeholder = "Search"
        tblSearchResults.tableHeaderView = customSearchController.customSearchBar
        customSearchController.searchBar.keyboardAppearance = .dark
        customSearchController.customDelegate = self
        
    }
    
    
    
    // CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        
        tblSearchResults.reloadData()
    }
    
    
    func didTapOnSearchButton(_ searchText: String) {
        
        
         serachString = searchText
       
        loadListOfMovies(serachString)
        
        tblSearchResults.reloadData()

    }
    
    
    func didTapOnCancelButton() {
        
        tblSearchResults.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height: CGFloat = scrollView.frame.size.height
        let contentYoffset: CGFloat = scrollView.contentOffset.y
        let distanceFromBottom: CGFloat = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            print("end of the table")
            
            if pageNo < totalPages && pageNo < 40{
                
                 addActivityIndicator()
            
                pageNo = pageNo+1
        
            }
        }
    }
    
    func addActivityIndicator()  {
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor.lightGray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        // Delay the dismissal by 5 seconds
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
        
            self.activityIndicator.stopAnimating()
            self.loadListOfMovies(self.serachString)
        }
        
    }
    
    func didChangeSearchText(_ searchText: String) {
        

    }
    
    
    
}
