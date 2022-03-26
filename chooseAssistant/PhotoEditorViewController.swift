//
//  PhotoEditorViewController.swift
//  chooseAssistant
//
//  Created by 方仕賢 on 2022/3/17.
//

import UIKit
import CoreImage.CIFilterBuiltins

class PhotoEditorViewController: UIViewController {

    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var filterSlider: UISlider!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterButton: UIButton!
    
    var uiImage: UIImage?
    var sliderValues = [Float](repeating: 0, count: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiImage = nil
        photoImageView.image = nil
        photoImageView.image = buttonImages[touchedIndex]
        uiImage = buttonImages[touchedIndex]
        enableFilterButton()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addImage(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func enableFilterButton(){
        if photoImageView.image != UIImage(systemName: "photo.on.rectangle.angled") {
            filterButton.isEnabled = true
        }
    }
    
    @IBAction func openFilter(_ sender: Any) {
        filterView.isHidden = true
    }
    
    
    @IBAction func adjustFilter(_ sender: UISlider) {
        if let uiImage = uiImage {
            let ciImage = CIImage(image: uiImage)
            
            switch filterSegmentedControl.selectedSegmentIndex {
            case 0:
                let filter = CIFilter.colorMonochrome()
                filter.inputImage = ciImage
                filter.color = .blue
                filter.intensity = sender.value
                
                if let output = filter.outputImage {
                    let filterImage = UIImage(ciImage: output)
                    photoImageView.image = filterImage
                    buttonImage = filterImage
                    buttonImages[touchedIndex] = uiImage
                    imageButtons[touchedIndex].setImage(buttonImage, for: .normal)
                } else {
                    print("no out put")
                }
                
            case 1:
                let filter = CIFilter.dither()
                filter.inputImage = ciImage
                filter.intensity = sender.value
                
                if let output = filter.outputImage {
                    let filterImage = UIImage(ciImage: output)
                    photoImageView.image = filterImage
                    buttonImage = filterImage
                    buttonImages[touchedIndex] = uiImage
                    imageButtons[touchedIndex].setImage(buttonImage, for: .normal)
                } else {
                    print("no out put")
                }
                
            default:
                let filter = CIFilter.gloom()
                filter.inputImage = ciImage
                filter.intensity = sender.value
                
                if let output = filter.outputImage {
                    let filterImage = UIImage(ciImage: output)
                    photoImageView.image = filterImage
                    buttonImage = filterImage
                    buttonImages[touchedIndex] = uiImage
                    imageButtons[touchedIndex].setImage(buttonImage, for: .normal)
                } else {
                    print("no out put")
                }
                
            }
            
        } else {
            print("no UIImage")
        }
        sliderValues[0] = sender.value
    }
}

// pick photo
extension PhotoEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        photoImageView.image = nil
        uiImage = nil
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            uiImage = image
            photoImageView.image = image
            buttonImage = image
            buttonImages[touchedIndex] = image
            imageButtons[touchedIndex].setImage(buttonImage, for: .normal)
            print("has uiimage")
            enableFilterButton()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
