//
//  TableViewController.swift
//  TravelBook
//
//  Created by Mac on 2.01.2022.
//

import UIKit
import CoreData

class TableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var myTableView: UITableView!
    var places=[PlacesModel]()
    var chosenPlace:PlacesModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        myTableView.delegate = self
        myTableView.dataSource = self
        getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        //we use this method because viewDidload work just firs loading
        //beside this method runs every loading this controller
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
    }
    @objc func addButtonClicked() {
        //to add new place
        performSegue(withIdentifier: "toMapView", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapView" {
            if let desVC = segue.destination as? ViewController{
                desVC.chosenPlace = chosenPlace
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenPlace = places[indexPath.row]
        performSegue(withIdentifier: "toMapView", sender: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = places[indexPath.row].title
        return cell
    }
    @objc func getData(){
       //clear array values for not dublicating datas;
        places.removeAll(keepingCapacity: false)

           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let context = appDelegate.persistentContainer.viewContext
           
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
           //for more performans usage this can be made false;
           fetchRequest.returnsObjectsAsFaults = false
        
           do {
             let results =  try context.fetch(fetchRequest)
               for item in results as! [NSManagedObject] {
                   if let longtitude = item.value(forKey: "longtitude") as? Double,let latitude = item.value(forKey: "latitude") as? Double,let subtitle = item.value(forKey: "subtitle") as? String,let title = item.value(forKey: "title") as? String, let id = item.value(forKey: "id") as? UUID{
                    places.append(PlacesModel(id:id,title:title,subtitle:subtitle,latitude:latitude,longtitude:longtitude))
                   }
               }
               self.myTableView.reloadData()
           } catch  {
               print("some error occur \(error)")
           }
       }

}
