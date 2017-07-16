//
//  RecordViewController.swift
//  PitchPerfect
//
//  Created by Anh Duc Van on 7/8/17.
//  Copyright © 2017 Van. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordText: UITextField!
    @IBOutlet weak var recordAudio: UIButton!
    @IBOutlet weak var stopAudio: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioOnOFF(OnButton: true, OffButton: false)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func audioOnOFF(OnButton: Bool, OffButton: Bool){
        recordAudio.isEnabled = OnButton
        stopAudio.isEnabled = OffButton
        if OnButton == false {
            recordText.text = "Recording Now"
        }else{
            recordText.text = "Recording Stop"
        }
        
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        audioOnOFF(OnButton: false, OffButton: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    @IBAction func stopRecord(_ sender: Any) {
        audioOnOFF(OnButton: true, OffButton: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stop recording", sender: audioRecorder.url )
        }else{
            recordText.text = "Not Recording"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stop recording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

