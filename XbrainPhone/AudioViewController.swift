//
//  AudioViewController.swift
//  XbrainPhone
//
//  Created by 陳家騏 on 2021/12/17.
//

import UIKit
import Speech

class AudioViewController: UIViewController {

    
    @IBOutlet weak var Audio_speech: UITextView!
    
    @IBOutlet weak var audio_show: UILabel!
    
    @IBOutlet weak var btn_start: UIButton!
    
    let audioEngine = AVAudioEngine()
    //let speechRecongnizer:SFSpeechRecognizer? = SFSpeechRecognizer()
    let speechRecongnizer:SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "zh_TW"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    weak var task:SFSpeechRecognitionTask!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "錄音紀錄"
        
        // Do any additional setup after loading the view.
        //requestPermission()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    
    @IBAction func recording_button(_ sender: UIButton) {
        
        if sender.tag == 0 {
             //切換圖示
             sender.configuration?.background.image = UIImage(named: "Pause")
             //更改tag等待下一次切換
             sender.tag = 1
             startSpeechRecongnition()
             self.audio_show.text = "請按下方錄音鍵開始記錄"
         }else{
             //切換圖示
             sender.configuration?.background.image = UIImage(named: "Recording")
             //更改tag等待下一次切換
             sender.tag = 0
             cancelSpeechRecongnition()
         }
        
    }
    
    
    @IBAction func reRecord(_ sender: UIButton) {
        //重新輸入
        self.Audio_speech.text = ""
        self.audio_show.text = "請按下方錄音鍵開始記錄"
    }
    
    
    
    @IBAction func audio_save(_ sender: UIButton) {
        //儲存
        //取得現在時間
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let timeString = dateFormatter.string(from: Date())
        
        self.audio_show.text = "記錄時間 " + timeString
        
    }
    
    func startSpeechRecongnition(){
        // 讓引擎把我把聲音存在buffer
        let node:AVAudioNode = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){
            (buffer,time)
            in
            //加入我的請求內容
            self.request.append(buffer)
        }
        // 底層運作引擎啟動
        audioEngine.prepare()
        do{
           try audioEngine.start()
        }catch{
            print("audio引擎啟動錯誤 : \(error.localizedDescription)")
            
        }
        
        
        
        //發送請求
        /*
        guard let stranger = SFSpeechRecognizer() else{
            self.alertView(message: "沒有辦法執行辨識功能")
            return
        }
        if(!stranger.isAvailable){
            self.alertView(message: "忙碌中無法工作")
            return
        }
        */
        guard let stranger = speechRecongnizer else{
            self.alertView(message: "沒有辦法執行辨識功能")
            return
        }
        if(!stranger.isAvailable){
            self.alertView(message: "忙碌中無法工作")
            return
        }
        task = stranger.recognitionTask(with: self.request){
            (result, err)
            in
            if let e = err{
                print("出錯了! error is:\(e)")
                
            }else{
                //處理辨識的結果 SFSpeechRecongnitionResult
                if let real_resulty = result{
                    let ok_result = real_resulty.bestTranscription.formattedString
                    print(ok_result)
                    self.Audio_speech.text = ok_result
                    /*
                    var last_word:String  = ""

                    for segement in real_resulty.bestTranscription.segments{
                        let index:String.Index = ok_result.index(ok_result.startIndex, offsetBy: segement.substringRange.location)
                        last_word = String(ok_result[index...])
                    }
                */
                    let ss:[String] = ok_result.components(separatedBy: " ")
                    let last_word:String = ss[ss.count-1]
                    if(last_word == "red"){
                        DispatchQueue.main.async {
                            self.Audio_speech.backgroundColor = UIColor.white
                        }
                    }else if(last_word == "green"){
                        DispatchQueue.main.async {
                            self.Audio_speech.backgroundColor = UIColor.white
                        }
                    }else if(last_word == "blue"){
                        DispatchQueue.main.async {
                            self.Audio_speech.backgroundColor = UIColor.white
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.Audio_speech.backgroundColor = UIColor.white
                        }
                    }
                }
            }
        }
        
    }

    func cancelSpeechRecongnition(){
        task.finish()
        task.cancel()
        task = nil
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
    }
    func requestPermission(){
        print("start to check permission");
        btn_start.isEnabled = false
        SFSpeechRecognizer.requestAuthorization{
            status
            in
            if(status == .authorized){
                print("OK go ahead")
                OperationQueue.main.addOperation {
                    self.btn_start.isEnabled = true
                }
                
            }else if(status == .denied){
                
                DispatchQueue.main.async {
                    self.alertView(message: "使用者先前不同意權限無法執行")
                }
                
                
            }else if(status == .notDetermined){
                DispatchQueue.main.async {
                    self.alertView(message: "使用者尚未決定")
                }
                
            }else if(status == .restricted){
                DispatchQueue.main.async {
                    self.alertView(message: "使用者僅僅同意部分功能")
                }
                
            }
            
        }
    }
    
    func alertView(message:String){
        let controller = UIAlertController(title: "出現錯誤", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "確定", style: .default, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    
}
