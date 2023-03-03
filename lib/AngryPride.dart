

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d/src/dynamics/body.dart';

class AngryPride extends BodyComponent with Tappable{

  late final Vector2 position;
  late final restitution;

  AngryPride(this.position, this.restitution);


  @override
  void onMount() async{
    super.onMount();

    SpriteComponent barrel=SpriteComponent();
    renderBody=false;
    barrel
      ..sprite=await gameRef.loadSprite("bride.png")
      ..size=Vector2(25,25)
      ..anchor=Anchor.center;

    add(barrel);
  }

  @override
  Body createBody() {
    final shape=CircleShape()..radius=10;
    final fixture=FixtureDef(shape,friction: 1,restitution: restitution,density: .10);

    final bodyDef=BodyDef(userData:this,position: position,type:BodyType.dynamic);
    return world.createBody(bodyDef)..createFixture(fixture);
  }

  int count=3;

  @override
  bool onTapDown(TapDownInfo info){

    body.applyLinearImpulse(Vector2(30, -10)*2000);
    count--;
    return false;
  }

  int getCount(){
    return count;
  }

}