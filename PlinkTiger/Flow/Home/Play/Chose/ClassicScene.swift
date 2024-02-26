//
//  ClassicScene.swift
//  PlinkTiger

import SpriteKit
import GameplayKit

enum GameState {
    case home
    case pause
    case settings
}

enum RowsCount: Int {
    case eightRows = 8
    case nineRows = 9
    case tenRows = 10
}

enum Methods {
    case numberBallPlusMinus
    case betPlusMinus
}

enum RiskStatus {
    case low
    case medium
    case high
}

enum PanelName: String {
    case peg0 = "peg_0"
    case peg1 = "peg_1"
    case peg2 = "peg_2"
    case peg3 = "peg_3"
    case peg4 = "peg_4"
    case peg5 = "peg_5"
    case peg6 = "peg_6"
}

enum LabelName: String {
    case titleBetLabel = "titleBetLabel"
    case titleRowsLabel = "titleRowsLabel"
    case titleBallsNumberLabel = "titleBallsNumberLabel"
}

struct PhysicsCategory {
    static let ball: UInt32 = 0x1 << 0
    static let block: UInt32 = 0x1 << 1
    static let winPanel: UInt32 = 0x1 << 2
    static let spring: UInt32 = 0x1 << 3
    static let field: UInt32 = 0x1 << 4
    static let empty: UInt32 = 0x1 << 10
}

class ClassicScene: SKScene {
//    var userModel: UserModel = .shared
    var memory: Memory = .shared
    
    private var ball = SKSpriteNode()
    private var dropButton = CustomSKButton(texture: SKTexture(imageNamed: "throwSKBtn"))
    private var balanceLabel = SKLabelNode()
    private var meatLifeLabel = SKLabelNode()
    private var segmentArray = [SKShapeNode]()
    private var secondSegmentArray = [SKShapeNode]()
    
    private var workItem: DispatchWorkItem?
    
    
    private var popupActive: Bool = false
    public var resultTransfer: ((GameState) -> Void)?
        
    var pinsArray: [SKSpriteNode] = []
    var pegArray: [SKSpriteNode] = []
    var winPanelAnimationArray: [SKSpriteNode] = []
    var winLabeAnimationArray: [SKLabelNode] = []
    
    var pinHitAnimationArray: [SKSpriteNode] = []
    var pegLabelArray: [SKLabelNode] = []
    var pegAnimationState: [SKSpriteNode: Bool] = [:]
    
    private var betSet: [Int] = []
    private var betIndex: Int = 0 {
        didSet {
            if betIndex < 0 {
                return
            }
            bet = betSet[betIndex]
        }
    }
    
    private var bet: Int = 0 {
        didSet {
            let betLabel = findLabelNode(labelName: LabelName.titleBetLabel.rawValue)
            betLabel?.text = String("\(bet)")
        }
    }
    
    private var numbersBallSet: [Int] = []
    private var numbersBallIndex: Int = 0 {
        didSet {
            
            if betIndex < 0 {
                return
            }
            numbersBall = numbersBallSet[numbersBallIndex]
        }
    }
    
    private var numbersBall: Int = 0 {
        didSet {
            let numberBallLabel = findLabelNode(labelName: LabelName.titleBallsNumberLabel.rawValue)
            numberBallLabel?.text = String("\(numbersBall)")
        }
    }
    
