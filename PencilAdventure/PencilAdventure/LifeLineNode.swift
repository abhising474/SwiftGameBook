
import SpriteKit

let REFRESH_RATE: CGFloat = 0.1

public class LifeLineNode: SKCropNode {
  
  private var lifeLine: CGFloat = 1.0
  private var gameScene: GameScene?
  
  convenience init(forScene scene: GameScene) {
    self.init()
    
    gameScene = scene
    zPosition = HUDZPosition
    
    // Start reducing led from the pencil
    callbackAfter(REFRESH_RATE, subtractLifeLine)
    
    let spriteAtlas = SKTextureAtlas(named: "Sprites")
    let healthSprite = SKSpriteNode(texture: spriteAtlas.textureNamed("health"))
    healthSprite.xScale = scene.getSceneScaleX()
    healthSprite.yScale = scene.getSceneScaleY()
    addChild(healthSprite)
    
    // Position ourselves in the upper-right corner
    position.x = scene.viewableArea.origin.x + scene.viewableArea.size.width
    position.y = scene.viewableArea.origin.y + scene.viewableArea.size.height
    
    // Our sprite anchor is the center, so this means the center of the sprite is at the corner.
    // So let's move this away from the corner by half of it's size so it's just inside the screen
    position.x -= healthSprite.size.width/2
    position.y -= healthSprite.size.height/2
    
    // Let's also give it a small gap, relative to the size of the sprite (say... 1/8th?)
    position.x -= healthSprite.size.width/8
    position.y -= healthSprite.size.height/8
    
    // Create the maskNode
    maskNode = SKSpriteNode(color: SKColor.whiteColor(), size: healthSprite.size)
  }
  
  private func subtractLifeLine() {
    lifeLine -= DEPLETE_HEALTH_PER_SEC * REFRESH_RATE
    maskNode?.yScale = lifeLine
    if lifeLine > 0 {
      callbackAfter(REFRESH_RATE, subtractLifeLine)
    } else {
      gameScene?.gameEnd(false)
    }
  }
  
  public func addLifeLine(life: CGFloat) {
    // Give more led till Mr Pencil reaches the end
    if lifeLine < 1 {
      lifeLine += life
    }
    maskNode?.yScale = lifeLine
  }
  
}
