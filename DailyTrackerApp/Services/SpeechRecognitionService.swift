import Speech
import AVFoundation
import Foundation

class SpeechRecognitionService: ObservableObject {
    @Published var transcription: String = ""
    @Published var isAuthorized = false
    @Published var isRecognizing = false
    
    private let speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    init() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        requestAuthorization()
    }
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            DispatchQueue.main.async {
                self?.isAuthorized = authStatus == .authorized
            }
        }
    }
    
    func transcribeAudioFile(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            completion(.failure(SpeechError.recognizerUnavailable))
            return
        }
        
        guard isAuthorized else {
            completion(.failure(SpeechError.notAuthorized))
            return
        }
        
        let request = SFSpeechURLRecognitionRequest(url: url)
        request.shouldReportPartialResults = false
        
        recognitionTask = recognizer.recognitionTask(with: request) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let result = result {
                completion(.success(result.bestTranscription.formattedString))
            }
        }
    }
    
    func startLiveTranscription() throws {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            throw SpeechError.recognizerUnavailable
        }
        
        guard isAuthorized else {
            throw SpeechError.notAuthorized
        }
        
        recognitionTask?.cancel()
        recognitionTask = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            throw SpeechError.unableToCreateRequest
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        isRecognizing = true
        
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self = self else { return }
            
            if let result = result {
                DispatchQueue.main.async {
                    self.transcription = result.bestTranscription.formattedString
                }
                
                if result.isFinal {
                    self.stopLiveTranscription()
                }
            }
            
            if let error = error {
                print("Recognition error: \(error.localizedDescription)")
                self.stopLiveTranscription()
            }
        }
    }
    
    func stopLiveTranscription() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        isRecognizing = false
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
    }
    
    enum SpeechError: LocalizedError {
        case recognizerUnavailable
        case notAuthorized
        case unableToCreateRequest
        
        var errorDescription: String? {
            switch self {
            case .recognizerUnavailable:
                return "Speech recognizer is not available"
            case .notAuthorized:
                return "Speech recognition not authorized"
            case .unableToCreateRequest:
                return "Unable to create recognition request"
            }
        }
    }
}