    var balance: Int {
        get {
            return memory.scoreCoints
        }
        set {
            memory.scoreCoints = newValue
            balanceLabel.text = String(balance)
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupBackground()
        addSettingsScene()
        setupGameSubviews()
//        animationBall()
    }
    
    private func setupGameSubviews() {
        print("\(size.width)")
        createPlinkoBoard()
        createPegsLeft()
        createPegsRight()
        setupBackground()
        setupNavigation()
        setupBottomBar()
//        setupGameScene()
        configureGame()
//        addObserver()
    }
    
//    private func addObserver() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(updateCoinsBalance),
//                                               name: ConstantsApp.dBalanceChangedNotification,
//                                               object: nil)
//    }
    
    @objc func updateCoinsBalance() {
        balanceLabel.text = String(balance)
    }
    
    private func configureGame() {
        betSet = [1,2,3,4,5,6,7,8,9,10]
        bet = betSet[betIndex]
        
        numbersBallSet = [5,6,7,8,9,10]
        numbersBall = numbersBallSet[numbersBallIndex]
    }
    
    private func setupBackground() {
        let hpNode = SKSpriteNode(imageNamed: "bgGame")
        hpNode.anchorPoint = .init(x: 0, y: 0)
        hpNode.size = .init(width: size.width, height: size.height)
        hpNode.position = CGPoint(x: 0, y: 0)
        hpNode.zPosition = -1
        addChild(hpNode)
    }
    
    private func addSettingsScene() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.01, dy: -3.5)
    }
    
    private func setupNavigation() {
        let homeButton = CustomSKButton(texture: SKTexture(imageNamed: "btnBack"))
        homeButton.size = .init(width: 30.autoSize, height: 30.autoSize)
        homeButton.anchorPoint = .init(x: 0, y: 0)
        homeButton.position = CGPoint(x: size.width / 2 - 319 .autoSize, y: size.height / 2 + 140.autoSize)
        homeButton.zPosition = 10
        homeButton.action = { self.homeButtonAction() }
        addChild(homeButton)
        
        let balancBgNode = SKSpriteNode(imageNamed: "scoreImg")
        balancBgNode.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        balancBgNode.size = CGSize(width: 88.autoSize, height: 48.autoSize)
        balancBgNode.position = CGPoint(x: 40, y: size.height - 60)
        balancBgNode.zPosition = 10
        addChild(balancBgNode)
        
        balanceLabel = SKLabelNode(text: "\(Memory.shared.scoreCoints)")
        balanceLabel.fontName = "Lato-Bold"
        balanceLabel.fontSize = 18.autoSize
        balanceLabel.horizontalAlignmentMode = .center
        balanceLabel.lineBreakMode = .byWordWrapping
        balanceLabel.preferredMaxLayoutWidth = 65
        balanceLabel.lineBreakMode = .byWordWrapping
        if balanceLabel.frame.width > 65 {
            let scale = 65 / balanceLabel.frame.width
            balanceLabel.setScale(scale)
        }
        balanceLabel.position = CGPoint(x: balancBgNode.position.x + balancBgNode.size.width / 2, y: balancBgNode.position.y - balancBgNode.size.height / 2 - 6)
        balanceLabel.zPosition = balancBgNode.zPosition + 1
        addChild(balanceLabel)
        
        let meatBgNode = SKSpriteNode(imageNamed: "scoreImg")
        meatBgNode.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        meatBgNode.size = CGSize(width: 88.autoSize, height: 48.autoSize)
        meatBgNode.position = CGPoint(x: size.width - 40, y: size.height - 60)
        meatBgNode.zPosition = 10
        addChild(meatBgNode)

        meatLifeLabel = SKLabelNode(text: "\(Memory.shared.scoreMeat)")
        meatLifeLabel.fontName = "Lato-Medium"
        meatLifeLabel.fontSize = 18.autoSize
        meatLifeLabel.horizontalAlignmentMode = .center
        meatLifeLabel.lineBreakMode = .byWordWrapping
        meatLifeLabel.preferredMaxLayoutWidth = 65
        meatLifeLabel.lineBreakMode = .byWordWrapping
        if meatLifeLabel.frame.width > 65 {
            let scale = 65 / meatLifeLabel.frame.width
            meatLifeLabel.setScale(scale)
        }
        meatLifeLabel.position = CGPoint(x: meatBgNode.position.x - meatBgNode.size.width / 2 + 15, y: meatBgNode.position.y - meatBgNode.size.height / 2 - 6)
        meatLifeLabel.zPosition = meatBgNode.zPosition + 1
        addChild(meatLifeLabel)
        let meatImageNode = SKSpriteNode(imageNamed: "meatImg")
        meatImageNode.size = CGSize(width: 24, height: 24)
        meatImageNode.position = CGPoint(x: -meatBgNode.size.width / 2 - 15, y: meatBgNode.size.height / 2 - 50)
        meatImageNode.zPosition = meatBgNode.zPosition + 1
        meatBgNode.addChild(meatImageNode)

    }

    private func setupBottomBar() {
        dropButton.size = .init(width: 340.autoSize, height: 48.autoSize)
        dropButton.anchorPoint = .init(x: 0.5, y: 0.5)
        dropButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 240)
        dropButton.action = { self.dropButtonButtonAction() }
        addChild(dropButton)
    }
    
    //GameScene
    
    func setupGameScene() {
        let gameFieldNode = SKSpriteNode(imageNamed: "img_field_border_1")
        gameFieldNode.size = .init(width: 315.autoSize, height: 240.autoSize)
        gameFieldNode.position = CGPoint(x: size.width / 2, y: size.height / 2 + 5.autoSize)
        gameFieldNode.physicsBody = .init(texture: gameFieldNode.texture!, size: gameFieldNode.size)
        gameFieldNode.physicsBody?.categoryBitMask = PhysicsCategory.field
        gameFieldNode.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        gameFieldNode.physicsBody?.collisionBitMask = PhysicsCategory.ball
        gameFieldNode.physicsBody?.isDynamic = false
        gameFieldNode.zPosition = 10
        addChild(gameFieldNode)
        
        let gameFieldbg = SKSpriteNode(imageNamed: "img_field")
        gameFieldbg.size = .init(width: 315.autoSize, height: 240.autoSize)
        gameFieldbg.position = CGPoint(x: size.width / 2, y: size.height / 2 + 5.autoSize)
        gameFieldbg.zPosition = 9
        addChild(gameFieldbg)
        
        let stub = SKSpriteNode()
        stub.color = .white
        stub.size = .init(width: 5.autoSize, height: 4.autoSize)
        stub.position = CGPoint(x: size.width / 2, y: size.height / 2 + 123.autoSize)
        stub.zPosition = 11
        addChild(stub)
        
        let gameContainerdNode = SKSpriteNode(imageNamed: "img_container")
        gameContainerdNode.size = .init(width: 79.autoSize, height: 63.autoSize)
        gameContainerdNode.position = CGPoint(x: size.width / 2, y: size.height / 2 + 140.autoSize)
        gameContainerdNode.zPosition = 5
        addChild(gameContainerdNode)
        
    }
    
    func setupWinPanelAnimation(position: CGPoint) -> SKSpriteNode {
        let position = CGPoint(x: position.x, y: position.y + 9)
        let winPanel = SKSpriteNode(imageNamed: "img_ball_win")
        winPanel.size = .init(width: 20.autoSize, height: 20.autoSize)
        winPanel.position = position
        winPanel.zPosition = 12
        winPanel.name = "winPanel"
        winPanelAnimationArray.append(winPanel)
        addChild(winPanel)
        return winPanel
    }
    
    func setupWinLabelAnimation(text: String) -> SKLabelNode {
        let winLabe = SKLabelNode(text: "\(text)")
        winLabe.fontName = "JosefinSans-Bold"
        winLabe.fontSize = 20
        winLabe.position = CGPoint(x: size.width / 2 + 190, y: size.height / 2 - 90)
        winLabe.zPosition = 12
        winLabeAnimationArray.append(winLabe)
        addChild(winLabe)
        return winLabe
    }
    
    func setupPinHitAnimation(position: CGPoint) -> SKSpriteNode {
        let position = CGPoint(x: position.x, y: position.y)
        let pinHit = SKSpriteNode(imageNamed: "img_ball_hit")
        pinHit.size = .init(width: 14.autoSize, height: 14.autoSize)
        pinHit.position = position
        pinHit.zPosition = 15
        pinHit.name = "pinHit"
        pinHitAnimationArray.append(pinHit)
        addChild(pinHit)
        return pinHit
    }
    
    func setupBall(positionBall: CGPoint) {
        //            let ballName = UserModel.shared.selectedBall
        ball = SKSpriteNode(imageNamed: "balImg")
        ball.anchorPoint = .init(x: 0.5, y: 0.5)
        ball.size = .init(width: 15.autoSize, height: 15.autoSize)
        ball.position = positionBall
        ball.physicsBody = .init(circleOfRadius: 4.autoSize)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ball
        ball.physicsBody?.collisionBitMask = PhysicsCategory.block | PhysicsCategory.winPanel | PhysicsCategory.field
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.winPanel | PhysicsCategory.field
        ball.physicsBody?.mass = 1.4
        ball.physicsBody?.restitution = 0.2
        ball.zPosition = 11
        ball.name = "ball"
        addChild(ball)
    }
    
    func createPlinkoBoard() {
        let numberOfRows: Int
        let pinSize: CGFloat
        
        let startX: CGFloat
        let startY: CGFloat
        let spacingX: CGFloat
        let spacingY: CGFloat
            numberOfRows = 8
            pinSize = 12
            startX = size.width / 2
            startY = size.height - 120
            spacingX = 40
            spacingY = 40
        
        for row in 0..<numberOfRows {
            let numberOfColumns = 1 + row
            let startColumnX = startX + CGFloat(numberOfColumns - 1) * spacingX / 2
            for col in 0..<numberOfColumns {
                let x = startColumnX - CGFloat(col) * spacingX
                let y = startY - CGFloat(row) * spacingY
                
                let pin = SKSpriteNode(imageNamed: "pegImg")
                pin.position = CGPoint(x: x, y: y)
                pin.size = .init(width: pinSize, height: pinSize)
                pin.physicsBody = .init(circleOfRadius: pinSize / 2)
                pin.physicsBody?.isDynamic = false
                
                pin.physicsBody?.categoryBitMask = PhysicsCategory.block
                pin.physicsBody?.contactTestBitMask = PhysicsCategory.ball
                pin.physicsBody?.collisionBitMask = PhysicsCategory.ball
                
                pin.zPosition = 11
                addChild(pin)
                pinsArray.append(pin)
            }
        }
    }
    
    func createPegsLeft() {
        
        let numberOfRows: Int
        let pegsSize: CGSize
        let fontSize: CGFloat
        let startX: CGFloat
        let startY: CGFloat
        let spacing: CGFloat
            numberOfRows = 4
            pegsSize = CGSize(width: 40, height: 25)
            startX = size.width / 2 - 114
            startY = size.height / 2 - 25
            spacing = 46
            fontSize = 12
 
        
        for col in 1...numberOfRows {
            let startPegX = startX + CGFloat(numberOfRows - 1) * spacing
            let x = startPegX - CGFloat(col) * spacing
            let y = startY
            
            let colorPeg = UIColor.red
            let peg = RoundedCornerSpriteNode(color: colorPeg, size: pegsSize, cornerRadius: 10,borderWidth: 2,borderColor: .customBrown)
            peg.position = CGPoint(x: x, y: y)
            peg.physicsBody = SKPhysicsBody(rectangleOf: peg.size)
            peg.physicsBody?.isDynamic = false
            peg.physicsBody?.categoryBitMask = PhysicsCategory.winPanel
            peg.physicsBody?.contactTestBitMask = PhysicsCategory.ball
            peg.physicsBody?.collisionBitMask = PhysicsCategory.ball
            peg.name = "peg_\(col)"
            print("\(peg.name)")
            peg.zPosition = 11
            pegArray.append(peg)
            addChild(peg)
            
            let orderLabel = SKLabelNode(text: "x\(col)")
            orderLabel.fontName = "Lato-Medium"
            orderLabel.fontSize = fontSize
            orderLabel.position = CGPoint(x: peg.position.x, y: peg.position.y - 4)
            orderLabel.zPosition = 12
            pegLabelArray.append(orderLabel)
            addChild(orderLabel)
        }
    }

    
    func createPegsRight() {
        let numberOfRows: Int
        let pegsSize: CGSize
        let fontSize: CGFloat
        let startX: CGFloat
        let startY: CGFloat
        let spacing: CGFloat
            numberOfRows = 4
            pegsSize = CGSize(width: 40, height: 25)
            startX = size.width / 2 - 158
            startY = size.height / 2 - 25
            spacing = 46
            fontSize = 12
        
        for col in 1...numberOfRows {
            let startPegX = startX + CGFloat(numberOfRows - 1) * spacing
            let x = startPegX + CGFloat(col) * spacing
            let y = startY
            
            let colorPeg = UIColor.red
            let peg = RoundedCornerSpriteNode(color: colorPeg, size: pegsSize, cornerRadius: 10,borderWidth: 2, borderColor: .customBrown)
            peg.position = CGPoint(x: x, y: y)
            peg.physicsBody = SKPhysicsBody(rectangleOf: peg.size)
            peg.physicsBody?.isDynamic = false
            peg.physicsBody?.categoryBitMask = PhysicsCategory.winPanel
            peg.physicsBody?.contactTestBitMask = PhysicsCategory.ball
            peg.physicsBody?.collisionBitMask = PhysicsCategory.ball
            peg.name = "peg_\(col)"
            print("\(peg.name)")
            peg.zPosition = 11
            pegArray.append(peg)
            addChild(peg)
            
            let orderLabel = SKLabelNode(text: "x\(col)")
            orderLabel.fontName = "Lato-Medium"
            orderLabel.fontSize = fontSize
            orderLabel.position = CGPoint(x: peg.position.x, y: peg.position.y - 4)
            orderLabel.zPosition = 12
            pegLabelArray.append(orderLabel)
            addChild(orderLabel)
        }
    }
}

