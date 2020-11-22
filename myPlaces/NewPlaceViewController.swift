//
//  NewPlaceViewController.swift
//  myPlaces
//
//  Created by Роман on 16.11.2020.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    var newPlace: Place?
    var imageChanged = false
    
    
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        
        placeName.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)

        
    }
    //MARK - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        
        
        
        if indexPath.row == 0 {
            let alerAction = UIAlertController(title: nil,
                                               message: nil,
                                               preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Камера", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Выбрать фото", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Отмена", style: .cancel)
            
            alerAction.addAction(camera)
            alerAction.addAction(photo)
            alerAction.addAction(cancel)
            present(alerAction, animated: true, completion: nil)
        } else{
            view.endEditing(true)
        }
    }
    
    func saveNewPlace () {
        var image: UIImage?
        if imageChanged {
            image = placeImage.image
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        newPlace = Place(name: placeName.text!,
                         location: placeLocation.text,
                         image: image,
                         restaurantImage: nil,
                         type: placeType.text)
    }

    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
//MARK: - text field delegate

extension NewPlaceViewController: UITextFieldDelegate {
    // Скрываем клавиатуру по нажатию на DONE
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc private func textFieldChange(){
        if placeName.text?.isEmpty == false{
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

//MARK: - work whith image

extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func chooseImagePicker (source: UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source){
            let image = UIImagePickerController()
            image.delegate = self
            image.allowsEditing = true
            image.sourceType = source
            present(image, animated: true, completion: nil)
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFit
        placeImage.clipsToBounds = true
        
        imageChanged = true
        
        
        dismiss(animated: true, completion: nil)
    }
    
}
