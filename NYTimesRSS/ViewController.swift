//
//  ViewController.swift
//  NYTimesRSS
//
//  Created by Melaniia Hulianovych on 4/10/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var newsArray = [NewsItem]()
    var parser = XMLParser()
    var currentElement: NewsItem!
    var passData:Bool = false
    let dictionaryKeys = ["title", "link"]
    var currentValue: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url:String = "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
        let urlToSend: URL = URL(string: url)!
        self.navigationController?.navigationBar.tintColor = UIColor.black
        let logo = UIImage(named: "Logo")
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        parser = XMLParser(contentsOf: urlToSend)!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        
        if success {
            print("parse success!")
        } else {
            print("parse failure!")
        }
        
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsArray.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell
        let item = newsArray[indexPath.item]
        
        cell?.newsLable.text = item.title
        cell?.newsLable.numberOfLines = 0
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentElement = newsArray[indexPath.row]
        performSegue(withIdentifier: "DetailSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            let vc = segue.destination as! DetailViewController
            vc.link = currentElement.link
            
        }
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if elementName == "item" {
            passData = true
            currentElement = NewsItem()
        } else if dictionaryKeys.contains(elementName) {
            currentValue = String()
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item"  {
            newsArray.append(currentElement)
            passData = false
            currentElement = nil
        } else if dictionaryKeys.contains(elementName) {
            if passData == true {
                if elementName == "link" {
                    currentElement.link = currentValue
                    
                }
                if elementName == "title" {
                    currentElement.title = currentValue
                }
                currentValue = nil
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        currentValue? += string
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
}

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var newsLable: UILabel!
    
}

class NewsItem {
    var title: String?
    var link: String?
}
