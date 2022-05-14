//
//  ViewController.swift
//  XbrainPhone
//
//  Created by 陳家騏 on 2021/12/8.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var Inform1: UILabel!
    
    @IBOutlet weak var Inform2: UILabel!
    
    
    
    @IBOutlet weak var Camera: UIButton!
    
    @IBOutlet weak var Mic: UIButton!
    
    @IBOutlet weak var Copy: UIButton!
    
    @IBOutlet weak var Calendar: UIButton!
    
    
    
    @IBOutlet weak var Background: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

//button 按著時 isHighlighted 為 true，此時 button 半透明。
class ImageButton: UIButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configurationUpdateHandler = {
            button
            in
            button.alpha = button.isHighlighted ? 0.5 : 1
        }
    }
}



/*
 //按住button時換圖，依據 isHighlighted 顯示不同的背景圖片。
 class RecordingButton: UIButton {
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         
         configurationUpdateHandler = {
             button
             in
             var config = button.configuration
             config?.background.image = button.isHighlighted ? UIImage(named: "Pause") : UIImage(named: "Recording")
             button.configuration = config
         }
     }
 }
 */



