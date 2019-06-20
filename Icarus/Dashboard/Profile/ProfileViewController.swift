//
//  ProfileViewController.swift
//  Icarus
//
//  Created by MacOS on 11/06/2019.
//  Copyright © 2019 MacOS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import RSLoadingView
import Kingfisher

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usrAccount: UILabel!
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var cityInput: UITextField!
    @IBOutlet weak var sentenceInput: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var user: FirebaseUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingData()
        
        RSLoadingView.hide(from: view)

    }
    
    func settingData() {
        self.nameInput.text = user.name ?? ""
        self.cityInput.text = user.city ?? ""
        self.sentenceInput.text = user.sentence ?? ""
        self.usrAccount.text = Auth.auth().currentUser?.email ?? ""
        self.profileImage.isUserInteractionEnabled = true
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.cornerRadius = 66
        
        let url = Auth.auth().currentUser!.photoURL

        if let url = url as? URL{
            KingfisherManager.shared.retrieveImage(with: url as! Resource , options: nil, progressBlock: nil){ (image, error , cache , imageURL) in
                
                self.profileImage.image = image
                
                
            }
            
        }


    }
    
    @IBAction func pickerImage(_ sender: UITapGestureRecognizer) {
        pickImage()
    }
    func pickImage() {
        // Hide the keyboard.
        self.nameInput.resignFirstResponder()
        self.cityInput.resignFirstResponder()
        self.sentenceInput.resignFirstResponder()
        
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping ((_ url: URL?) -> ())) {
        let storageRef = Storage.storage().reference()
        let photoName = "\(Auth.auth().currentUser!.uid)"
        let imageRef = storageRef.child("usersProfilePicture/\(photoName).jpeg")
        guard let img = self.profileImage.image else {
            print("Imagen nula")
            return
            
        }
        let imgData = UIImageJPEGRepresentation(img, 0.2)
        

        
        let medaData = StorageMetadata()
        medaData.contentType = "image/jpeg"
        
        
        imageRef.putData(imgData!, metadata: medaData) { (metadata, error) in
            if error == nil {
                self.stopSpinner()
                print("Success")
                imageRef.downloadURL(completion: { (url, error) in
                    completion(url)
                })
                Auth.auth()
            } else {
                self.stopSpinner()
                self.showToast(message: "Ha ocurrido un error al intentar subir la imagen.")
                completion(nil)
            }
        }
    }

    @IBAction func save(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.uploadImage(self.profileImage.image!) { url in
                self.startSpinner()
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest!.photoURL = url
                changeRequest!.commitChanges { error in
                    if let _ = error {
                        
                        self.stopSpinner()
                        print("Try Again")
                    } else {
                        
                        self.stopSpinner()
                        print("Photo Updated")
                    }
                }
            }
            let db = Firestore.firestore()
            let userID = String(Auth.auth().currentUser!.uid)
            
            // Update the user data
            
            let ref = db.collection("users").document(userID)
            ref.updateData([
                
                "name" : self.nameInput.text ?? self.user.name,
                "city" : self.cityInput.text ?? self.user.city,
                "sentence" : self.sentenceInput.text ?? self.user.sentence
                
            ]) { (error) in
                if error != nil {
                    self.showToast(message: "Fallo al guardar")
                } else {
                    self.showToast(message: "Guardado")
                }
            }
        }

    }
    
    @IBAction func logout(_ sender: Any) {
        showAlert()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: "Cerrar sesión",
            message: "",
            preferredStyle: UIAlertController.Style.alert)
        let cancelButton = UIAlertAction(
            title:"Cancelar",
            style: UIAlertAction.Style.default,
            handler:
            {
                (alert: UIAlertAction!)  in
        })
        let okButton = UIAlertAction(title: "Cerrar sesión", style: UIAlertAction.Style.default) { (alert: UIAlertAction) in
            try! Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainLogin")
            self.present(vc, animated: true, completion: nil)
        }
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func startSpinner() {
        let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
        loadingView.mainColor = .cyan
        loadingView.shouldDimBackground = true
        loadingView.dimBackgroundColor = UIColor.black.withAlphaComponent(0.6)
        loadingView.isBlocking = true
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
    }
    
    // Funcion Custom spinner stop indications
    func stopSpinner() {
        RSLoadingView.hide(from: view)
    }
 
}

extension ProfileViewController: UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        self.profileImage.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
}
