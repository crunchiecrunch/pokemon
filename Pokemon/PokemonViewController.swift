//
//  PokemonViewController.swift
//  Pokemon
//
//  Created by Crunchie on 30/08/17.
//  Copyright © 2017 Luke Job. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire

class PokemonViewController: UIViewController {
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pokemon.name
        
        loadPokemon()
    }
    
    func loadPokemon(){
        let decoder = JSONDecoder()
        if let url = pokemon.url{
            Alamofire.request(url).responseDecodableObject(keyPath: nil, decoder: decoder) { (response: DataResponse<Pokemon>) in
                switch response.result {
                case .success:
                    self.pokemon = response.result.value!
                    self.loadPokemonUI()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func loadPokemonUI(){
        if let weight = pokemon.weight{
            weightLabel.text = "Weight: " + String(weight)
        }
        if let height = pokemon.height{
            heightLabel.text = "Height: " + String(height)
        }
        
        if let url = pokemon.sprites?.imageUrl {
            Alamofire.request(url, method: .get).response { response in
                self.pokemonImage.image = UIImage(data: response.data!)
                self.pokemonImage.layer.magnificationFilter = kCAFilterNearest
            }
        }
    }
    
}
