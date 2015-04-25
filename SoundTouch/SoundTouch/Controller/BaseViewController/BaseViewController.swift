//
//  BaseViewController.swift
//  SoundTouch
//
//  Created by phuc on 4/23/15.
//  Copyright (c) 2015 phuc nguyen. All rights reserved.
//

import UIKit
enum BaseVCTab: Int {
    case unknown
    case animal
    case instrusment
    case vehicle
}
class BaseViewController: UIViewController {

    let categories = Categories.getAllCategory()
    var baseVCTab = BaseVCTab.unknown
    var dataSouce: Array<Model>?
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getData() {
        switch baseVCTab {
        case .animal:
            let category = Categories.getCategoryByName("animal")
            dataSouce = Model.getModelByCategory(category)
            break
        case .instrusment:
            let instrument = Categories.getCategoryByName("instrusment")
            dataSouce = Model.getModelByCategory(instrument)
            break
        case .vehicle:
            let vehicle = Categories.getCategoryByName("vehicle")
            dataSouce = Model.getModelByCategory(vehicle)
            break
        case .unknown:
            break
        }
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension BaseViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSouce?.count > 0 {
            return dataSouce!.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        let model = dataSouce![indexPath.row]
        cell.imageView.image = UIImage(named: model.imageName)
        cell.label.text = model.name
        return cell
    }
}
// MARK: - UICollectionViewDelegate
extension BaseViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = dataSouce![indexPath.row]
        soundPlayer.playSound(model.soundName)
    }
}
// MARK: - UICollectionViewDelegate
extension BaseViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 2
        return CGSize(width: width, height: width)
    }
}