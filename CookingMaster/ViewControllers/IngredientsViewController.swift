//
//  IngredientsViewController.swift
//  CookingMaster
//
//  Created by Victor on 1/21/21.
//

import UIKit
import Speech
import AVKit


class IngredientsViewController: UIViewController {

    var recipes = [RecipeByIngredients]()
    var searchByChosenIngredientsButton = UIButton(type: .system)
    var searchByVoiceButton = UIButton(type: .system)
    var ingredients = ["strawberry", "cheese"]
    
    var voiceButton = UIButton(type: .system)
    var recognizedTextLabel = UILabel()
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask : SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.record, mode: .measurement, options: .defaultToSpeaker)
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//        } catch {
//            print("audioSession properties cannot be set")
//        }
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        
        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                self.recognizedTextLabel.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.voiceButton.isEnabled = true
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        self.recognizedTextLabel.text = "Say something about food!"
        
    }
    
    func setupSpeech() {
        self.voiceButton.isEnabled = false
        self.speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            @unknown default:
                isButtonEnabled = false
            }
            
            OperationQueue.main.addOperation() {
                self.voiceButton.isEnabled = isButtonEnabled
            }
        }
    }
    
    func getRecipes() {
        FoodAPI.shared.getRecipesByIngredient(ingredients: self.ingredients) { (data, error) in
            guard let data = data else  { return }
            
            do {
                let getRecipes = try JSONDecoder().decode([RecipeByIngredients].self, from: data)
                
                DispatchQueue.main.async {
                    self.recipes = getRecipes
                    print(self.recipes)
                    SharedRecipes.sharedInstance.recipes = getRecipes
                    self.tabBarController?.selectedIndex = 1
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        view.addSubview(searchByChosenIngredientsButton)
        searchByChosenIngredientsButton.translatesAutoresizingMaskIntoConstraints = false
        searchByChosenIngredientsButton.setTitle("SearchByChosenIngredients", for: .normal)
        view.addConstraints([
            searchByChosenIngredientsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchByChosenIngredientsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.addSubview(voiceButton)
        voiceButton.translatesAutoresizingMaskIntoConstraints = false
        voiceButton.setTitle("Start recording", for: .normal)
        view.addConstraints([
            voiceButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            voiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(recognizedTextLabel)
        recognizedTextLabel.translatesAutoresizingMaskIntoConstraints = false
        recognizedTextLabel.text = ""
        view.addConstraints([
            recognizedTextLabel.topAnchor.constraint(equalTo: voiceButton.bottomAnchor, constant: 20),
            recognizedTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(searchByVoiceButton)
        searchByVoiceButton.translatesAutoresizingMaskIntoConstraints = false
        searchByVoiceButton.setTitle("SearchByVoice", for: .normal)
        view.addConstraints([
            searchByVoiceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchByVoiceButton.topAnchor.constraint(equalTo: recognizedTextLabel.bottomAnchor, constant: 30)
        ])
        
        
        
        self.setupSpeech()
        
        
        voiceButton.addAction(for: .touchUpInside) { (voiceButton) in
            if self.audioEngine.isRunning {
                self.audioEngine.stop()
                self.recognitionRequest?.endAudio()
                self.voiceButton.setTitle("Start recording", for: .normal)
            } else {
                self.startRecording()
                self.voiceButton.setTitle("Stop recording", for: .normal)
            }
        }
        
        searchByVoiceButton.addAction(for: .touchUpInside) { (searchByVoiceButton) in
            guard let recognizedText = self.recognizedTextLabel.text else { return }
            
            FoodAPI.shared.getIngredientsFromString(stringToRecognize: recognizedText) { (data, error) in
                guard let data = data else  { return }

                do {
                    let getIngredients = try JSONDecoder().decode(FoodInText.self, from: data)
                    print(getIngredients)
                    DispatchQueue.main.async {
                        var arr = [String]()
                        for ingredient in getIngredients.annotations {
                            arr.append(ingredient.annotation)
                        }
                        self.ingredients = arr
                        print(self.ingredients)
                        self.getRecipes()
                    }
                }
                catch {
                    print(error)
                }
            }
        }
        
        searchByChosenIngredientsButton.addAction(for: .touchUpInside) { (searchButton) in
            self.getRecipes()
        }
        
        
    }


}

extension IngredientsViewController: SFSpeechRecognizerDelegate {

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.voiceButton.isEnabled = true
        } else {
            self.voiceButton.isEnabled = false
        }
    }
}


