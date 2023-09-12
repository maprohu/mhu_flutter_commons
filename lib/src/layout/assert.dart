part of '../layout.dart';

bool assertSizeAxisRoughlyEqual({
  required Axis axis,
  required Size a,
  required Size b,
}) {
  assert(
    doubleRoughlyEqual(
      a.sizeAxisDimension$(axis),
      b.sizeAxisDimension$(axis),
    ),
    (a, b),
  );
  return true;
}

bool assertOrientedMainRoughlyEqual({
  @ext required OrientedBox orientedBox,
  required Size size,
}) {
  return assertSizeAxisRoughlyEqual(
    axis: orientedBox.axis,
    a: orientedBox.size,
    b: size,
  );
}

bool assertOrientedCrossRoughlyEqual({
  @ext required OrientedBox orientedBox,
  required Size size,
}) {
  return assertSizeAxisRoughlyEqual(
    axis: orientedBox.crossAxis(),
    a: orientedBox.size,
    b: size,
  );
}