// MARK: - Actions

extension ClassicScene {
    @objc private func settingsButtonAction() {
        guard popupActive == false else { return }
        resultTransfer?(.settings)
    }
    
    @objc private func homeButtonAction() {
        guard popupActive == false else { return }
        resultTransfer?(.home)
    }
    
    @objc private func lowButtonAction() {
//        guard popupActive == false else { return }
//        checkRisk(riskStatus: .low)
//        cheakStatusRisk()
    }
    
    @objc private func mediumButtonAction() {
//        guard popupActive == false else { return }
//        checkRisk(riskStatus: .medium)
//        cheakStatusRisk()
    }
    
    @objc private func highButtonAction() {
//        guard popupActive == false else { return }
//        checkRisk(riskStatus: .high)
//        cheakStatusRisk()
    }
    
    @objc private func minBetButtonAction() {
        guard popupActive == false else { return }
        minBet()
    }
    
    @objc private func maxBetButtonAction() {
        guard popupActive == false else { return }
        maxBet()
    }
    
    @objc private func minusBetButtonAction() {
        guard popupActive == false else { return }
        changeValue(plus: false, set: betSet, index: betIndex, methods: .betPlusMinus)
    }
    
    @objc private func plusBetButtonAction() {
        guard popupActive == false else { return }
        changeValue(plus: true, set: betSet, index: betIndex, methods: .betPlusMinus)
    }
    
