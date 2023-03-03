

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame_texturepacker/flame_texturepacker.dart';

import 'AngryPride.dart';
import 'PlayerAnimation.dart';
import 'TillesMap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  MyGame game=MyGame();
  GameWidget gameWidget=GameWidget(game: game);


  runApp(gameWidget);
}

class MyGame extends Forge2DGame with HasTappables,HasDraggables,HasKeyboardHandlerComponents{

  MyGame():super(gravity: Vector2(0, 15),zoom: 1);
  SpriteComponent barrel=SpriteComponent();
  AngryPride angryPride=AngryPride(Vector2(200,380),0.5);
  late PlayerAnimation playerAnimation2;
  late PlayerAnimation playerAnimation;

  late JoystickComponent joystickComponent;
  late  SpriteAnimationComponent ninja;
  late bool bAnimeted=false;
  late final  spriteSheet3;
  late final  spriteSheet2;



  late TiledComponent mapComponent;

   TextPaint tDialogoTextPaint = TextPaint(
      style: const TextStyle(fontSize: 40, color: Colors.black87));

  @override
  Future<void> onLoad() async{
     await super.onLoad();

     mapComponent=await TiledComponent.load('beastlands2.tmx',Vector2.all(32));
     TiledMapObjectBody tmob;
     mapComponent.tileMap.getLayer<ObjectGroup>("CapaColision")!
         .objects.forEach((obj) {

        tmob=TiledMapObjectBody(obj);
        add(tmob);

     });


     add(mapComponent);
     final Vector2 screen=screenToWorld(camera.viewport.effectiveSize);

     String path="barrel.png";

     add(Player(Vector2(480,410),0.5,path));
     add(Player(Vector2(460,410),0.5,path));
     add(Player(Vector2(440,410),0.5,path));
     add(Player(Vector2(420,410),0.5,path));


     add(Player(Vector2(480,390),0.5,path));
     add(Player(Vector2(460,390),0.5,path));
     add(Player(Vector2(440,390),0.5,path));
     add(Player(Vector2(420,390),0.5,path));


     add(Player(Vector2(480,380),0.5,path));
     add(Player(Vector2(460,380),0.5,path));
     add(Player(Vector2(440,380),0.5,path));
     add(Player(Vector2(420,380),0.5,path));

      path="box.png";
     add(Player(Vector2(560,240),0.5,path));
     add(Player(Vector2(560,220),0.5,path));
     add(Player(Vector2(560,200),0.5,path));
     add(Player(Vector2(560,180),0.5,path));

     add(angryPride);


     spriteSheet2 = await fromJSONAtlas("NinjaRun.png", "JsonRun.json");
     spriteSheet3 = await fromJSONAtlas("NinjaFigth.png", "NinjaFigth.json");
     playerAnimation=PlayerAnimation(spriteSheet3, Vector2(300,300), 0.1,true);
     playerAnimation2=PlayerAnimation(spriteSheet2, playerAnimation.position, 0.1,true);

    add(playerAnimation);


     final knobPaint =BasicPalette.red.withAlpha(200).paint();
     final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();

     joystickComponent = JoystickComponent(
          knob: CircleComponent(radius: 20, paint: knobPaint),
          background: CircleComponent(radius: 40, paint: backgroundPaint),
          margin: const EdgeInsets.only(left: 40, bottom: 40));
     add(joystickComponent);


  }
  bool pFloopy(){
    bool direction=false;
    if(joystickComponent.delta.x<-1 && !playerAnimation.girlNinja.isFlippedHorizontally){
      playerAnimation.girlNinja.flipHorizontally();
      direction= false;
    }else if(joystickComponent.delta.x>1 && playerAnimation.girlNinja.isFlippedHorizontally){
      playerAnimation.girlNinja.flipHorizontally();
       direction=false;
    }

    return direction;
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);


    playerAnimation.body.setTransform(playerAnimation.body.position+joystickComponent.delta/20,0);

    if(joystickComponent.isDragged){
      pFloopy();
      playerAnimation.walk= SpriteAnimation.spriteList(
          spriteSheet2, stepTime: 0.1);
      playerAnimation.girlNinja.animation?.stepTime=0.1;

    } else if(!joystickComponent.isDragged){
      playerAnimation.walk= SpriteAnimation.spriteList(
          spriteSheet3, stepTime: 0.1);

      playerAnimation.girlNinja.animation?.stepTime=0.1;

    }



  }

  @override
  Future<void> render(Canvas canvas) async {
    super.render(canvas);

    if(joystickComponent.isDragged){
      pFloopy();
    // remove(playerAnimation);
    //  add(playerAnimation2);
    //  playerAnimation2.add(joystickComponent);

    }else if(!joystickComponent.isDragged){

     // remove(playerAnimation2);
    //  add(playerAnimation);
    }



    switch (angryPride.getCount()) {
      case 0:tDialogoTextPaint.render(
          canvas,
          "game over",
          Vector2(100,100));
      break;
      case 1:
        tDialogoTextPaint.render(
            canvas,
            angryPride.count.toString(),
            Vector2(100, 100));
        break;
      case 2:
        tDialogoTextPaint.render(
            canvas,
            angryPride.count.toString(),
            Vector2(100,100));
        break;
      case 3:
        tDialogoTextPaint.render(
            canvas,
            angryPride.count.toString(),
            Vector2(100,100));
        break;

    }
  }

  }

class Player extends BodyComponent<MyGame>{

  late final Vector2 vector2;
  late final double restitution;
  late final String ruta;


  Player(this.vector2,this.restitution,this.ruta);

  @override
  Future<void> onLoad() async{
    SpriteComponent barrel=SpriteComponent();
    await super.onLoad();
    renderBody=true;

    barrel
      ..sprite=await gameRef.loadSprite(ruta)
      ..size=Vector2(20,20)
      ..anchor=Anchor.center;

    add(barrel);


  }

  @override
  Body createBody() {


    // TODO: implement createBody
    final shape=CircleShape()..radius=10;
    final fixture=FixtureDef(shape,friction: 0.5,restitution: restitution,density: 0.5);

    final bodyDef=BodyDef(userData:this,position: vector2,type:BodyType.dynamic);
    return world.createBody(bodyDef)..createFixture(fixture);

  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    //print("DEBUG:------>>>>> "+keysPressed.toString());


    //final isKeyDown = event is RawKeyDownEvent;
    //final isKeyUp = event is RawKeyUpEvent;

    if(keysPressed.contains(LogicalKeyboardKey.arrowRight)){
      //center.add(Vector2(3, 0));
    //lñ  body.setTransform(body.position+Vector2(3, 0), 0);
      print("object");
      return true;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
     // center.add(Vector2(-3, 0));
      print("object");
      return true;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowUp)){
      //center.add(Vector2(0, -3));
      print("object");
      return true;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowDown)){
      //center.add(Vector2(0, 3));
      print("object");
      return true;
    }
    else{
      return false;
    }

    return false;
  }
}




