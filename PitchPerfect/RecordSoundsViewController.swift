//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Unathi Chonco on 2016/03/20.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    
    @IBAction func recordAudio(sender: UIButton) {
        recordingLabel.text = "Recording ..."
        
        if let audioRecorder = audioRecorder{
            if audioRecorder.recording{
                audioRecorder.pause()
                recordingLabel.text = "Paused"
            } else {
                audioRecorder.record()
                stopRecordingButton.hidden = false
                stopRecordingButton.enabled = true
            }
        } else {
            stopRecordingButton.hidden = false
            stopRecordingButton.enabled = true
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
        
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordingLabel.text = "Tap to record"
        stopRecordingButton.enabled = false
        stopRecordingButton.hidden = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopRecordingButton.enabled = false
        stopRecordingButton.hidden = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            let alert = UIAlertController(title: "Failed", message: "Recording could not be saved", preferredStyle: .Alert)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