    @objc private func minusRowsButtonAction() {
        guard popupActive == false else { return }
//        if userModel.numberRows == RowsCount.nineRows.rawValue {
//            updateRows(rows: .eightRows)
//        } else if userModel.numberRows == RowsCount.tenRows.rawValue {
//            updateRows(rows: .nineRows)
//        }
    }
    
    @objc private func plusRowsButtonAction() {
        guard popupActive == false else { return }
//        if userModel.numberRows == RowsCount.eightRows.rawValue {
//            updateRows(rows: .nineRows)
//        } else if userModel.numberRows == RowsCount.nineRows.rawValue {
//            updateRows(rows: .tenRows)
//        }
    }
    
    @objc private func minusBallsNumberButtonAction() {
        guard popupActive == false else { return }
        changeValue(plus: false, set: numbersBallSet, index: numbersBallIndex, methods: .numberBallPlusMinus)
    }
    
    @objc private func plusBallsNumberButtonAction() {
        guard popupActive == false else { return }
        changeValue(plus: true, set: numbersBallSet, index: numbersBallIndex, methods: .numberBallPlusMinus)
    }
    
    @objc private func dropButtonButtonAction() {
        guard popupActive == false else { return }
        popupActive = true     // - сдесь блокируем нажатия когда идет падение мячика

        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            
            self.createBall(countBall: 1)
        }
    }
    
    @objc func maxBet() {
        var maxCount = 0
        maxCount = 1
        if balance == 0 {
            //            setActiveAllButtons(active: false)
            dropButton.setActive(active: false)
            return
        }
        
        if balance <= maxCount {
            betIndex = 0
        } else {
            let canBet = balance
            let subBet = betSet.filter({ (bet) -> Bool in
                return bet <= canBet
            })
            guard let max = subBet.max() else { return }
            betIndex = betSet.firstIndex(of: max)!
        }
    }
    
    @objc func minBet() {
        var minCount = 0
        minCount = 1
        
        if balance == 0 {
            //            setActiveAllButtons(active: false)
            dropButton.setActive(active: false)
            return
        }
        
        if balance <= minCount {
            betIndex = 0
        } else {
            let canBet = balance
            let subBet = betSet.filter({ (bet) -> Bool in
                return bet <= canBet
            })
            guard let min = subBet.min() else { return }
            betIndex = betSet.firstIndex(of: min)!
        }
    }
    
    func removeAllPins() {
        for pin in pinsArray {
            pin.removeFromParent()
        }
        pinsArray.removeAll()
    }
    
    func removeAllPeg() {
        for pin in pegArray {
            pin.removeFromParent()
        }
        pegArray.removeAll()
    }
    
    func removeAllPegLabel() {
        for pin in pegLabelArray {
            pin.removeFromParent()
        }
        pegLabelArray.removeAll()
    }
    
    func removeAllwinPanelAnimation() {
        for panelAnimation in winPanelAnimationArray {
            panelAnimation.removeFromParent()
        }
        winPanelAnimationArray.removeAll()
    }
    
    func removeAllwinLabelAnimation() {
        for panelAnimation in winLabeAnimationArray {
            panelAnimation.removeFromParent()
        }
        winLabeAnimationArray.removeAll()
    }
    
    func updateRows(rows: RowsCount) {
        removeAllPins()
        removeAllPeg()
        removeAllPegLabel()
//        createPlinkoBoard(countRows: rows)
        createPegsLeft()
        createPegsRight()
        updateTitleRows()
    }
    
    func updateTitleRows() {
//        if let foundSprite = findLabelNode(labelName: LabelName.titleRowsLabel.rawValue) {
//            foundSprite.text = "\(UserModel.shared.numberRows)"
//        }
    }
    
    func createBall(countBall: Int) {
        balance -= bet * countBall
        for i in 1...countBall {
            var random = Double.random(in: -20...20)
            setupBall(positionBall: CGPoint(x: size.width / 2 + random, y: size.height - 90))
        }
    }
    
    func changeValue(plus: Bool, set: [Int], index: Int, methods: Methods ) {
        let increment = plus ? 1 : -1
        let newValue = index + increment
        if newValue < 0 {
            return
        }
        
        if newValue >= set.count {
            return
        }
        switch methods {
        case .betPlusMinus:
            betIndex += increment
        case .numberBallPlusMinus:
            numbersBallIndex += increment
        }
    }
    
