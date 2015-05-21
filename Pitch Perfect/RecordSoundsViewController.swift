//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Praveen Ramanathan on 5/15/15.
//  Copyright (c) 2015 Sangeetha. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var tapToRecord: UILabel!
    
   
    @IBOutlet weak var resumeButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var paused: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled=true
        recordingInProgress.hidden=true
        stopButton.hidden=true
        tapToRecord.hidden=false
        pauseButton.hidden=true
        resumeButton.hidden=true
        paused.hidden=true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordButton.enabled=false
        recordingInProgress.hidden=false
        stopButton.hidden=false
        pauseButton.hidden=false
        resumeButton.hidden=false
        tapToRecord.hidden=true
        
        //To record audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as! String
        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [dirPath,recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
            recordingInProgress.hidden = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
        
    }
    
    @IBAction func pauseAudio(sender: UIButton) {
        audioRecorder.pause()
        paused.hidden=false
        recordingInProgress.hidden=true
    }
    
    
    @IBAction func resumeAudio(sender: UIButton) {
        audioRecorder.record()
        paused.hidden=true
        recordingInProgress.hidden=false
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        recordButton.enabled=true
        recordingInProgress.hidden=true
        stopButton.hidden=true
        pauseButton.hidden=true
        resumeButton.hidden=true
        tapToRecord.hidden=false
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    
   }

