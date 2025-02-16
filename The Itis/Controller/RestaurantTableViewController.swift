//
//  RestaurantTableViewController.swift
//  The Itis
//
//  Created by Vincent Hunter on 2/10/25.
//

import UIKit

class RestaurantTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        
        
    }

    // MARK: - Table view data source

    var restaurants:[Restaurant] = [
        Restaurant(name: "Cafe Deadend", type: "Coffe & Tea Shop", location: "Hong Kong", image: "cafedeadend", isFavorite: false),
        Restaurant(name: "Homei", type: "Cafe", location: "Hong Kong", image: "homei", isFavorite: false),
        Restaurant(name: "Teakha", type: "Tea House", location: "Hong Kong", image: "teakha", isFavorite: false),
        Restaurant(name: "Cafe Loisl", type: "Austrian/Casual Drink Shop", location: "Hong Kong", image: "cafeloisl", isFavorite: false),
        Restaurant(name: "Petite Oyster", type: "French", location: "Hong Kong", image: "petiteoyster", isFavorite: false),
        Restaurant(name: "For Kee Restaurant", type: "Bakery", location: "Hong Kong", image: "forkee", isFavorite: false),
        Restaurant(name: "Po's Atelier", type: "Bakery", location: "Hong Kong", image: "posatelier", isFavorite: false),
        Restaurant(name: "Bourke Street Backery", type: "Chocolate", location: "Sydney", image: "bourkestreetbakery", isFavorite: false),
        Restaurant(name: "Haigh's Chocolate", type: "Cafe", location: "Sydney"
        , image: "haigh", isFavorite: false),
        Restaurant(name: "Palomino Espresso", type: "American / Seafood", location: "Sydney", image: "palomino", isFavorite: false),
        Restaurant(name: "Upstate", type: "American", location: "New York", image: "upstate", isFavorite: false),
        Restaurant(name: "Traif", type: "American", location: "New York", image: "traif", isFavorite: false),
        Restaurant(name: "Graham Avenue Meats", type: "Breakfast & Brunch", location: "New York", image: "graham", isFavorite: false),
        Restaurant(name: "Waffle & Wolf", type: "Coffee & Tea", location: "New York", image: "waffleandwolf", isFavorite: false),
        Restaurant(name: "Five Leaves", type: "Coffee & Tea", location: "New York", image: "fiveleaves", isFavorite: false),
        Restaurant(name: "Cafe Lore", type: "Latin American", location: "New York", image: "cafelore", isFavorite: false),
        Restaurant(name: "Confessional", type: "Spanish", location: "New York"
        , image: "confessional", isFavorite: false),
        Restaurant(name: "Barrafina", type: "Spanish", location: "London", image: "barrafina", isFavorite: false),
        Restaurant(name: "Donostia", type: "Spanish", location: "London", image: "donostia", isFavorite: false),
        Restaurant(name: "Royal Oak", type: "British", location: "London", image: "royaloak", isFavorite: false),
        Restaurant(name: "CASK Pub and Kitchen", type: "Thai", location: "London", image: "cask", isFavorite: false)
    ]
    
    enum Section: Int {
        case all
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, Restaurant> {
        let cellIdentifier = "favoriteCell"
        
        let dataSource = UITableViewDiffableDataSource<Section, Restaurant>(
            tableView: tableView, cellProvider: { tableView, indexPath, restaurant in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
                
                //Configure Cell
                cell.nameLabel.text = restaurant.name
                cell.locationLabel.text = restaurant.location
                cell.typeLabel.text = restaurant.type
                cell.thumbnailImageView.image = UIImage(named: restaurant.image)
               
                
                //Check to see if the restaurant is not favorited, otherwise, favorite when clicked upon
                cell.favoriteImageView.isHidden = restaurant.isFavorite ? false : true
                return cell
            }
        )
        return dataSource
    }
    
    lazy var dataSource = configureDataSource()

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Creates an option menu as an action sheet
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        
        if let popoverController = optionMenu.popoverPresentationController {
            if let cell = tableView.cellForRow(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            }
        }
        
        //Adds actions to the menu
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        //Add the "reserve a table" action
        let reserveActionHandler = { (action: UIAlertAction) -> Void in
            let alertMessage = UIAlertController(title: "Not available yet", message: "Sorry, this feature isn't available yet. Please try again later!", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
        
        let reserveAction = UIAlertAction(title: "Reserve a table", style: .default, handler: reserveActionHandler)
        optionMenu.addAction(reserveAction)
        
        //Mark as favorite/unfavorite restaurant action
        
        let favoriteActionTitle = self.restaurants[indexPath.row].isFavorite ? "Remove from favorites" : "Mark as favorite"
        let favoriteAction = UIAlertAction(title: favoriteActionTitle, style: .default, handler: {
        (action:UIAlertAction!) -> Void in
        let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            
        cell.favoriteImageView.isHidden = self.restaurants[indexPath.row].isFavorite
            
        self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true
        })
        optionMenu.addAction(favoriteAction)
        
        //Remove from favorites action
//        let unfavroiteAction = UIAlertAction(title: "Remove from favorites", style: .default, handler: {
//            (action:UIAlertAction) -> Void in
//            if let cell = tableView.cellForRow(at: indexPath) {
//                cell.accessoryType = .none
//                
//                self.restaurauntIsFavorites[indexPath.row] = false
//            }
//        })
//        optionMenu.addAction(unfavroiteAction)
        
        //Display the menu
        present(optionMenu,animated: true, completion: nil)
        
        //Deselct the Row tapped
        tableView.deselectRow(at: indexPath, animated: false)
        
        
    }
    
    var restaurauntIsFavorites = Array(repeating: false, count: 21)
    
   

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