//    func checkRisk(riskStatus: RiskStatus) {
//        var spriteButtonActive = SKSpriteNode()
//        var spriteButtonNotActive_1 = SKSpriteNode()
//        var spriteButtonNotActive_2 = SKSpriteNode()
//        var nameImageStringActive = ""
//        var nameImageStringNotActive_1 = ""
//        var nameImageStringNotActive_2 = ""
//        switch riskStatus {
//        case .low:
//            riskCoeff = 1
//            spriteButtonActive = findSprite(spriteName: "lowButton")!
//            spriteButtonNotActive_1 = findSprite(spriteName: "mediumButton")!
//            spriteButtonNotActive_2 = findSprite(spriteName: "highButton")!
//            nameImageStringActive = "btn_low_active"
//            nameImageStringNotActive_1 = "btn_medium"
//            nameImageStringNotActive_2 = "btn_high"
//        case .medium:
//            riskCoeff = 2
//            spriteButtonActive = findSprite(spriteName: "mediumButton")!
//            spriteButtonNotActive_1 = findSprite(spriteName: "lowButton")!
//            spriteButtonNotActive_2 = findSprite(spriteName: "highButton")!
//            nameImageStringActive = "btn_medium_active"
//            nameImageStringNotActive_1 = "btn_low"
//            nameImageStringNotActive_2 = "btn_high"
//        case .high:
//            riskCoeff = 3
//            spriteButtonActive = findSprite(spriteName: "highButton")!
//            spriteButtonNotActive_1 = findSprite(spriteName: "lowButton")!
//            spriteButtonNotActive_2 = findSprite(spriteName: "mediumButton")!
//            nameImageStringActive = "btn_high_active"
//            nameImageStringNotActive_1 = "btn_low"
//            nameImageStringNotActive_2 = "btn_medium"
//        }
//        spriteButtonActive.texture = SKTexture(imageNamed: "\(nameImageStringActive)")
//        spriteButtonNotActive_1.texture = SKTexture(imageNamed: "\(nameImageStringNotActive_1)")
//        spriteButtonNotActive_2.texture = SKTexture(imageNamed: "\(nameImageStringNotActive_2)")
//    }
//    
//    func cheakStatusRisk() {
//        if let rowsCount = RowsCount(rawValue: userModel.numberRows) {
//            updateRows(rows: rowsCount)
//        }
//    }
}

