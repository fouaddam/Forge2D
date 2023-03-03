

import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:forge2d/src/dynamics/body.dart';

class Ground extends BodyComponent{

   final Vector2 gameSize;
   final int x;
   final int y;

   Ground(this.gameSize, this.x, this.y);





  @override
  Body createBody() {
    final shape=EdgeShape()..set(Vector2(0,gameSize.y-x), Vector2(gameSize.x,gameSize.y-y));

    final fixture=FixtureDef(shape,friction: 0.5,density: 1.2);

    final bodyDef=BodyDef(userData:this,position: Vector2.zero(),type:BodyType.static);
    return world.createBody(bodyDef)..createFixture(fixture);
  }





}