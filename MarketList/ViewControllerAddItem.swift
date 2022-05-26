//
//  ViewControllerAddItem.swift
//  MarketList
//
//  Created by UNAM FCA 06 on 06/04/22.
//

import UIKit
import CoreData

class ViewControllerAddItem: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var item : Item!
    var nombreImagen = "item3"

    @IBOutlet weak var txtItem: UITextField!
    @IBOutlet weak var outletTipo: UISegmentedControl!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if item != nil{
            
            navigationItem.title = "Edit Item"
            txtItem.text = item.item
            nombreImagen = item!.item!
            imgPhoto.image = loadImageFromDiskWith(fileName: nombreImagen)
            
            var type = 0
            switch item.type{
            case "Urgent":
                type = 0
                break
            case "Regular":
                type = 1
                break
            case "Low":
                type = 2
                break
            default:
                type = 0
                break
            }
            outletTipo.selectedSegmentIndex = type
        }
    }
    
    @IBAction func addItem(_ sender: UIButton) {
        
        if let item2 = txtItem.text, let imagenSelect = imgPhoto.image {
            var type = ""
            switch outletTipo.selectedSegmentIndex{
            case 0:
                type = Segment.Urgent.rawValue
                break
            case 1:
                type = Segment.Regular.rawValue
                break
            case 2:
                type = Segment.Low.rawValue
                break
            default:
                break
            }
        
        if item != nil{
                updateEntityItem(item: item!, item2: item2, type: type)
                if let imagen2 = imgPhoto.image{
                    saveImage(imageName: nombreImagen, image: imagen2)
                }
                nombreImagen = item2
                print(nombreImagen)
        print("Hola")
        }else{
            nombreImagen = item2
            print(nombreImagen)
            saveImage(imageName: nombreImagen, image: imagenSelect)
            saveEntityItem(item: item2, type: type)
        }
        }
    }
    
    func saveEntityItem(item : String, type : String){
        let context = getContext()
        
        let entityItem = NSEntityDescription.entity(forEntityName: "Item", in: context)!
        let itemManaged = NSManagedObject(entity: entityItem, insertInto: context) as! Item
        
        itemManaged.item =  item
        itemManaged.type = type
        
        do {
            try context.save()
        } catch let error as NSError{
            print("No se pudo salvar: \(error), \(error.userInfo)")
        }
    }
    
    func getContext() -> NSManagedObjectContext{
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func updateEntityItem(item : Item, item2 : String, type : String){
        let context = getContext()
        let itemManaged = item as NSManagedObject
        
        itemManaged.setValue(item2, forKey: "item")
        itemManaged.setValue(type, forKey: "type")
        
        do {
            try context.save()
        } catch let error as NSError{
            print("No se pudo actualizar: \(error), \(error.userInfo)")
        }
    }
    
    func saveImage(imageName: String, image: UIImage) {
     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }

    }

    func loadImageFromDiskWith(fileName: String) -> UIImage? {

      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }

        return nil
    }
    
    @IBAction func actionCamera(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle:.actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
            imagePicker.sourceType = .camera
            self.present (imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present (imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = sender
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        imgPhoto.image = selectedImage
        dismiss(animated: true)
    }
    
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
