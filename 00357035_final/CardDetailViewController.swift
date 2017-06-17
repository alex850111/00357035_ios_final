//
//  CardDetailViewController.swift
//  00357035_final
//
//  Created by mari on 2017/5/30.
//  Copyright © 2017年 user_05. All rights reserved.
//

import UIKit

class CardDetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var petitView: UIImageView!
    @IBOutlet weak var propertyMark: UIImageView!
    @IBOutlet var viewPanel: UIView!
    @IBOutlet weak var b: UIButton!
    
    let nickName = "nickName", realName = "realName", type = "type"
    
    var cardName = ""
    var idolName = ""
    var property = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        b.addTarget(self, action: #selector(modifyLikeList), for: .touchUpInside)
        
        let parent = self.tabBarController as! cardTabBarController
        propertyMark.image = UIImage(named : "mark_" + parent.property)
        viewPanel.backgroundColor = parent.propertyColor
        
        idolName = parent.idolName
        cardName = parent.cardName
        property = parent.property
        
        petitView.image = UIImage(named : (cardName + idolName + "+(ぷち)").decomposedStringWithCanonicalMapping)
        if let asset = NSDataAsset(name : cardName + idolName), let contents = String(data:asset.data, encoding: String.Encoding.utf8){
            textView.text = contents
        }else{
            textView.text = "data not found"
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func modifyLikeList(sender: UIButton!){
        var likeDic = [[String:String]]()
        
        let fileManager = FileManager.default
        let docUrls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docUrl = docUrls.first
        let url = docUrl?.appendingPathComponent("likeList.txt")
        
        do{
            let content = try String(contentsOf: url!, encoding: String.Encoding.utf8)
            for line in content.components(separatedBy: "\n"){
                if(line.contains("\t")){
                    let s = line.components(separatedBy: "\t")
                    likeDic.append([nickName:s[0],realName:s[1].decomposedStringWithCanonicalMapping,type:s[2]])
                }
            }
        }
        catch{
            return
        }
        
        for dic in likeDic{
            if(dic[realName]?.decomposedStringWithCanonicalMapping == cardName + idolName){
                let controller = UIAlertController(title: "", message: "このカードはすでに「お気に入り」リストに入りました", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in})
                controller.addAction(action)
                present(controller, animated: true, completion: nil)
            
                return
            }
        }
        likeDic.append([realName:(cardName + idolName).decomposedStringWithCanonicalMapping,nickName:(cardName + idolName),type:property])
        
        do{
            var s = ""
            for dic in likeDic{
                s += dic[nickName]! + "\t"
                s += dic[realName]! + "\t"
                s += dic[type]! + "\n"
            }
            try s.write(to: url!, atomically: false, encoding: String.Encoding.utf8)
            let controller = UIAlertController(title: "", message: "お気に入り登録成功", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in})
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
        } catch {
            return
        }
    }
    
}
