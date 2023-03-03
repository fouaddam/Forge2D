

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:forge2d/src/dynamics/body.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';

class PlayerAnimation extends BodyComponent with KeyboardHandler{



  late var vSpriteSheet;
  late Vector2 position;
  late double restitution;
  late SpriteAnimationComponent girlNinja=SpriteAnimationComponent();
  late BodyDef bodyDef;
  late bool bAnimation;
  late SpriteAnimation walk;

  PlayerAnimation(
     this.vSpriteSheet, this.position, this.restitution,this.bAnimation);




  @override
  Body createBody() {
    final shape=CircleShape()..radius=20;
    final fixture=FixtureDef(shape,friction: 0,restitution: 0,density: 0.2);
    bodyDef=BodyDef(userData:this,position: position,type:BodyType.dynamic);
    return world.createBody(bodyDef)..createFixture(fixture);
  }

  double isAnimated(){
    double dStipTime=0;
    if(bAnimation){dStipTime=0.1;}else{dStipTime=0.1;};
    return dStipTime;
  }




  @override
  Future <void> onLoad() async {
    await super.onLoad();

     //final spriteSheet = await fromJSONAtlas("NinjaJson.png", "NinjaFigth.json");
    renderBody=false;
    walk = SpriteAnimation.spriteList(
       vSpriteSheet, stepTime: 0.1);

    girlNinja
      ..size=Vector2(50,50)
      ..anchor=Anchor.center
      ;
    add(girlNinja);
  }

  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    girlNinja
      ..animation=walk;


  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {

    CombinationKey(event,keysPressed);

    if(keysPressed.contains(LogicalKeyboardKey.arrowRight)){
      //center.add(Vector2(3, 0));

      body.setTransform(body.position+Vector2(3, 0), 0);
      return true;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
      center.add(Vector2(-3, 0));

      return true;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowUp)){
      center.add(Vector2(0, -6));
      return true;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowDown)){
      center.add(Vector2(0, 3));
      return true;
    }
    else{
      return false;
    }

    return false;

  }



  CombinationKey(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed){
    final isKeyDown = event is RawKeyDownEvent;

    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (isSpace && isKeyDown) {
      if (keysPressed.contains(LogicalKeyboardKey.altLeft) ||
          keysPressed.contains(LogicalKeyboardKey.altRight)) {
        print("isSpace && isKeyDown LogicalKeyboardKey.altLeft LogicalKeyboardKey.altRight ");
        //this.shootHarder();
      } else {
        print("12");
        // this.shoot();
      }
      //return KeyEventResult.handled;
    }
    return false;
  }



}