// MARK: - Physics Contact Delegate

extension ClassicScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let otherBody = contact.bodyA.node
        let ballBody = contact.bodyB.node
        let firstBodyMask = contact.bodyA.node?.physicsBody?.categoryBitMask
        let secondBodyMask = contact.bodyB.node?.physicsBody?.categoryBitMask
        if (firstBodyMask == PhysicsCategory.winPanel && secondBodyMask == PhysicsCategory.ball) ||
            (firstBodyMask == PhysicsCategory.ball && secondBodyMask == PhysicsCategory.winPanel) {
            
            contactBallAndwinPanel(winPanelBody: otherBody, ballBody: ballBody)
        } else if (firstBodyMask == PhysicsCategory.spring && secondBodyMask == PhysicsCategory.ball) ||
                    (firstBodyMask == PhysicsCategory.ball && secondBodyMask == PhysicsCategory.spring) {
            print("2")
            //            contactBallAndKey(keyBody: otherBody)
        } else if (firstBodyMask == PhysicsCategory.field && secondBodyMask == PhysicsCategory.ball) ||
                    (firstBodyMask == PhysicsCategory.ball && secondBodyMask == PhysicsCategory.field) {
            //            springSettings(for: otherBody, secondBody: ballBody)
            print("3")
        } else if (firstBodyMask == PhysicsCategory.block && secondBodyMask == PhysicsCategory.ball) ||
                    (firstBodyMask == PhysicsCategory.ball && secondBodyMask == PhysicsCategory.block) {
            contactBallAndBlock(blockNode: otherBody)
        }
    }
    
    override func didSimulatePhysics() {
        enumerateChildNodes(withName: "ball") { ball, stop in
            checkPositionBall(ball: ball)
        }
        
        func checkPositionBall(ball: SKNode) {
            //            print(" ball.position.y  - \(ball.position.y)")
            if ball.position.y < 85 {
                print(" DELETE BALL !!!!!!!!!!!!!!")
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
                    ball.removeFromParent()
                }
                let isBall = self.checkSprite(spriteName: "ball")
                if !isBall {
                    self.popupActive = false
                }
            }
        }
    }
}

