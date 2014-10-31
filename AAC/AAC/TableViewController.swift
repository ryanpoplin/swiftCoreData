//
//  TableViewController.swift
//  AAC
//
//  Created by Byrdann Fox on 10/27/14.
//  Copyright (c) 2014 ExcepApps, Inc. All rights reserved.
//

import UIKit
import CoreData

var textViewText:String = ""

// DOESN'T MATTER FOR THE BETA...
/* ADD NAV OPTION FOR TABLEVIEW, ADD EDITING FOR SHORTCUTS, AND CONFIGURE SHORTCUT DISPLAY ORDERING IN THE TABLEVIEW FROM THE FETCHEDRESULTSCONTROLLER... */

class TableViewController: UIViewController, UITableViewDataSource, NSFetchedResultsControllerDelegate, UITableViewDelegate {
    
    struct TableViewConstants {
        
        static let cellIdentifier = "Cell"
    
    }
    
    var frc:NSFetchedResultsController!
    
    var managedObjectContext:NSManagedObjectContext? {
        return (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    }
    
    let fetchRequest = NSFetchRequest(entityName: "Shortcut")
    
    let shortcutSort = NSSortDescriptor(key: "shortcut", ascending: false)
    
    var refreshControl:UIRefreshControl?
    
    func handleRefresh(paramSender: AnyObject) {
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC))
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.refreshControl!.endRefreshing()
        })
        
    }
    
    var tableView: UITableView?
    
    let button = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchRequest.sortDescriptors = [shortcutSort]
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)

        tableView?.dataSource = self
        tableView?.delegate = self
        
        frc.delegate = self
        
        var fetchingError:NSError?
        
        if frc.performFetch(&fetchingError) {
            
            println("Successful fetch...")
        
        } else {
        
            println("Failed fetch...")
        
        }
        
        tableView = UITableView(frame: view.bounds, style: .Plain)
        
        if let theTableView = tableView {
            theTableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier:"identifier")
            
            theTableView.dataSource = self
            theTableView.delegate = self
            
            theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            
            refreshControl = UIRefreshControl()
            refreshControl!.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
            
            theTableView.addSubview(refreshControl!)
            
            view.addSubview(theTableView)
        }
        
        button.setTitle("Go Back", forState: UIControlState())
        button.backgroundColor = UIColor.clearColor()
        button.setTitleColor(UIColor.blueColor(), forState: UIControlState())
        button.sizeToFit()
        button.backgroundColor = UIColor.lightGrayColor()
        button.addTarget(self, action: "goBackButtonIsPressed:", forControlEvents: .TouchDown)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goBackButtonIsPressed(sender:UIButton!) {
        performSegueWithIdentifier("GoBack", sender: button)
    }
    
    func newLabelWithTitle(title: String) -> UIButton {
        return button
    }
    
    func tableView(tableView: UITableView!,
        heightForHeaderInSection section: Int) -> CGFloat{
            return 50
    }
    
    func tableView(tableView: UITableView!,
        viewForHeaderInSection section: Int) -> UIView!{
            return newLabelWithTitle("Section \(section) Header")
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
        tableView?.beginUpdates()
        
    }
    
    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {
        
        if type == .Delete {
            
            tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        /* ERROR HERE... */
        } /*else if type == .Insert {
            
            tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        }*/
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        
        let sectionInfo = frc.sections![section] as NSFetchedResultsSectionInfo
        
        return sectionInfo.numberOfObjects
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("identifier", forIndexPath: indexPath) as UITableViewCell
        
        let shortcut = frc.objectAtIndexPath(indexPath) as Shortcut
        
        cell.textLabel.text = shortcut.shortcut
        
        return cell
    
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {

        var selectedCell = tableView.cellForRowAtIndexPath(indexPath)

        var shortcutText = selectedCell!.textLabel.text
        
        textViewText = shortcutText!

        performSegueWithIdentifier("View", sender: nil)
        
    }
    
    func tableView(tableView: UITableView!, editingStyleForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCellEditingStyle {
        return .Delete
    }

    override func setEditing(editing: Bool, animated: Bool) {
        
        super.setEditing(editing, animated: animated)
        tableView!.setEditing(editing, animated: animated)
        
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
           
            let shortcutToDelete = self.frc.objectAtIndexPath(indexPath) as Shortcut
            
            managedObjectContext!.deleteObject(shortcutToDelete)
            
            if shortcutToDelete.deleted {
                
                var savingError:NSError?
                
                if managedObjectContext!.save(&savingError) {
                    
                    println("Object deleted...")
                    
                } else {
                    
                    if let error = savingError {
                        
                        println("Error: \(error)")
                        
                    }
                    
                }
                
            }
            
        }

    }
    
    // FOR THE BETA IT DOESN'T MATTER...
    /*func editTableViewRows() {
        
    }*/
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
        tableView?.endUpdates()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
     
        return true
    
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "View" {
        
            let controller = segue.destinationViewController as ViewController
            println(controller.view)
            textViewness = textViewness + " " + textViewText
            controller.textView?.text = textViewness
            
        }
        
        if segue.identifier == "GoBack" {
            
            let controller = segue.destinationViewController as ViewController
            println(controller.view) // Cheat...
            controller.textView?.text = textViewness
            
        }
        
    }
    
}