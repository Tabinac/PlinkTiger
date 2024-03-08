//
//  ClassicScene.swift
//  PlinkTiger

import SpriteKit
import GameplayKit

enum GameState {
    case back
    case updateScoreBackEnd
    case nolifes
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
    
    private var bet: Int = 0 
    {
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
            return memory.scoreMeat
        }
        set {
            memory.scoreMeat = newValue
            meatLifeLabel.text = String(balance)
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
    }
    
    private func setupGameSubviews() {
        print("\(size.height)")
        createPlinkoBoard()
        createPegsLeft()
        createPegsRight()
        addSideWalls()
        setupBackground()
        setupNavigation()
        setupBottomBar()
        configureGame()
    }
        
     func updateCoinsBalance() {
        meatLifeLabel.text = String(balance)
        balanceLabel.text = String(memory.scoreCoints)
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
        homeButton.size = .init(width: 48.autoSize, height: 48.autoSize)
        homeButton.anchorPoint = .init(x: 0, y: 1.0)
        homeButton.position = CGPoint(x: 28, y: size.height - 60)
        homeButton.zPosition = 10
        homeButton.action = { self.backButtonAction() }
        addChild(homeButton)
        
        let balancBgNode = SKSpriteNode(imageNamed: "scoreImg")
        balancBgNode.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        balancBgNode.size = CGSize(width: 88.autoSize, height: 48.autoSize)
        balancBgNode.position = CGPoint(x: size.width / 2 - 60, y: size.height - 60)
        balancBgNode.zPosition = 10
        addChild(balancBgNode)
        
        balanceLabel = SKLabelNode(text: "\(memory.scoreCoints)")
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
        balanceLabel.position = CGPoint(x: balancBgNode.position.x + balancBgNode.size.width / 2 + 15, y: balancBgNode.position.y - balancBgNode.size.height / 2 - 6)
        balanceLabel.zPosition = balancBgNode.zPosition + 1
        addChild(balanceLabel)
        let cointsImageNode = SKSpriteNode(imageNamed: "cointsImg")
        cointsImageNode.size = CGSize(width: 24, height: 24)
        if UIScreen.main.bounds.height < 812 {
            cointsImageNode.position = CGPoint(x: balancBgNode.size.width / 2 - 20, y: balancBgNode.size.height / 2 - 40)
         } else {
             cointsImageNode.position = CGPoint(x: balancBgNode.size.width / 2 - 25, y: balancBgNode.size.height / 2 - 50)
         }
        cointsImageNode.zPosition = balancBgNode.zPosition + 1
        balancBgNode.addChild(cointsImageNode)
        
        let meatBgNode = SKSpriteNode(imageNamed: "scoreImg")
        meatBgNode.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        meatBgNode.size = CGSize(width: 88.autoSize, height: 48.autoSize)
        meatBgNode.position = CGPoint(x: size.width - 40, y: size.height - 60)
        meatBgNode.zPosition = 10
        addChild(meatBgNode)

        meatLifeLabel = SKLabelNode(text: "\(memory.scoreMeat)")
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
        if UIScreen.main.bounds.height < 812 {
            meatImageNode.position = CGPoint(x: -meatBgNode.size.width / 2 - 18, y: meatBgNode.size.height / 2 - 40)
         } else {
             meatImageNode.position = CGPoint(x: -meatBgNode.size.width / 2 - 25, y: meatBgNode.size.height / 2 - 50)
         }
        meatImageNode.zPosition = meatBgNode.zPosition + 1
        meatBgNode.addChild(meatImageNode)

    }
    
    private func setupBottomBar() {
        dropButton.size = .init(width: 340.autoSize, height: 48.autoSize)
        dropButton.anchorPoint = .init(x: 0.5, y: 0.5)
        
        let bottomMargin: CGFloat = 60
        let verticalPosition = bottomMargin + dropButton.size.height / 2
        
        dropButton.position = CGPoint(x: size.width / 2, y: verticalPosition)
        dropButton.action = { self.dropButtonButtonAction() }
        
        addChild(dropButton)
    }
    
    func setupWinLabelAnimation(text: String) -> SKLabelNode {
        let winLabe = SKLabelNode(text: "\(text)")
        winLabe.fontName = "Lato-Bold"
        winLabe.fontSize = 48
        winLabe.position = CGPoint(x: size.width / 2, y: size.height / 2 - 260)
        winLabe.zPosition = 12
        winLabeAnimationArray.append(winLabe)
        addChild(winLabe)
        return winLabe
    }

