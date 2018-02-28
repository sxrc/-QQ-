//
//  QQDetialVC.swift
//  QQ音乐
//
//  Created by rc on 2017/4/22.
//  Copyright © 2017年 rc. All rights reserved.
//

import UIKit

class QQDetialVC: UIViewController {

    // 歌词View
    @IBOutlet weak var lrcView: UIView!
    
    
    // 歌词背景scrollView
    @IBOutlet weak var lrcScrollerView: UIScrollView!

    
    // 前景图片  1
    @IBOutlet weak var foreimageView: UIImageView!
    // 背景图片 1
    @IBOutlet weak var backImageView: UIImageView!
    // 歌曲名字 1
    @IBOutlet weak var songNameLabel: UILabel!
    // 歌手名字 1
    @IBOutlet weak var singerNameLabel: UILabel!
    // 播放总时长 1
    @IBOutlet weak var totalTimesLabel: UILabel!
    
    // 歌词的视图 1
    lazy var lrcVC: QQLrcTVC = {
        
        return QQLrcTVC()
        
    }()

    // 已经播放时长 n
    @IBOutlet weak var costTimeLabel: UILabel!
    // 歌词   n
    @IBOutlet weak var lrcLabel: QQLrcLabel!
    // 进度条  n
    @IBOutlet weak var progressSlider: UISlider!
    // 开始暂停按钮
    @IBOutlet weak var pauseOrStartBtn: UIButton!
    
    var timer: Timer?
    var displayLink: CADisplayLink?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// 业务逻辑
extension QQDetialVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置进度条
        setSlider()
        
        // 添加歌词视图
        addLrcView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(nextMusic(_:)), name: NSNotification.Name(rawValue: kPlayFinishNotification), object: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super .viewWillAppear(true)
        
        // 只需要更新一次界面
        setUpOnce()
        
        // 触发需要多次界面更新的方法
        addTimer()
        addLink()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(true)
        
