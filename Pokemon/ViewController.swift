//
//  ViewController.swift
//  Pokemon
//
//  Created by Crunchie on 30/08/17.
//  Copyright © 2017 Luke Job. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire

class ViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.navigationItem.searchController = searchController
        
        catchPokemon()
    }
    
    // MARK: Download and decode Pokemon data
    
    func catchPokemon() {
        let decoder = JSONDecoder()
        Alamofire.request("https://pokeapi.co/api/v2/pokemon").responseDecodableObject(keyPath: "results", decoder: decoder) { (response: DataResponse<[Pokemon]>) in
            switch response.result {
            case .success:
                self.pokemon = response.result.value!
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: UITableViewDelegate, UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredPokemon.count
        }
        
        return pokemon.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        let pokemon: Pokemon
        if isFiltering() {
            pokemon = self.filteredPokemon[indexPath.row]
        } else {
            pokemon = self.pokemon[indexPath.row]
        }
        cell.textLabel!.text = pokemon.name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemonViewController = storyboard!.instantiateViewController(withIdentifier: "PokemonViewController") as! PokemonViewController
        let pokemon: Pokemon
        if isFiltering() {
            pokemon = self.filteredPokemon[indexPath.row]
        } else {
            pokemon = self.pokemon[indexPath.row]
        }
        pokemonViewController.pokemon = pokemon
        self.navigationController?.pushViewController(pokemonViewController, animated: true)
    }
    
    // MARK: - Search Filtering
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredPokemon = pokemon.filter({( pokemon : Pokemon) -> Bool in
            return pokemon.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

