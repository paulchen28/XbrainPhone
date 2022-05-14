//
//  CameraViewController.swift
//  XbrainPhone
//
//  Created by 陳家騏 on 2021/12/17.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var input_picture: UIImageView!
    
    @IBOutlet weak var camera_show: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "拍照紀錄"
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func Photograph(_ sender: UIButton) {
        //拍照鍵
        var camera_picker_controller:UIImagePickerController
        camera_picker_controller = UIImagePickerController()
        camera_picker_controller.sourceType = UIImagePickerController.SourceType.camera
        //camera_picker_controller.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        camera_picker_controller.delegate = self
        
        self.present(camera_picker_controller, animated: true, completion: nil)
        
        self.camera_show.text = "請按下方拍照鍵或錄影鍵開始記錄"
        
    }
    
    @IBAction func Reshoot(_ sender: UIButton) {
        //重新拍攝
        self.input_picture.image = nil
        self.camera_show.text = "請按下方拍照鍵或錄影鍵開始記錄"
    }
    
    @IBAction func CameraSave(_ sender: UIButton) {
        //儲存
        
        
        
        
        
        
        
        //下面這行程式碼要寫在此函式的最後一行
        self.camera_show.text = "已成功儲存您的照片"
    }
    
    
    
    
    // MARK: - UIImagePickerControllerDelegate func
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("CANCEL....")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker:UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        print("SUCCESS....")
        let get_image:UIImage = info[.originalImage] as! UIImage
        
        //取得現在時間
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let timeString = dateFormatter.string(from: Date())
        
        self.camera_show.text = "拍攝時間 " + timeString
        
        //取得照片
        self.input_picture.image = get_image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
