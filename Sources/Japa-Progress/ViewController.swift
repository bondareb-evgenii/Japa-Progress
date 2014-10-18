//
//  ViewController.swif
//  Japa Progress
//

import UIKit
import AVFoundation
import MediaPlayer

@objc(ViewController) class ViewController: UIViewController
  {
  
  @IBOutlet var japaTargetLabel: UILabel?
  @IBOutlet var japaRoundCountLabel: UILabel?
  @IBOutlet var japaStepCountLabel: UILabel?
  var volumeViewSlider : UISlider?
  
  var japaStepCount: Int = 0
  var stepsInRound: Int = 1//taken from preferences in initializer
  
  required init(coder aDecoder: NSCoder)
    {
    //custom initialization
      
    super.init(coder: aDecoder)
    }
  
  override func viewDidLoad()
    {
    super.viewDidLoad()
    
    readPrefs()
    updateJapaLabels()
    
    //listen to hardware volume buttons
    AVAudioSession.sharedInstance().setActive(true, error: nil)
    AVAudioSession.sharedInstance().addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.New, context: nil)
    
    var volumeView = MPVolumeView(frame: CGRectMake(-10, -10, 0, 0));
    volumeView.showsRouteButton = false;
    volumeView.hidden = false;
    self.view.addSubview(volumeView);
    
    for view in volumeView.subviews
      {
      if view.isKindOfClass(UISlider)
        {
        volumeViewSlider = view as? UISlider;
        break;
        }
      }

    resetVolumeFromValue(1.0)//TODO: remember the original volume and set it back it when go to background; use  it or 0.00001 or 0.99999 instead of 0.5
    }
  
  func readPrefs()
    {
    let pref = NSUserDefaults.standardUserDefaults()
    stepsInRound = pref.integerForKey(stepsInRoundPrefKey)
    }

  override func didReceiveMemoryWarning()
    {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }

  func updateJapaLabels()
    {
    japaTargetLabel!.text = "\(stepsInRound)"
    japaRoundCountLabel!.text = "\(japaStepCount/stepsInRound)"
    japaStepCountLabel!.text = "\(japaStepCount%stepsInRound)"
    }
  
  func vibrateIfNeeded()
    {
    if japaStepCount != 0 && japaStepCount%stepsInRound == 0
      {
      vibrate()
      }
    }
  
  func vibrate()
    {
    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
  
  @IBAction func addJapaStep(sender: AnyObject)
    {
    addJapaStep()
    }
    
  func addJapaStep()
    {
    ++japaStepCount
    updateJapaLabels()
    vibrateIfNeeded()
    }
    
  override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>)
    {
    if resetVolumeFromValue(NSDictionary(dictionary: change).objectForKey("new")!.floatValue)
      {
      addJapaStep()
      }
    }
  
  func resetVolumeFromValue(value: Float) -> Bool
    {
    if value < 0.5 || value > 0.5
      {
      dispatch_async(dispatch_get_main_queue())
        {
        self.volumeViewSlider!.setValue(0.5, animated:false);
        self.volumeViewSlider!.sendActionsForControlEvents(UIControlEvents.TouchUpInside);
        }
      return true
      }
    return false
    }

  @IBAction func unwindToMainViewController(segue: UIStoryboardSegue)
    {
    readPrefs()
    updateJapaLabels()
    }

}

