//
//  SignUpView.swift
//  CoreDataExam
//
//  Created by Nikunj Prajapati on 22/01/20.
//  Copyright © 2020 Nikunj Prajapati. All rights reserved.
//

import UIKit
import CoreData

class SignUpView: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageUser: UIImageView!

    
     var imgPicker = UIImagePickerController()
    
    var people: [NSManagedObject] = []
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
     // MARK:-Save Function for save the data
    func save(name:String,email:String,password:String,image:String)
    {
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        let managecontext = appdelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managecontext!)
        let persone =  NSManagedObject(entity: entity!, insertInto: managecontext)
       
        persone.setValue(userName.text, forKey: "name")
        persone.setValue(userEmail.text, forKey: "email")
        persone.setValue(userPassword.text, forKey: "password")
        persone.setValue(image, forKey: "img")
        
        do
        {
            try managecontext!.save()
            people.append(persone)
            
        }
        catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
     // MARK: - Image pick From Photos
    @IBAction func imageGesture(_ sender: UITapGestureRecognizer)
    {
        imgPicker = UIImagePickerController()
        imgPicker.sourceType = .photoLibrary
            
            
        imgPicker.delegate = self
        
            //self.navigationController?.pushViewController(imgPicker, animated: true)
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let PickedImage = info[.originalImage] as! UIImage
        
        imageUser.contentMode = .scaleAspectFill
        imageUser.image = PickedImage
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        //self.navigationController?.popViewController(animated: true)//.pop(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
     // MARK: - Sign Up Button Tapped
    
    @IBAction func signUp(_ sender: Any)
    {
        let UserImage = imageUser.image!.jpegData(compressionQuality: 1.0)
        let ImgPng = UserImage?.base64EncodedString(options: .lineLength64Characters)
        if (userName.text == "" || userPassword.text == "" || userEmail.text == "" || imageUser.image == #imageLiteral(resourceName: "photo8.png"))
        {
            print("Opps...Not Saved...!")
            let alert = UIAlertController(title: "Don't Worry", message: "Please enter Name,EmailID and Password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            print("Data saved")
            save(name: userName.text!, email: userEmail.text!, password: userPassword.text!,image: ImgPng!)
            let alert = UIAlertController(title: "Data Saved", message: "Your Data is saved Succesfully", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    // MARK: - Navigation

}