// MARK: - Contact loggic

extension ClassicScene {
    private func contactBallAndwinPanel(winPanelBody: SKNode?, ballBody: SKNode?) {
        if let winPanel = winPanelBody as? SKSpriteNode, let ballBody = ballBody as? SKSpriteNode {
            ballBody.removeFromParent()
            removeAllwinLabelAnimation()
            let winCount = countingWinnings(winPanelBody: winPanel)
            let winPanel = setupWinPanelAnimation(position: winPanel.position)
            let winLabel = setupWinLabelAnimation(text: "+\(winCount)")
            let sequence = animationSector(sectorAnimation: winPanel, kay: "img_ball_win", timePerFrame: 0.7)
            winPanel.run(sequence, withKey: "img_ball_win")
            
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) { [weak self] in
                guard let self else { return }
                self.removeAllwinLabelAnimation()
            }
        }
        let isBall = self.checkSprite(spriteName: "ball")
        if !isBall {
            self.popupActive = false
        }
    }
    
    private func contactBallAndBlock(blockNode: SKNode?) {
        guard let blockNode = blockNode as? SKSpriteNode else { return }
//        
//        if !pegAnimationState[blockNode, default: false] {
//            let pinHit = setupPinHitAnimation(position: blockNode.position)
//            let sequence = animationSector(sectorAnimation: pinHit, kay: "img_ball_hit", blockNode: blockNode, timePerFrame: 0.15)
//            pinHit.run(sequence, withKey: "img_ball_hit")
//            pegAnimationState[blockNode] = true
//        }
    }
    
    func countingWinnings(winPanelBody: SKNode) -> Int {
        var panelСoefficient = 0
        switch winPanelBody.name {
        case PanelName.peg0.rawValue:
            panelСoefficient = 0
        case PanelName.peg1.rawValue:
            panelСoefficient = 1
        case PanelName.peg2.rawValue:
            panelСoefficient = 2
        case PanelName.peg3.rawValue:
            panelСoefficient = 3
        case PanelName.peg4.rawValue:
            panelСoefficient = 4
        case PanelName.peg5.rawValue:
            panelСoefficient = 5
        case PanelName.peg6.rawValue:
            panelСoefficient = 6
        case .none:
            break
        case .some(_):
            break
        }
        animateCoins()
        balance += bet * panelСoefficient
        var winCount = bet * panelСoefficient
        print("winCount --- \(winCount)")
        return winCount
    }
}

// MARK: - Animation
extension ClassicScene {
    func animationSector(sectorAnimation: SKSpriteNode, kay: String, blockNode: SKSpriteNode? = nil, timePerFrame: Double) -> SKAction {
        var scoreAnimationTextures: [SKTexture] = []
        
        let animationScoreTexture = SKTexture(imageNamed: "\(kay)")
        scoreAnimationTextures.append(animationScoreTexture)
        
        let isHiddenAnimation = SKAction.run {
            sectorAnimation.isHidden = false
        }
        
        let coinAnimation = SKAction.animate(with: scoreAnimationTextures, timePerFrame: TimeInterval(timePerFrame))
        let repeatAnimation = SKAction.repeat(coinAnimation, count: 1)
        let removeAnimation = SKAction.run {
            sectorAnimation.removeAction(forKey: "\(kay)")
            if let blockNode = blockNode {
                self.pegAnimationState[blockNode] = false
            }
        }
        
        let removeSprite = SKAction.run {
            sectorAnimation.removeFromParent()
        }
        
        let sequence = SKAction.sequence([isHiddenAnimation, repeatAnimation, removeAnimation, removeSprite])
        return sequence
    }
    
