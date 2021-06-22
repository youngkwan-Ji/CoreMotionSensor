//
//  ViewController.swift
//  WalkingPattern
//
//  Created by 영관 on 2017. 10. 24..
//  Copyright © 2017년 영관. All rights reserved.
//

import UIKit
import CoreMotion

class SensorViewController: UIViewController {
    @IBOutlet weak var lbluserZ: UILabel! // 사용자 가속도
    @IBOutlet weak var lbluserY: UILabel!
    @IBOutlet weak var lbluserX: UILabel!
    @IBOutlet weak var lblgravityX: UILabel! // 중력 벡터
    @IBOutlet weak var lblgravityY: UILabel!
    @IBOutlet weak var lblgravityZ: UILabel!
    @IBOutlet weak var lblrotationX: UILabel! // 회전 속도
    @IBOutlet weak var lblrotationY: UILabel!
    @IBOutlet weak var lblrotationZ: UILabel!
    @IBOutlet weak var lblattitudeX: UILabel! // 장치방향
    @IBOutlet weak var lblattitudeY: UILabel!
    @IBOutlet weak var lblattitudeZ: UILabel!
    @IBOutlet weak var lblProximity: UILabel! // 근접 센서
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnEnd: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    
    var checkInfo : Timer?
    let fileManager = FileManager.default
    
    var dataString = COLUMN_TITLE
    var startDate = ""
    var endDate = ""
    
    let CMManager : CoreMotionManager = CoreMotionManager.init()
    var sensing : Bool = false
    var writeTimer : Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CMManager.delegate = self
        self.title = "센서데이터 수집"
    }
    
    //MARK: - IBActions
    @IBAction func sensingAction(_ sender: UIButton) {
        if !sensing {
            if CMManager.startMotionCheck(){
                CMManager.startProximityCheck()
                setLogDateTime()
            
                sender.setTitle("stop", for: .normal)
                lblStatus.text = "sensing"
                
                writeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(writeData), userInfo: nil, repeats: true)
                writeTimer?.fire()
                
            }else{
                return
            }
        }else{
            CMManager.stopMotionCheck()
            CMManager.stopProximityCheck()
            setLogDateTime()
            writeTimer?.invalidate()
            
            
            sender.setTitle("start", for: .normal)
            lblStatus.text = "stop"
            lbluserZ.text = DEFAULT_VALUE
            lbluserY.text = DEFAULT_VALUE
            lbluserX.text = DEFAULT_VALUE
            lblgravityX.text = DEFAULT_VALUE
            lblgravityY.text = DEFAULT_VALUE
            lblgravityZ.text = DEFAULT_VALUE
            lblrotationX.text = DEFAULT_VALUE
            lblrotationY.text = DEFAULT_VALUE
            lblrotationZ.text = DEFAULT_VALUE
            lblattitudeX.text = DEFAULT_VALUE
            lblattitudeY.text = DEFAULT_VALUE
            lblattitudeZ.text = DEFAULT_VALUE
            lblProximity.text = DEFAULT_VALUE
            

            writeTextFile(startDate + "~" + endDate, dataString)
            dataString = COLUMN_TITLE
        }
        
        sensing = !sensing
    }
    
    @IBAction func helpViewAction (_ sender : UIButton) {
        let alert = UIAlertController.init(title: "", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "확인", style: .cancel, handler: nil)
        alert.addAction(action)
        
        switch sender.tag {
        case 1:
            alert.title = ACC_SENSOR_DESC
        case 2:
            alert.title = GRAVITY_SENSOR_DESC
        case 3:
            alert.title = ROTATION_SENSOR_DESC
        case 4:
            alert.title = ATT_SENSOR_DESC
        case 5 :
            alert.title = PROX_SENSOR_DESC
        default:
            return
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showFileList(_ sender: Any) {
        navigationController?.pushViewController(FileListViewController.init(nibName: "FileListViewController", bundle: nil), animated: true)
    }
    
    
    //MARK: - Functions
    func writeTextFile(_ date : String, _ info : String){
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let filePath = dirPath.appendingPathComponent(date + ".txt")
        let infoData = info.data(using: String.Encoding.utf8)
        
        var msg = "";
        if fileManager.createFile(atPath: filePath, contents: infoData, attributes: nil){
            msg = "데이터 저장이 완료되었습니다."
        }else{
            msg = "데이터 저장에 실패하였습니다."
        }
        
        let alert = UIAlertController.init(title: "알림", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func setLogDateTime(){
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if sensing {
            self.startDate = dateFormatter.string(from: nowDate)
        }else{
            self.endDate = dateFormatter.string(from: nowDate)
        }
    }
    
    @objc func writeData() {
        dataString += "\(lblProximity.text!), \(lbluserX.text!), \(lbluserY.text!), \(lbluserZ.text!), \(lblgravityX.text!), \(lblgravityY.text!), \(lblgravityZ.text!), \(lblrotationX.text!), \(lblrotationY.text!), \(lblrotationZ.text!), \(lblattitudeX.text!), \(lblattitudeY.text!), \(lblattitudeZ.text!)\n"
    }
    
}


//MARK: - CoreMotionSensorDelegate
extension SensorViewController : CoreMotionSensorDelegate{
    func updatedUserAcceleration(userMotion: CMAcceleration) {
        lbluserX.text = (String)(userMotion.x)
        lbluserY.text = (String)(userMotion.y)
        lbluserZ.text = (String)(userMotion.z)
    }
    
    func updatedGravity(gravityMotion: CMAcceleration) {
        lblgravityX.text = (String)(gravityMotion.x)
        lblgravityY.text = (String)(gravityMotion.y)
        lblgravityZ.text = (String)(gravityMotion.z)
    }
    
    func updatedRotationRate(rotationMotion: CMRotationRate) {
        lblrotationX.text = (String)(rotationMotion.x)
        lblrotationY.text = (String)(rotationMotion.y)
        lblrotationZ.text = (String)(rotationMotion.z)
    }
    
    func updatedAttitude(attitudeMotion: CMAttitude) {
        lblattitudeX.text = (String)(attitudeMotion.roll)
        lblattitudeY.text = (String)(attitudeMotion.pitch)
        lblattitudeZ.text = (String)(attitudeMotion.yaw)
    }
    
    func updatedProximity(state: Bool) {
        if state{
            lblProximity.text = "1"
        }else{
            lblProximity.text = "0"
        }
    }
}
