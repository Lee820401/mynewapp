//
//  vedio.swift
//  mynewapp
//
//  Created by MISLab on 2018/3/7.
//  Copyright © 2018年 MISLab. All rights reserved.
//
import UIKit
import AVFoundation
import Photos
//检查授权
class video:UIViewController,UIGestureRecognizerDelegate,AVCaptureFileOutputRecordingDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate {
    var captureSession: AVCaptureSession?
    var captureDevice: AVCaptureDevice?
    var captureInput: AVCaptureDeviceInput?
    var captureMovieFileOutput: AVCaptureMovieFileOutput?
    var captureVideoDataOutput: AVCaptureVideoDataOutput?
    var captureAudioDataOutput: AVCaptureAudioDataOutput?
    
    var preview: UIView?
    var tapButton: UIButton?
    var previewLayer: AVCaptureVideoPreviewLayer?
    lazy var sessionQueue: DispatchQueue = {
        let queue = DispatchQueue(label: "com.xiaovv.iOSUseCamera")
        return queue
    }()
    var assetWriter: AVAssetWriter?
    var assetWriterVideoInput: AVAssetWriterInput?
    var assetWriterAudioInput: AVAssetWriterInput?
    var videoUrl: URL?
    override func viewDidDisappear(_ animated: Bool) {
        if (captureSession?.isRunning)! {
            captureSession?.stopRunning()
        }
    }
    
    func checkAuthorization()  {
        
        /**
         AVAuthorizationStatus NotDetermined // 未进行授权选择
         AVAuthorizationStatus Restricted // 未授权，且用户无法更新，如家长控制情况下
         AVAuthorizationStatus Denied // 用户拒绝App使用
         AVAuthorizationStatus Authorized // 已授权，可使用
         */
        
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized: // 已授权，可使用
            self.configureCaptureSession()
            
        case .notDetermined://进行授权选择
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {
                    self.configureCaptureSession()
                }else {
                    let alert = UIAlertController(title: "提示", message: "用户拒绝授权使用相机", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        default: //用户拒绝和未授权
            
            let alert = UIAlertController(title: "提示", message: "用户拒绝授权使用相机", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "确定", style: .default, handler: nil)
            
            alert.addAction(alertAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }

    // 配置会话对象
    func configureCaptureSession() {
        captureSession = AVCaptureSession()
        captureSession?.beginConfiguration()
        
        // CaptureSession 的会话预设,这个地方设置的模式/分辨率大小将影响你后面拍摄照片/视频的大小
        captureSession?.sessionPreset = AVCaptureSession.Preset.high
        
        // 添加输入
        do {
            let cameraDeviceInput = try AVCaptureDeviceInput(device: self.cameraWithPosition(.front)!)
            
            if (captureSession?.canAddInput(cameraDeviceInput))! {
                captureSession?.addInput(cameraDeviceInput)
                captureInput = cameraDeviceInput
            }
            let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)
            let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice!)
            if (captureSession?.canAddInput(audioDeviceInput))! {
                captureSession?.addInput(audioDeviceInput)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        // 添加输出
        // 本文 iOS 10 以后 相机的照片输出和视频输出使用 AVCaptureVideoDataOutput
        if #available(iOS 10.0, *) {
            // 添加 AVCaptureVideoDataOutput 用于输出视频
            let captureVideoDataOutput = AVCaptureVideoDataOutput()
            if (captureSession?.canAddOutput(captureVideoDataOutput))! {
                captureSession?.addOutput(captureVideoDataOutput)
            }
            self.captureVideoDataOutput = captureVideoDataOutput
            // 添加 AVCaptureAudioDataOutput 用于输出音频
            
            let captureAudioDataOutput = AVCaptureAudioDataOutput()
            
            if (captureSession?.canAddOutput(captureAudioDataOutput))! {
                
                captureSession?.addOutput(captureAudioDataOutput)
            }
            
            self.captureAudioDataOutput = captureAudioDataOutput
            
            captureVideoDataOutput.setSampleBufferDelegate(self, queue: sessionQueue)
            
            //captureAudioDataOutput.setSampleBufferDelegate(self, queue: sessionQueue)
            
        } else {
            // iOS 10 以后 相机视频输出使用 AVCaptureMovieFileOutput
            captureMovieFileOutput = AVCaptureMovieFileOutput()
            if (captureSession?.canAddOutput(captureMovieFileOutput!))! {
                captureSession?.addOutput(captureMovieFileOutput!)
            }
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession!)
        //previewLayer?.frame = (self.preview?.bounds)!
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        //预览图层和视频方向保持一致
        if #available(iOS 10.0, *) {
            captureVideoDataOutput?.connection(with: AVMediaType.video)?.videoOrientation = (previewLayer?.connection?.videoOrientation)!
            
        } else {
            captureMovieFileOutput?.connection(with: AVMediaType.video)?.videoOrientation = (previewLayer?.connection?.videoOrientation)!
        }
        
        preview?.layer.insertSublayer(self.previewLayer!, at: 0)
        captureSession?.commitConfiguration()
        self.sessionQueue.async {
            
            self.captureSession?.startRunning()
        }
        
    }

    func configureAssetWriter() {
        
        // 设置 AVAssetWriter 的视频输入设置
        let videoSettings = [AVVideoCodecKey: AVVideoCodecH264,
                             AVVideoWidthKey: 720,
                             AVVideoHeightKey: 1280] as [String : Any];
        
        let assetWriterVideoInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoSettings)
        assetWriterVideoInput.expectsMediaDataInRealTime = true
        
        self.assetWriterVideoInput = assetWriterVideoInput
        
        // 设置 AVAssetWriter 的音频输入设置
        
        let audioSettings = [AVFormatIDKey: kAudioFormatMPEG4AAC,
                             AVSampleRateKey: NSNumber(value: 44100.0),
                             AVNumberOfChannelsKey: NSNumber(value: 2)] as [String : Any]
        
        let assetWriterAudioInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: audioSettings)
        assetWriterAudioInput.expectsMediaDataInRealTime = true
        