    func setupBall(positionBall: CGPoint) {
        ball = SKSpriteNode(imageNamed: "balImg")
        ball.anchorPoint = .init(x: 0.5, y: 0.5)
        ball.size = .init(width: 15.autoSize, height: 15.autoSize)
        ball.position = positionBall
        ball.physicsBody = .init(circleOfRadius: 8.autoSize)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.categoryBitMask = PhysicsCategory.ball
        ball.physicsBody?.collisionBitMask = PhysicsCategory.block | PhysicsCategory.winPanel | PhysicsCategory.field
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.winPanel | PhysicsCategory.field
        ball.physicsBody?.mass = 1.4
        ball.physicsBody?.restitution = 0.5
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
        if UIScreen.main.bounds.height < 812 {
             numberOfRows = 8
         } else {
             numberOfRows = 9
         }
            pinSize = 12.autoSize
            startX = size.width / 2
            startY = size.height - 260
            spacingX = 35
            spacingY = 35
        
        //MARK: - Create plinko board row
        
        for row in 0..<numberOfRows {
            let numberOfColumns = 3 + row
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
            pegsSize = CGSize(width: 38, height: 25)
            startX = size.width / 2 - 116
        if UIScreen.main.bounds.height < 812 {
            startY = size.height / 2 - 100
         } else {
             startY = size.height / 2 - 160
         }

        
            spacing = 48
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
            pegsSize = CGSize(width: 38, height: 25)
            startX = size.width / 2 - 170
        if UIScreen.main.bounds.height < 812 {
            startY = size.height / 2 - 100
         } else {
             startY = size.height / 2 - 160
         }
            spacing = 48
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

    
    //MARK: create Walls
    func addSideWalls() {
        let leftWall = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: size.height))
        leftWall.position = CGPoint(x: 0, y: size.height / 2)
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
        leftWall.physicsBody?.isDynamic = false
        leftWall.physicsBody?.categoryBitMask = PhysicsCategory.block
        leftWall.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        leftWall.physicsBody?.collisionBitMask = PhysicsCategory.ball
        addChild(leftWall)
        
        let rightWall = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: size.height))
        rightWall.position = CGPoint(x: size.width, y: size.height / 2)
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
        rightWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.categoryBitMask = PhysicsCategory.block
        rightWall.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        rightWall.physicsBody?.collisionBitMask = PhysicsCategory.ball
        addChild(rightWall)
    }
}

// MARK: - Actions

extension ClassicScene {
    @objc private func settingsButtonAction() {
        guard popupActive == false else { return }
        resultTransfer?(.updateScoreBackEnd)
    }
    
    @objc private func backButtonAction() {
        guard popupActive == false else { return }
        resultTransfer?(.back)
    }
    
     private func checkLifes() {
        guard popupActive == false else { return }
        resultTransfer?(.nolifes)
    }

    @objc private func dropButtonButtonAction() {
        guard popupActive == false else { return }
        if memory.scoreMeat > 0 {
            popupActive = true     // - сдесь блокируем нажатия когда идет падение мячика
            
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) { [weak self] in
                guard let self else { return }
                
                self.createBall(countBall: 1)
            }
        } else {
            checkLifes()
            print("No lifes")
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
    
    func updateRows() {
        removeAllPins()
        removeAllPeg()
        removeAllPegLabel()
        createPlinkoBoard()
        createPegsLeft()
        createPegsRight()
    }
    
    func createBall(countBall: Int) {
        balance -= bet * countBall
        for _ in 1...countBall {
            let random = Double.random(in: -30...30)
            setupBall(positionBall: CGPoint(x: size.width / 2 + random, y: size.height - 160))
        }
    }
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
            if ball.position.y < 250 {
                print(" DELETE BALL !!!!!!!!!!!!!!")
                    ball.removeFromParent()
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
            let winLabel = setupWinLabelAnimation(text: "+\(winCount) POINTS")
            let sequence = animationSector(sectorAnimation: winPanel, kay: "balImg", timePerFrame: 0.7)
            
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
        memory.scoreCoints += 40 * panelСoefficient
        var winCount = 40 * panelСoefficient
        print("winCount --- \(winCount)")
        updateCoinsBalance()
        resultTransfer?(.updateScoreBackEnd)
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
}

extension ClassicScene {
    
    private func checkSprite(spriteName: String) -> Bool {
        var bool: Bool = false
        enumerateChildNodes(withName: "//*") { [weak self] node, _ in
            guard self != nil else { return }
            if let sprite = node as? SKSpriteNode, sprite.name == "\(spriteName)" {
                bool = true
            }
        }
        return bool
    }
    
    private func findSprite(spriteName: String) -> SKSpriteNode? {
        var foundSprite: SKSpriteNode?
        
        enumerateChildNodes(withName: "//*") { [weak self] node, _ in
            guard self != nil else { return }
            
            if let sprite = node as? SKSpriteNode, sprite.name == spriteName {
                foundSprite = sprite
            }
        }
        return foundSprite
    }
    
    private func findLabelNode(labelName: String) -> SKLabelNode? {
        var foundLabelNode: SKLabelNode?
        
        enumerateChildNodes(withName: "//*") { [weak self] node, _ in
            guard self != nil else { return }
            
            if let labelNode = node as? SKLabelNode, labelNode.name == labelName {
                foundLabelNode = labelNode
            }
        }
        
        return foundLabelNode
    }
}
