//
//  RecordSounsViewController.swift
//  PitchPerfect
//
//  Created by Oleksandr Humeniuk on 9/1/20.
//

import UIKit
import AVFoundation

class RecordSounsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var startRecordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecodingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUi(enableRecording: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @IBAction func recordAudio(_ sender: Any) {
        configureUi(enableRecording: false)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    @IBAction func stopRecording(_ sender: Any) {
        configureUi(enableRecording: true)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: recorder.url)
        }else{
            print("audio recorder failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundVc = segue.destination as! PlaySoundsViewController
            let recordAudioUrl = sender as! URL
            playSoundVc.recordedAudioURL = recordAudioUrl
        }
    }
    
    func configureUi(enableRecording:Bool) {
        stopRecodingButton.isEnabled = !enableRecording
        recordButton.isEnabled = enableRecording
        if enableRecording {
            startRecordLabel.text = "Tap to Record"
        }else{
            startRecordLabel.text = "Recording in progress"
        }
    }
}