    func animationBall() {
        
        let numBalls = 1
        let radius: CGFloat = 10
        
        for i in 0..<numBalls {
            let angle = CGFloat(i) * (2 * CGFloat.pi) / CGFloat(numBalls)
            let xOffset = radius * cos(angle)
            let yOffset = radius * sin(angle)
            
            let ball = SKSpriteNode(imageNamed: "img_game_ball")
            ball.size = CGSize(width: 8, height: 8)
            ball.position = CGPoint(x: size.width / 2 + xOffset , y: size.height / 2 + yOffset + 150)
            ball.zPosition = 20
            addChild(ball)
            
            let moveAction = createSmoothMovementAction(for: ball, radius: radius)
            ball.run(moveAction)
        }
    }
    
    func createRandomMovementAction(for ball: SKSpriteNode, radius: CGFloat) -> SKAction {
        let moveDuration = TimeInterval.random(in: 0.2...0.4)
        let randomAngle = CGFloat.random(in: CGFloat.pi...CGFloat.pi * 4)
        let randomRadius = CGFloat.random(in: 5...radius)
        let endPosition = CGPoint(x: ball.position.x + randomRadius * cos(randomAngle),
                                  y: ball.position.y + randomRadius * sin(randomAngle))
        let moveAction = SKAction.move(to: endPosition, duration: moveDuration)
        let returnAction = SKAction.move(to: ball.position, duration: moveDuration)
        let sequence = SKAction.sequence([moveAction, returnAction])
        return SKAction.repeatForever(sequence)
    }
    
    func createSmoothMovementAction(for ball: SKSpriteNode, radius: CGFloat) -> SKAction {
        let moveDuration = TimeInterval.random(in: 2...4)
        let numPoints = 15
        
        var points: [CGPoint] = []
        for _ in 0..<numPoints {
            let randomAngle = CGFloat.random(in: 0...CGFloat.pi * 2)
            let randomRadius = CGFloat.random(in: 0...radius) - 1
            let randomRadiusX = CGFloat.random(in: 0...radius) + 10
            let x = ball.position.x + randomRadiusX * cos(randomAngle)
            let y = ball.position.y + randomRadius * sin(randomAngle)
            points.append(CGPoint(x: x, y: y))
        }
        
        var actions: [SKAction] = []
        for i in 0..<numPoints - 1 {
            let moveAction = SKAction.move(to: points[i], duration: moveDuration / TimeInterval(numPoints))
            actions.append(moveAction)
        }
        
        actions.append(SKAction.move(to: ball.position, duration: moveDuration / TimeInterval(numPoints)))
        let sequence = SKAction.sequence(actions)
        return SKAction.repeatForever(sequence)
    }
    
    @objc func animateCoins() {
//        configureCoinsAnimation(from: CGPoint(x: size.width / 2 + 190, y: size.height / 2 + 60),
//                                to: CGPoint(x: size.width / 2 + 230, y: size.height / 2 - 150))
    }
}

extension ClassicScene {
    
    private func checkSprite(spriteName: String) -> Bool {
        var bool: Bool = false
        enumerateChildNodes(withName: "//*") { [weak self] node, _ in
            guard let self else { return }
            if let sprite = node as? SKSpriteNode, sprite.name == "\(spriteName)" {
                bool = true
            }
        }
        return bool
    }
    
    private func findSprite(spriteName: String) -> SKSpriteNode? {
        var foundSprite: SKSpriteNode?
        
        enumerateChildNodes(withName: "//*") { [weak self] node, _ in
            guard let self = self else { return }
            
            if let sprite = node as? SKSpriteNode, sprite.name == spriteName {
                foundSprite = sprite
            }
        }
        return foundSprite
    }
    
    private func findLabelNode(labelName: String) -> SKLabelNode? {
        var foundLabelNode: SKLabelNode?
        
        enumerateChildNodes(withName: "//*") { [weak self] node, _ in
            guard let self = self else { return }
            
            if let labelNode = node as? SKLabelNode, labelNode.name == labelName {
                foundLabelNode = labelNode
            }
        }
        
        return foundLabelNode
    }
}




