//
//  FilterDemoViewController.swift
//  chooseAssistant
//
//  Created by 方仕賢 on 2022/3/24.
//

import UIKit
import CoreImage.CIFilter

class FilterDemoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var uiImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func addImage(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    
    

    @IBAction func changeFilterValue(_ sender: UISlider) {
        print("has uiImage")
        if let uiImage = uiImage {
            let ciImage = CIImage(image: uiImage)
            let filter = CIFilter.colorMonochrome()
            filter.inputImage = ciImage
            filter.color = .blue
            filter.intensity = sender.value
            print("has ciImage")
            
            if let output = filter.outputImage {
                    let filterImage = UIImage(ciImage: output)
                    imageView.image = filterImage
                    print("has output")
                } else {
                    print("NO output")
                }
            } else {
                print("NO uiimage")
            }
       }
        
}
    



extension FilterDemoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = nil
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            uiImage = image
            
            if let uiImage = uiImage {
                let ciImage = CIImage(image: uiImage)
                let filter = CIFilter.colorMonochrome()
                filter.inputImage = ciImage
                filter.intensity = Float(0.5)
                print("has ciImage")
                
                if let output = filter.outputImage {
                        let filterImage = UIImage(ciImage: output)
                        imageView.image = filterImage
                        print("has output")
                    } else {
                        print("NO output")
                    }
                } else {
                    print("NO uiimage")
                }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
