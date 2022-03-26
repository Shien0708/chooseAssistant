//
//  ViewController.swift
//  chooseAssistant
//
//  Created by 方仕賢 on 2022/3/17.
//

import UIKit

var buttonImages = [UIImage]()
var imageButtons = [UIButton]()
var itemNames = [String]()
var needToDisplayDate = false
var buttonImage = UIImage()
var touchedIndex = 0
var titleForOtherPage = ""

class ViewController: UIViewController {
    @IBOutlet weak var setDateSwitch: UISwitch!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var itemsView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    //title
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var setTitleButton: UIButton!
    
    //mode
    @IBOutlet weak var modeButton: UIButton!
    @IBOutlet weak var startBoxButton: UIButton!
    
    var itemViews = [UIView]()
    var itemCount = 0
    var removeButtons = [UIButton]()
    var isAdded = true
    var buttonImageIndex = 0
    var touchedButtonIndex = 0
    var remainedImageCounts = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chooseMode()
        setDateString()
    }
    
    //set title
    @IBAction func setTitleName(_ sender: Any) {
        if titleLabel.isHidden == false {
            setTitleButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            titleTextField.isHidden = false
            titleLabel.isHidden = true
        } else {
            titleTextField.isHidden = true
            titleLabel.isHidden = false
            setTitleButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            titleLabel.text = titleTextField.text!
            titleForOtherPage = titleLabel.text!
        }
        
    }
    
    
    // set date
    @IBAction func switchTheDate(_ sender: UISwitch) {
        
        if sender.isOn {
            datePicker.isHidden = false
            needToDisplayDate = true
        } else {
            datePicker.isHidden = true
            needToDisplayDate = false
        }
    }
    
    func setDateString(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MMMM/dd"
        dateString = formatter.string(from: datePicker.date)
    }
    

    @IBAction func setDate(_ sender: Any) {
        setDateString()
    }
    
    // choose mode
    func chooseMode() {
        modeButton.showsMenuAsPrimaryAction = true
        var actions = [UIAction]()
        let modeNames = ["Roulette", "Magic Box"]
        for i in 0...modeNames.count-1 {
            actions.append(UIAction(title:modeNames[i],handler: { action in
                if i == 0 {
                    self.startBoxButton.isHidden = true
                    self.modeButton.setTitle(modeNames[i], for: .normal)
                } else {
                    self.startBoxButton.isHidden = false
                    self.modeButton.setTitle(modeNames[i], for: .normal)
                }
            }))
        }
        modeButton.menu = UIMenu(children: actions)
    }
    
    // add items
    func makeABlank(y: Int, itemName: String){
        let width = 394
        let height = 60
        
        let itemView = UIView(frame: CGRect(x: 10, y: y*65+10, width: width, height: height))
        itemView.backgroundColor = .clear
        itemView.layer.borderWidth = 1
        
        let itemLabel = UILabel(frame: CGRect(x: 15, y: 5, width: width, height: height-5))
        itemLabel.text = itemName
        itemLabel.textColor = .white
        
        let addImageButton = UIButton(frame: CGRect(x: width-130, y: 5, width: 50, height: 50))
        if isAdded {
            addImageButton.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        } else {
            addImageButton.setImage(imageButtons[remainedImageCounts-buttonImageIndex].currentImage!, for: .normal)
            buttonImageIndex -= 1
        }
        addImageButton.addTarget(self, action: #selector(showController) , for: .touchUpInside)
        imageButtons.append(addImageButton)
        buttonImages.append(addImageButton.currentImage!)
       
        let removeButton = UIButton(frame: CGRect(x: width-35, y: 15, width: 30, height: 30))
        removeButton.backgroundColor = .red
        removeButton.setImage(UIImage(systemName: "minus"), for: .normal)
        removeButton.layer.cornerRadius = 15
        removeButton.tintColor = .white
        removeButton.addTarget(self, action: #selector(removeBlank), for: .touchUpInside)
        
        itemView.addSubview(itemLabel)
        itemView.addSubview(addImageButton)
        itemView.addSubview(removeButton)
        itemsView.addSubview(itemView)
        
        itemNames.append(itemName)
        itemViews.append(itemView)
        removeButtons.append(removeButton)
    }
    
    @objc func showController(){
        touchedIndex = 0
        
        while !imageButtons[touchedIndex].isTouchInside {
            touchedIndex += 1
        }
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "photoEditor") {
            buttonImage = imageButtons[touchedIndex].currentImage!
            show(controller, sender: nil)
        }
    }
    
    @objc func removeBlank(){
        touchedButtonIndex = 0
        isAdded = false
       
        while !removeButtons[touchedButtonIndex].isTouchInside && touchedButtonIndex < removeButtons.count-1 {
            touchedButtonIndex += 1
        }
        
        for i in 0...itemViews.count-1 {
            itemViews[i].removeFromSuperview()
        }
        itemViews.remove(at: touchedButtonIndex)
        itemCount = itemViews.count
        remainedImageCounts = itemCount
        buttonImageIndex = itemCount
        removeButtons.remove(at: touchedButtonIndex)
        imageButtons.remove(at: touchedButtonIndex)
        itemNames.remove(at: touchedButtonIndex)
        buttonImages.remove(at: touchedButtonIndex)
       
        if itemCount > 0 {
            for i in 0...itemCount-1 {
                    makeABlank(y: i, itemName: itemNames[i])
                }
            
            for _ in 0...itemCount-1 {
                imageButtons.removeFirst()
                buttonImages.removeFirst()
                itemNames.removeFirst()
                itemViews.removeFirst()
                removeButtons.removeFirst()
            }
            print("button images counts after removing :  \(buttonImages.count)")
        }
        isAdded = true
    }
    

    @IBAction func addItem(_ sender: Any) {
        if itemTextField.text != "" {
            makeABlank(y: itemCount, itemName: itemTextField.text!)
            itemCount += 1
            itemTextField.text = ""
        } else {
            let alert = UIAlertController(title: "Enter the item", message: "You haven't enter item's name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func checkItem(_ sender: Any) {
        if itemNames.count < 2 {
            let alert = UIAlertController(title: "Add more Items", message: "The items are not enough to choose", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func didEditPhoto(segue: UIStoryboardSegue) {
    }
    
}

extension ViewController: UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