        self.assetWriterAudioInput = assetWriterAudioInput
        
        let d1 = Date()
        let formater = DateFormatter()
        formater.dateFormat = "MM_dd_hh_mm_ss"
        let str1 = formater.string(from: d1)+"qqqqq"
        
        let videoUrlStr = NSTemporaryDirectory() + "tempVideo.mp4"
        
        let videoUrl = URL(fileURLWithPath: videoUrlStr)
        
        self.videoUrl = videoUrl
        
        do {
            
            
            try FileManager.default.removeItem(at: videoUrl)
            
        } catch {
            
            print(error.localizedDescription)
        }
        
        do {
            
            let assetWriter = try AVAssetWriter(url: videoUrl, fileType: AVFileType.mp4)
            
            print("1........assetWriter.status+++\(String(describing: assetWriter.status.rawValue))")
            
            
            if assetWriter.canAdd(assetWriterVideoInput) {
                
                assetWriter.add(assetWriterVideoInput)
            }
            
            if assetWriter.canAdd(assetWriterAudioInput) {
                
                assetWriter.add(assetWriterAudioInput)
            }
            
            self.assetWriter = assetWriter
            
            
        } catch {
            
            print(error)
        }
    }

    @objc func recordVideo() {//button: UIButton
        
        // button.isSelected = !button.isSelected
        
        if #available(iOS 10.0, *) { // iOS 10 这里 使用 AVAssetWriter 保存视频
            
            print("2.........assetWriter.status+++\(String(describing: self.assetWriter?.status.rawValue))")
            
            if let assetWriter = self.assetWriter,assetWriter.status == .writing {// 正在录制，保存
                print("end/n")
                if let videoWriterInput = self.assetWriterVideoInput {
                    
                    videoWriterInput.markAsFinished()
                }
                
                assetWriter.finishWriting(completionHandler: {
                    
                    // 视频已经完成写入到指定的路径
                    // 可以把视频保存到相册或者保存到APP的沙盒
                    if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(assetWriter.outputURL.path) {
                        
                        DispatchQueue.global().async {
                            
                            UISaveVideoAtPathToSavedPhotosAlbum(assetWriter.outputURL.path, self, #selector(self.video(_ :didFinishSavingWithError:contextInfo:)), nil)
                            self.assetWriter = nil
                        }
                    }
                    
                })
                
            }else {// 开始录制视频
                print("start/n")
                configureAssetWriter()
                
                captureVideoDataOutput?.setSampleBufferDelegate(self, queue: sessionQueue)
                
            }
            
        } else { // iOS 10 之前 这里 使用 AVCaptureMovieFileOutput 输出视频
            
            if (captureMovieFileOutput?.isRecording)! {//判断当前是否已经在录制视频
                
                captureMovieFileOutput?.stopRecording()
                
            }else {
                let d1 = Date()
                let formater = DateFormatter()
                formater.dateFormat = "MM_dd_hh_mm_ss"
                let str1 = formater.string(from: d1)+".mp4"
                
                let url = URL(fileURLWithPath: NSTemporaryDirectory() + str1)//"outPut.mov")
                
                captureMovieFileOutput?.startRecording(to: url, recordingDelegate: self)
            }
        }
    }


    

    func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        
        if #available(iOS 10.0, *) {
            
            let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: position).devices
            
            for device in devices {
                
                if device.position == position {
                    
                    return device
                }
            }
            
        } else {
            
            let devices = AVCaptureDevice.devices(for: AVMediaType.video)
            
            for device in devices {
                
                if device.position == position {
                    
                    print(device.formats)
                    
                    return device
                }
            }
        }
        
        return nil
        
    }


    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        // print("#function--\(#function)")
        
        objc_sync_enter(self)
        
        if let assetWriter = self.assetWriter {
            
            if assetWriter.status != .writing && assetWriter.status != .unknown {
                return
            }
        }
        
        if let assetWriter = self.assetWriter, assetWriter.status == AVAssetWriterStatus.unknown {
            
            assetWriter.startWriting()
            assetWriter.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
        }
        
        // 视频数据
        if connection == captureVideoDataOutput?.connection(with: AVMediaType.video) {
            
            let videoDataOutputQueue = DispatchQueue(label: "com.xiaovv.videoDataOutputQueue")
            
            videoDataOutputQueue.async {
                
                if let videoWriterInput = self.assetWriterVideoInput, videoWriterInput.isReadyForMoreMediaData {
                    
                    videoWriterInput.append(sampleBuffer)
                }
            }
            
        }
        
        // 音频数据
        if connection == captureAudioDataOutput?.connection(with: AVMediaType.audio) {
            
            let audioDataOutputQueue = DispatchQueue(label: "com.xiaovv.audioDataOutputQueue")
            
            audioDataOutputQueue.async {
                
                if let audioWriterInput = self.assetWriterAudioInput, audioWriterInput.isReadyForMoreMediaData {
                    
                    audioWriterInput.append(sampleBuffer)
                }
            }
        }
        
        objc_sync_exit(self)
    }

    func captureOutput(_ captureOutput: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        
    }

    // MARK: - AVCaptureFileOutputRecordingDelegate
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
        print("开始录制")
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        print("停止录制")
        
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outputFileURL.path) {//判断视频路径是否可以被保存的相册
            
            //保存视频到图库中
            DispatchQueue.global().async {
                
                UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, self, #selector(self.video(_ :didFinishSavingWithError:contextInfo:)), nil)
            }
        }
        print(outputFileURL)
    }

    // MARK: - UISaveVideoAtPathToSavedPhotosAlbum

    //UISaveVideoAtPathToSavedPhotosAlbum 保存视频之后的回调，判断视频是否保存成功，方法名必须这样写

    @objc func video(_ videoPath: String,
                     didFinishSavingWithError error: NSError?,
                     contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "警告", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "确定", style: .default))
            present(ac, animated: true)
            
        } else {
            
            let ac = UIAlertController(title: "提示", message: "视频成功保存到相册", preferredStyle: .alert)
            let sureAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
                
                self.dismiss(animated: true, completion: nil)
            })
            
            ac.addAction(sureAction)
            present(ac, animated: true)
        }
    }
}
