//
//  ViewController.swift
//  TrumpVsKimBattle
//
//  Created by Dharma Kshetri on 8/16/17.
//  Copyright © 2017 Dharma Kshetri. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,GADBannerViewDelegate{
    
    var soundPlayer: AVAudioPlayer?
    var elapsedTime: TimeInterval = 0
    
    @IBOutlet weak var p1Icon: UIImageView!
    @IBOutlet weak var p2Icon: UIImageView!
    
    // Switch for multi-player or single player
    @IBOutlet weak var multiPlayerSwitch: UISwitch!
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var gridButtons: [UIButton]!
    
    @IBOutlet weak var p1ScoreLabel: UILabel!
    @IBOutlet weak var p2ScoreLabel: UILabel!
    
    @IBOutlet weak var winnerLabel: UILabel!
    
    // Declaring symbols for the game
    var imgtrump = UIImage(named: "trump")
    var imgkim = UIImage(named: "kim")
    
    // Default 9 buttons of the grid
    var grid = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
    
    var currentPlayer : Int = 1
    
    @IBOutlet var btnTrump: UIButton!
    @IBOutlet var btnKim: UIButton!
    
    // Current score
    var p1Score : Int = 0
    var p2Score : Int = 0
    
    //ad mob
    @IBOutlet weak var myAdMob: GADBannerView!
    
   
    // Start game function
    func start(){
        grid = [[0, 0, 0] , [0, 0, 0], [0, 0, 0]]
        
        // All buttons are empty when the game starts
        for button in gridButtons{
            button.setImage(nil, for: .normal)
        }
        
        currentPlayer = 1
    }
    // Choosing trump image to play as trump
    @IBAction func btnT(_ sender: UIButton) {
       currentPlayer = 1
        p1ScoreLabel.backgroundColor=UIColor.black
        p2ScoreLabel.backgroundColor=UIColor.white
    }
    
    
     // Choosing kim image to play as kim
    @IBAction func btnK(_ sender: UIButton) {
        currentPlayer = 2
        p1ScoreLabel.backgroundColor=UIColor.white
        p2ScoreLabel.backgroundColor=UIColor.black
    }
   
   
    
    // When pressing one of the buttons to play the game
    @IBAction func cellSelected(_ sender: UIButton) {
        
        let rowIndex = sender.tag / 3
        let colIndex = sender.tag % 3
        
        if grid[rowIndex][colIndex] != 0 {return}
        
        // Get to know which player press on which cell
        grid[rowIndex][colIndex] = currentPlayer
        
        // Set cross symbol for trump
        if currentPlayer == 1 {
            sender.setImage(imgtrump, for: .normal)
        }
            // Set nought symbol for kim
        else if currentPlayer == 2 {
            sender.setImage(imgkim, for: .normal)
        }
        
        // Get result from winlose function to variable winner
        let winner = winlose()
         print("winner \(winner)")
        // Check who is the winner
        switch winner {
        case 0:
            currentPlayer = (currentPlayer % 2) + 1
              print("Draw")
           
        case 1:
            // Winner label for trump
            winnerLabel.text = "Trump won the battle!"
            // Alert message for trump
            alertWinner(playerName: "TRUMP")

        case 2:
            alertWinner(playerName: "KIM")
           // historyTextView.insertText("\nKim's result: \(p2Score)")
        default:
            winnerLabel.text = "\(winner) is not matched"
        }
        
        // AI mode to check if single player mode is enabled
        if multiPlayerSwitch.isOn == false{
            let (cellIndex, gridRowIndex, gridColIndex, p2Win) = whereToPlay()
            
            // Set symbol for kim
            gridButtons[cellIndex].setImage(imgkim, for: .normal)
            
            // Set the grid to value 2
            grid[gridRowIndex][gridColIndex] = 2
            
            // Show alert if kim wins
            if p2Win == true {
                alertWinner(playerName: "KIM")
            }
            
            // Otherwise, player 1 can now play the game
            currentPlayer = 1
        }
    }
    
    // Check if turmp or kim wins the match
    // 1 is trump wins, 2 is kim wins or 0 is no players win at all
    func winlose() -> Int {
        
        // First row
        if grid[0][0] != 0 && grid[0][0] == grid[0][1] && grid[0][1] == grid[0][2] {
            return grid[0][0]
        }
        
        // Second row
        if grid[1][0] != 0 && grid[1][0] == grid[1][1] && grid[1][1] == grid[1][2] {
            return grid[1][0]
        }
        
        // Third row
        if grid[2][0] != 0 && grid[2][0] == grid[2][1] && grid[2][1] == grid[2][2] {
            return grid[2][0]
        }
        
        // First column
        if grid[0][0] != 0 && grid[0][0] == grid[1][0] && grid[1][0] == grid[2][0] {
            return grid[0][0]
        }
        
        // Second column
        if grid[0][1] != 0 && grid[0][1] == grid[1][1] && grid[1][1] == grid[2][1] {
            return grid[0][1]
        }
        
        // Third column
        if grid[0][2] != 0 && grid[0][2] == grid[1][2] && grid[1][2] == grid[2][2] {
            return grid[2][2]
        }
        
        // Top right to bottom left
        if grid[0][2] != 0 && grid[0][2] == grid [1][1] && grid[1][1] == grid[2][0] {
            return grid[2][0]
        }
        
        // Top left to bottom right
        if grid[0][0] != 0 && grid[0][0] == grid[1][1] && grid[1][1] == grid[2][2]{
            return grid[2][2]
        }
        return 0
    }
    
    
    // Alert message shows who won the game
    func alertWinner(playerName : String){
        let alertController = UIAlertController(title: "Hurry!!!", message: "\(playerName) Won!", preferredStyle: .alert)
        print("winner:\(playerName)")
        // When there is a winner, the grid will start as new game
        let okAction = UIAlertAction(title: "Ok", style: .default){
            (action) -> Void in self.start()
            if playerName=="TRUMP" {
                self.winnerLabel.text = "Trump won the battle!"
                self.p1Score += 1
                self.p1ScoreLabel.text = "Score: \(self.p1Score)"
            }else if playerName=="KIM"{
                self.winnerLabel.text = "Kim won the battle!"
                self.p2Score += 1
                self.p2ScoreLabel.text = "Score: \(self.p2Score)"
            }
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // When single player mode is on
    func whereToPlay() -> (Int, Int, Int, Bool){
        var index = -1
        var draw = 0
        var gridRowIndex = 0
        var gridColIndex = 0
        
        for row in 0 ... 2 {
            for col in 0 ... 2 {
                index = index + 1
                
                // Check when none of the players have played the game
                if grid[row][col] == 0
                {
                    
                    // Set the cell to 2
                    grid[row][col] = 2
                    
                    // Get the result from winlose function
                    var i = winlose()
                    
                    // If the value is actually 2, kim wins the game
                    if i == 2
                    {
                        return (index, row, col, true)
                    }
                    
                    // Check if the winner is trupmp
                    grid[row][col] = 1
                    i = winlose()
                    
                    // If so, this means kim did not win the match by returning the flag as false
                    if i == 1
                    {
                        return (index, row, col, false)
                    }
                    
                    // When no one wins and other cells are available, player can still play the game
                    draw = index
                    gridRowIndex = row
                    gridColIndex = col
                    
                    // Set the cell to empty
                    grid[row][col] = 0
                }
            }
        }
        
        // No winner then return as false
        return (draw, gridRowIndex, gridColIndex, false)
    }
    
    // Reset game button
    @IBAction func btnReset(_ sender: UIButton) {
        start()
    }
    
    @IBAction func btnClear(_ sender: UIButton) {
        p1ScoreLabel.text = "Score: \(0)"
        p2ScoreLabel.text = "Score: \(0)"
    }
    // Play or resume music button
    @IBAction func btnPlay(_ sender: UIButton) {
        if soundPlayer != nil{
            soundPlayer!.currentTime = elapsedTime
            soundPlayer!.play()
        }
    }
    
    // Pause music button
    @IBAction func btnPause(_ sender: UIButton) {
        if soundPlayer != nil{
            elapsedTime = soundPlayer!.currentTime
            soundPlayer!.pause()
        }
    }
    
    // Stop music button
    @IBAction func btnStop(_ sender: UIButton) {
        if soundPlayer != nil{
        soundPlayer!.stop()
            elapsedTime = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create request
        let request=GADRequest()
        request.testDevices=[kGADSimulatorID]
        
        //set up ad
        myAdMob.adUnitID="ca-app-pub-2457197007328169/2366923833"
        myAdMob.rootViewController=self
        myAdMob.delegate=self
        
        myAdMob.load(request)
   
        imagePicker.delegate = self
        // URL of the Song name and type
        let path = Bundle.main.path(forResource: "usavskorea", ofType: "mp3")
        let url = URL(fileURLWithPath: path!)
        do {
            // set up the player by loading the sound file
            try soundPlayer = AVAudioPlayer(contentsOf: url)
        }
        catch {
            print(error)
        }
    }
}


