//
//  DetailViewController.swift
//  SoundTouch
//
//  Created by phuc on 5/13/15.
//  Copyright (c) 2015 phuc nguyen. All rights reserved.
//

import UIKit
import Spring
class DetailViewController: UIViewController {

    var model: Model?
    var image: SpringImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()
        image = SpringImageView(frame: self.view.frame)
    }
    override func viewDidAppear(animated: Bool) {
        view.addSubview(image)
        if model != nil {
            image.image = UIImage(named: model!.imageName)
        }
        image.animation = "zoomIn"
        image.animationDuration = 0.25
        image.animate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
