//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Julia Will on 13.06.15.
//  Copyright (c) 2015 Julia Will. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    
    var filePath:NSURL?
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        _toggleStopButton(false)
    }
    
  
    @IBAction func startRecording(sender: UIButton) {
        recordingLabel.hidden = false
        _toggleStopButton(true)
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
       
        let recordingName = "currentPitchPerfect.wav"
        let pathArray = [dirPath, recordingName]
        filePath = NSURL.fileURLWithPathComponents(pathArray)!
    
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(sender: UIButton) {
        recordButton.enabled = true
        recordingLabel.hidden = true
        _toggleStopButton(false)
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("PlaySoundsSegue", sender: recordedAudio)
            
        } else {
            let alertController = UIAlertController(title: "Unable to create audio", message: "An error occurred while trying to record your audio", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
 
    
    func _toggleStopButton(toggleState: Bool) {
        if (toggleState == true) {
            stopButton.hidden = false
            stopButton.enabled = true
        } else {
            stopButton.hidden = true
            stopButton.enabled = false
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "PlaySoundsSegue") {
            let vc:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            vc.recordedAudio(recordedAudio!)
        }
    }
    
}

