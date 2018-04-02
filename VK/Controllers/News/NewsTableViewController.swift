//
//  NewsTableViewController.swift
//  VK
//
//  Created by Maxim Tolstikov on 18/02/2018.
//  Copyright © 2018 Maxim Tolstikov. All rights reserved.

import UIKit
import VK_ios_sdk
import RealmSwift

class NewsTableViewController: UITableViewController {
    
    var news: Results <News>?
    var token: NotificationToken?    
    let newsService = NewsService()
    let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        paitTableAndRealm()
    }
    
    @objc func refresh(sender:AnyObject) {
        print("reload")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.estimatedRowHeight = 20
        self.tableView.rowHeight = UITableViewAutomaticDimension
        newsService.updateNews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(NewsTableViewController.updateTapped(_:)))
    }
    
    @objc func updateTapped(_ button:UIBarButtonItem!){
        
        performSegue(withIdentifier: "postSegue", sender: nil)
    }
    
    func paitTableAndRealm(){
        
        guard let realm = try? Realm() else {return}
        news = realm.objects(News.self)
        token = news?.observe {[weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else {return}
            switch changes{
            case .initial:
                tableView.reloadData()
                break
            case .update(_, deletions: let deletions, insertions: let insertion, modifications: let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertion.map({IndexPath(row: $0, section: 0)}), with: .fade)
                tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .fade)
                tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .fade)
                tableView.endUpdates()
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
    
    //MARK: Загрузка изображения новости
    func loadContentImage(indexPath: IndexPath) {
        
        let thisContentImage = news![indexPath.row].photo[0]
        let imageContentId = thisContentImage.id
        
        let nameFile = String(describing: imageContentId)
        let newUrl = cacheDirectory!.appendingPathComponent(nameFile)
        let urlString = newUrl.path
        
        if FileManager.default.fileExists(atPath: urlString) {
            
            DispatchQueue.global().async {
                self.newsService.addCacheUrlNewsContent(cache_photo: urlString, id: imageContentId)
                print("Cached")
            }
            
        } else {

            let urlImage = URL(string: thisContentImage.photo_604)
            guard urlImage != nil else {
                print("urlImage is not exist")
                return}
            URLSession.shared.downloadTask(with: urlImage!) {[weak self] (location, response, error) in
                
                try? FileManager.default.moveItem(at: location!, to: newUrl)
                self?.newsService.addCacheUrlNewsContent(cache_photo: urlString, id: imageContentId)
                print("Downloaded News")
                }.resume()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
            
            cell.likeLable.text = String(describing: news![indexPath.row].likes!.count)
            cell.commentsLable.text = String(describing: news![indexPath.row].comments!.count)
            cell.repostLable.text = String(describing: news![indexPath.row].reposts!.count)
            cell.prewiewLable.text = String(describing: news![indexPath.row].views!.count)
            cell.nameLable.text = news![indexPath.row].name_lable
            cell.contentText.text = news![indexPath.row].text
            
            let urlAvatar = URL(string: news![indexPath.row].icon_image)
            URLSession.shared.dataTask(with: urlAvatar!) { (data, response, errore) in
                guard data != nil else {return}
                DispatchQueue.main.async {
                    cell.avatar.image = UIImage(data: data!)
                }
                }.resume()
            
            if (news?[indexPath.row].photo.isEmpty)! {
                cell.contentPhoto.image = UIImage(contentsOfFile: "emptyPhoto")
            } else {
                
                let photoContent = news?[indexPath.row].photo[0]
                
                if photoContent?.cashed_photo == "" {
                    cell.contentPhoto.image = #imageLiteral(resourceName: "placeholder")
                    loadContentImage(indexPath: indexPath)
                    
                } else {
                    let strigForUrlPhoto = "file://" + (photoContent?.cashed_photo)!
                    let url = URL(string: strigForUrlPhoto)
                    
                    do{
                        let data = try Data(contentsOf: url!)
                        cell.contentPhoto.image = UIImage(data: data)
                    } catch(let error) {
                        print(error.localizedDescription)
                    }
                }
            }
            return cell
    }
    
        
}