        removeTimer()
        removeLink()
    }
    
    // 添加定时器
    func addTimer() -> () {
//        updateLrc()
        timer = Timer(timeInterval: 1, target: self, selector: #selector(setUptimes), userInfo: nil, repeats: true)
        RunLoop.current .add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    // 移除定时器
    func removeTimer() -> () {
        
        timer?.invalidate()
        timer = nil
    }

    func addLink() -> () {
        
        displayLink = CADisplayLink(target: self, selector: #selector(updateLrc))
        displayLink?.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    func removeLink() -> () {
        
        displayLink?.invalidate()
        displayLink = nil
    }
    
    // 更新歌词
    func updateLrc() -> () {
        
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        
        let time = musicMessageM.costTime
        
        let lrcMs = lrcVC.lrcMs
        
        let rowLrcM = QQMusicDataTool.getCurrentLrcM(currentTime: time, lrcMs: lrcMs)
        
        
        let lrcM = rowLrcM.lrcM
        
        // 赋值
        lrcLabel.text = lrcM.lrcContent
        
        // 进度
        let time1 = time - lrcM.beginTime
        let time2 = lrcM.endTime - lrcM.beginTime
        
        lrcLabel.radio = CGFloat(time1 / time2)
        
        lrcVC.progress = lrcLabel.radio
        
        // 滚动歌词
        let row = rowLrcM.row
        
        lrcVC.scrollRow = row
        
        
        // 设置锁屏信息
        if UIApplication.shared.applicationState == .background{
            
            QQMusicOperationTool.shareInstance.setupLockMessage()
        }
        
    }

    override func viewWillLayoutSubviews() {
        
        super .viewWillLayoutSubviews()
        setUpForeImageView()
        
        setLrcViewFrame()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 返回
    @IBAction func back() {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        
        let point = sender.location(in: sender.view)
        
        let x = point.x
        
        let value = x / (sender.view?.width)!
        
        progressSlider.value = Float(value)
        
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        let totalTime = musicMessageM.totalTime
        
        let costTime = totalTime * TimeInterval(value)
        
        QQMusicOperationTool.shareInstance.seekToTime(time: costTime)
    }
    
    // 抬起手指，移除定时器
    @IBAction func touchDown() {
        
        removeTimer()
    }

    // 点击进度条，添加定时器
    @IBAction func touchUp() {
        
        addTimer()
        
        let value = progressSlider.value
        
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        let totalTime = musicMessageM.totalTime
        
        let costTime = totalTime * TimeInterval(value)
        
            
            // 设置歌曲播放到对应的时间点
            QQMusicOperationTool.shareInstance.seekToTime(time: costTime)
    }
    
    @IBAction func valueChange() {
        let value = progressSlider.value
        
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        let totalTime = musicMessageM.totalTime
        let costTime = totalTime * TimeInterval(value)
        
        let timeStr = QQTimeTool.getFormatTime(timeInterval: costTime)
        
        costTimeLabel.text = timeStr
    }

    // 上一首
    @IBAction func preMusic(_ sender: UIButton) {
        
        QQMusicOperationTool.shareInstance.preMusic()
        setUpOnce()
        
    }
    // 暂停开始操作
    @IBAction func playOrPause(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        sender.isSelected ? QQMusicOperationTool.shareInstance.playCurrentMusic() : QQMusicOperationTool.shareInstance.pauseCurrentMusic()
        sender.isSelected ? resumeRotationAnimation() : pauseRotationAnimation()
    }
    // 下一首
    @IBAction func nextMusic(_ sender: UIButton) {
        
        QQMusicOperationTool.shareInstance.nextMusic()
        setUpOnce()
    }
    
    func setUpOnce() -> () {
        
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        guard let musicM = musicMessageM.musicM else {
            return
        }
        
        if musicM.icon != nil  {
            
            backImageView.image = UIImage(named:musicM.icon!)
            foreimageView.image = UIImage(named: musicM.icon!)
        }
        
        songNameLabel.text = musicM.name
        singerNameLabel.text = musicM.singer
        totalTimesLabel.text = QQTimeTool.getFormatTime(timeInterval: musicMessageM.totalTime)
        
        // 添加歌词
        let lrcMs = QQMusicDataTool.getLrcMs(lrcName: musicM.lrcname!)
        lrcVC.lrcMs = lrcMs
        
        // 添加旋转动画
        addRotationAnimation()
        
        musicMessageM.isPlaying ? resumeRotationAnimation() : pauseRotationAnimation()
    }
    
    func setUptimes() -> () {
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        
        //        lrcLabel.text = nil
        progressSlider.value = Float(musicMessageM.costTime / musicMessageM.totalTime)
        
//        print(progressSlider.value)
        costTimeLabel.text = QQTimeTool.getFormatTime(timeInterval: musicMessageM.costTime)
        
        pauseOrStartBtn.isSelected = musicMessageM.isPlaying
        
    }
    
}

// 界面操作
extension QQDetialVC {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUpForeImageView() -> () {
        foreimageView.layer.cornerRadius = foreimageView.width * 0.5
        foreimageView.layer.masksToBounds = true
    }
    
    func setSlider() -> () {
        
    progressSlider.setThumbImage(UIImage(named:"player_slider_playback_thumb"), for: UIControlState.normal)
    }
    
    // 添加歌词视图
    func addLrcView() -> () {
        lrcView.addSubview(lrcVC.tableView)
    }
    
    // 调整歌词视图frame
    func setLrcViewFrame() -> () {
        lrcVC.tableView.frame = lrcView.bounds
    }
}

extension QQDetialVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let x = scrollView.contentOffset.x
        let radio = 1 - x / scrollView.width
        
        foreimageView.alpha = radio
        lrcLabel.alpha = foreimageView.alpha
        
    }
    

    // 添加动画 CPU暴增
    // 添加旋转动画
    func addRotationAnimation() {
        
        foreimageView.layer.removeAllAnimations()
        let anmiation = CABasicAnimation(keyPath: "transform.rotation")
        anmiation.fromValue = 0
        anmiation.toValue = Double.pi * 2
        anmiation.duration = 30
        anmiation.repeatCount = MAXFLOAT
        
        anmiation.isRemovedOnCompletion = false
        foreimageView.layer.add(anmiation, forKey: "rotation")
    }
    
    // 暂停旋转动画
    func pauseRotationAnimation() {
        
        foreimageView.layer.pauseAnimate()
    }
    
    // 继续旋转动画
    func resumeRotationAnimation() {
        
        foreimageView.layer.resumeAnimate()
    }
}

extension QQDetialVC {
    
    override func remoteControlReceived(with event: UIEvent?) {
        
        let type = event?.subtype
        
        switch type! {
        case .remoteControlPlay:
            print("播放")
            QQMusicOperationTool.shareInstance.playCurrentMusic()
        case .remoteControlPause:
            print("暂停")
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
        case .remoteControlNextTrack:
            print("下一首")
            QQMusicOperationTool.shareInstance.nextMusic()
        case .remoteControlPreviousTrack:
            print("上一首")
            QQMusicOperationTool.shareInstance.preMusic()
        default:
            print("nnnnn")
        }
        
        setUpOnce()
    }
    
    // 摇一摇切歌
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        QQMusicOperationTool.shareInstance.nextMusic()
        
        setUpOnce()
    }
}
