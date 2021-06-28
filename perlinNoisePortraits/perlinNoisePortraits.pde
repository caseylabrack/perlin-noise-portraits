NoiseWalker[] walkers = new NoiseWalker[10000];
PGraphics c;
float noiseScale;
float noiseStrength;
int blendSetting;
final int BLEND_ADD = 1;
final int BLEND_MULT = 2;
final int DRAWMODE_FAST = 1;
final int DRAWMODE_NICE = 2;
int drawMode = DRAWMODE_NICE;

float touchTime;
final float TAP_DURATION = 250;

final int SAT = 70;
final int VALUE = 80;
int hue;

float px, py;

void setup () {
  //size(500, 500, P2D);
  fullScreen(P2D);
  //pixelDensity(displayDensity());
  for (int i = 0; i < walkers.length; i++) walkers[i] = new NoiseWalker(width, height, 1, 5);

  c = createGraphics(width, height, P2D);
  c.beginDraw();
  c.colorMode(HSB, 360, 100, 100, 1);
  c.noFill();
  c.endDraw();
  init();
}

void mouseClicked() {
  init();
}

void mouseDragged() 
{
  drag(pmouseX - mouseX, pmouseY - mouseY);
}

void mouseReleased () {
  release();
}

void touchStarted() {
  touchTime = millis();
  px = touches[0].x;
  py = touches[0].y;
}

void touchMoved() {
  float dx = px - touches[0].x;
  float dy = py - touches[0].y;
  px = touches[0].x;
  py = touches[0].y;
  drag(dx, dy);
}

void touchEnded() {
  if (millis() - touchTime > TAP_DURATION) { // long touch is a drag
    release();
  } else { // short touch is a tap
    init();
  }
}

void init () {
  noiseSeed((int)random(1e6));
  noiseScale = random(100, 500);
  noiseStrength = random(1, 10);

  hue = int(random(360));

  c.beginDraw();
  if (random(1) > .66) {
    c.background(0, 0, 0, 1);
    c.blendMode(ADD);
    blendSetting = ADD;
    c.stroke(hue, SAT, VALUE, .25);
  } else {
    c.background(0, 0, 100, 1);
    c.blendMode(MULTIPLY);
    blendSetting = MULTIPLY;
    c.stroke(hue, SAT, VALUE, .1);
  }
  c.endDraw();

  for (int i = 0; i < walkers.length; i++) walkers[i].init();
}

void drag (float dx, float dy) {
  drawMode = DRAWMODE_FAST;

  c.beginDraw();
  c.blendMode(BLEND);
  c.background(0, 0, 100, 1);
  c.stroke(hue, SAT, VALUE, 1);

  for (int i = 0; i < walkers.length; i++) {
    walkers[i].init();
    walkers[i].xoff += dx;
    walkers[i].yoff += dy;
  }
  c.endDraw();
}

void release () {
  drawMode = DRAWMODE_NICE;
  c.beginDraw();
  c.background(0, 0, blendSetting == ADD ? 0 : 100, 1);
  c.stroke(hue, SAT, VALUE, blendSetting == ADD ? .25 : .1);
  c.blendMode(blendSetting);
  c.endDraw();
  for (int i = 0; i < walkers.length; i++) walkers[i].init();
}

void draw () {

  // DRAWMODE_NICE builds up high quality image over many frames
  // DRAWMODE_FAST make a new, quick-and-dirty image every frame
  int its = drawMode == DRAWMODE_NICE ? 1 : 100;
  int ws = drawMode == DRAWMODE_NICE ? walkers.length : 100;

  c.beginDraw();
  for (int j = 0; j < its; j++) {
    for (int i = 0; i < ws; i++) {
      walkers[i].update();
      if (walkers[i].active==false) continue;
      c.line(walkers[i].x, walkers[i].y, walkers[i].px, walkers[i].py);
    }
  }
  c.endDraw();

  image(c, 0, 0);
}
