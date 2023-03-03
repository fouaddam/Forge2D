import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:forge2d/src/dynamics/body.dart';
import 'main.dart';

class Fighter extends BodyComponent<MyGame> {

  final Vector2 position;
  final Vector2 size;

  Fighter({required this.position, required this.size}) {
    renderBody = true;
  }
  @override
  Future<void> onLoad() async{

    SpriteComponent pride=SpriteComponent();
    await super.onLoad();
    renderBody=true;

    pride
      ..sprite=await gameRef.loadSprite("bride.png")
      ..size=Vector2(30,30)
      ..anchor=Anchor.center;

    add(pride);

  }

  @override
  Body createBody() {
    final shape = PolygonShape();

    final vertices = [
      Vector2(0, 0),
      Vector2(size.x * 0.65, 0),
      Vector2(size.x * 0.65, size.y),
      Vector2(0, size.y),
    ];
    shape.set(vertices);

    final fixtureDef = FixtureDef(
      shape,
      userData: this, // To be able to determine object in collision
      restitution: 0.8,
      density: 1.0,
      friction: 0.2,
    );

    final velocity = (Vector2.random() - Vector2.random()) * 200;
    BodyDef def = BodyDef(
      type: BodyType.dynamic,
      position: position,
      angle: velocity.angleTo(Vector2(1, 0)),
      linearVelocity: velocity
    );

    return world.createBody(def)
      ..createFixture(fixtureDef);
  }
}