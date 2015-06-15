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
    @IBOutlet weak var pauseButton: UIButton!
    
    
    var filePath:NSURL?
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        // enable the recording
        recordButton.enabled = true
        
        // hide the stop button
        toggleRecordingState(false)
        
        initRecorder()
    }
    
    func initRecorder() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "currentPitchPerfect.wav"
        let pathArray = [dirPath, recordingName]
        filePath = NSURL.fileURLWithPathComponents(pathArray)!
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
    }
    
  
    /**
        Start the recording and initialize the recorder and file paths
        
        :param: sender Recording Button on the Recording View
    */
    @IBAction func startRecording(sender: UIButton) {
        toggleRecordingState(true)
        
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }


    /**
        Stop the recording and save the audio file

        :param: sender UIButton that was pressed (should be the stop button on the recording view
    */
    @IBAction func stopRecording(sender: UIButton) {
        recordButton.enabled = true
        toggleRecordingState(false)
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
 
    @IBAction func pauseRecording(sender: UIButton) {
        if (audioRecorder.recording) {
            audioRecorder.pause()
            toggleRecordingState(false)
            recordingLabel.text = "Press the microphone to resume recording"
        }
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
 
    /**
        Toggle the UI Elements on the Record Screen
    
        :param: toggleState Indicates recordingState
    */

    func toggleRecordingState(toggleState: Bool) {
        if (toggleState == true) {
            stopButton.hidden = false
            stopButton.enabled = true
            pauseButton.enabled = true
            pauseButton.hidden = false
            recordButton.enabled = false
            recordingLabel.text = "Recording"
        } else {
            stopButton.hidden = true
            stopButton.enabled = false
            pauseButton.enabled = false
            pauseButton.hidden = true
            recordButton.enabled = true
            recordingLabel.text = "Press the microphone to start recording"
        }
    }
  
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "PlaySoundsSegue") {
            let vc:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            vc.recordedAudio(recordedAudio!)
        }
    }
    
}

