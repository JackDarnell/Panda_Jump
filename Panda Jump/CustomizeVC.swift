//
//  CustomizeVC.swift
//  Panda Jump
//
//  Created by Jack Darnell on 6/20/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import UIKit

class CustomizeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coinsLabel: UILabel!

    private let slideAnimation = SlideAnimationForward()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh after coming back from a purchase or equip.
        tableView.reloadData()
        coinsLabel.text = "\(GameData.coins)ƒ"
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        skins.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomizeCell", for: indexPath) as! CustomizeCell
        cell.configure(with: skins[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToCustomizeObjectVC", sender: skins[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        // A custom transition only gets both views (and so always finishes) in full screen.
        destination.modalPresentationStyle = .fullScreen
        destination.transitioningDelegate = slideAnimation

        if let detail = destination as? CustomizeObjectVC, let skin = sender as? CharacterSkin {
            detail.skin = skin
        }
    }

    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}
