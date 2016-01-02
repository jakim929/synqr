//
//  SidePanelViewController.swift
//  Synqr
//
//  Created by James Kim on 1/2/16.
//  Copyright © 2016 James Kim. All rights reserved.
//

import Foundation
import UIKit

protocol SidePanelViewControllerDelegate {
    //func personaSelected(animal: Animal)
}

class SidePanelViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: SidePanelViewControllerDelegate?
    
    //var animals: Array<Animal>!
    
    struct TableView {
        struct CellIdentifiers {
            static let PersonaCell = "PersonalCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
    
}

// MARK: Table View Data Source

extension SidePanelViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.PersonaCell, forIndexPath: indexPath) as! PersonaCell
        
        return cell
    }
    
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let selectedAnimal = animals[indexPath.row]
        //delegate?.animalSelected(selectedAnimal)
    }
    
}

class PersonaCell: UITableViewCell {
    
    
    
}