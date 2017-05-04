//
//  DetailViewController.swift
//  Movies
//
//  Created by anusha rani on 5/3/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var overview : String = ""
    
    var movieDeatils: NSDictionary = NSDictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayMovieDetails()

        // Do any additional setup after loading the view.
    }
    
    func displayMovieDetails()
    {
        
       
        titleLbl.text = movieDeatils["original_title"] as? String
        releaseDateLbl.text = movieDeatils["release_date"] as? String
        descLbl.text = movieDeatils["overview"]as? String
        
        
        let image = movieDeatils["poster_path"] as! String
        
        
        
        let placeholderImage = UIImage(named: "Placeholder")!
        
        if(image != nil){
            
            let urlImg = URL(string: imageUrl+image)
            imgView?.contentMode = .scaleAspectFit;
            
            imgView?.af_setImage(withURL: urlImg!, placeholderImage: placeholderImage)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
