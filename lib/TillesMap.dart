
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:forge2d/src/dynamics/body.dart';

import 'package:tiled/tiled.dart';

import 'main.dart';

class TiledMapObjectBody extends BodyComponent<MyGame>{
  final TiledObject tiledObject;
  TiledMapObjectBody(this.tiledObject){
    renderBody=true;
  }

  @override
  Body createBody() {
    // TODO: implement createBody
    final bodyDef = BodyDef()
      ..position = Vector2(tiledObject.x, tiledObject.y)
      ..type = BodyType.static;
    Body body=world.createBody(bodyDef);

    if(tiledObject.isRectangle){
      PolygonShape shape = PolygonShape();

      final vertices = [
        Vector2(0, 0),
        Vector2(tiledObject.width, 0),
        Vector2(tiledObject.width, tiledObject.height),
        Vector2(0, tiledObject.height),
      ];
      shape.set(vertices);

      //final shape = CircleShape()..radius = size.x / 2;
      final fixtureDef = FixtureDef(shape)
        ..userData = this // To be able to determine object in collision
        ..restitution = 0.01
        ..density = 1.0
        ..friction = 0.2;

      body.createFixture(fixtureDef);
    }
    else if(tiledObject.isPolygon){

      ChainShape shape = ChainShape();

      final List<Vector2> vertices = [];
      for (final polygon in tiledObject.polygon) {

        shape.vertices.add(Vector2(polygon.x, polygon.y));
      }

      shape.vertices.add(Vector2(tiledObject.polygon[0].x, tiledObject.polygon[0].y));

      final fixtureDef = FixtureDef(shape)
        ..userData = this // To be able to determine object in collision
        ..restitution = 0.8
        ..density = 1.0
        ..friction = 0.2;

      body.createFixture(fixtureDef);

    }

    return body;
  }

}