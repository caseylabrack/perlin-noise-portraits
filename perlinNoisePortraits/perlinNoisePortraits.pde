final int NUM_PARTICLES = 10000;
Particle[] particles = new Particle[NUM_PARTICLES];
PGraphics c;
float noiseScale;
//float noiseStrength;
float noiseStrengthMod;
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

float xoff = 0;
float yoff = 0;

PGraphics flash;
float alfa = 0;

class Particle {
  float x, y, step, px, py;
  boolean active;
}

void setup () {
  //size(500, 500, P2D);
  fullScreen(P2D);
  for (int i = 0; i < NUM_PARTICLES; i++) particles[i] = new Particle();
  resetParticles();

  c = createGraphics(width, height, P2D);
  c.smooth(8);
  c.beginDraw();
  c.colorMode(HSB, 360, 100, 100, 1);
  c.noFill();
  c.endDraw();

  flash = createGraphics(width, height);
  flash.beginDraw();
  flash.noStroke();
  flash.fill(255);
  flash.rect(0, 0, width, height);
  flash.endDraw();
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

//void touchStarted() {
//  touchTime = millis();
//  px = touches[0].x;
//  py = touches[0].y;
//}

//void touchMoved() {
//  float dx = px - touches[0].x;
//  float dy = py - touches[0].y;
//  px = touches[0].x;
//  py = touches[0].y;
//  drag(dx, dy);
//}

//void touchEnded() {
//  if (millis() - touchTime > TAP_DURATION) { // long touch is a drag
//    release();
//  } else { // short touch is a tap
//    init();
//  }
//}

void init () {
  noiseSeed((int)random(1e6));
  noiseScale = random(100, 500);
  //noiseStrength = random(1, 10);
  noiseStrengthMod = random(.0001, 2);

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

  resetParticles();
}

void drag (float dx, float dy) {
  drawMode = DRAWMODE_FAST;

  c.beginDraw();
  c.blendMode(BLEND);
  c.background(0, 0, 100, 1);
  c.stroke(hue, SAT, VALUE, 1);
  c.endDraw();

  resetParticles();
  xoff += dx;
  yoff += dy;
}

void release () {
  drawMode = DRAWMODE_NICE;
  c.beginDraw();
  c.background(0, 0, blendSetting == ADD ? 0 : 100, 1);
  c.stroke(hue, SAT, VALUE, blendSetting == ADD ? .25 : .1);
  c.blendMode(blendSetting);
  c.endDraw();
  resetParticles();
}

void keyReleased() {

  saveFrame("noise" + String.join("-", ""+month(), ""+day(), ""+hour(), ""+minute(), ""+second()) + ".png");
  alfa = 255;
}

void resetParticles() {

  for (Particle p : particles) {
    p.x = random(width);
    p.y = random(height);
    p.px = p.x;
    p.py = p.y;
    p.step = random(1, 5);
    p.active = true;
  }
}

void draw () {

  c.beginDraw();
  switch(drawMode) {

  case DRAWMODE_NICE: // all particles take one step per frame. final image builds up iteratively.
    for (Particle p : particles) {
      if (p.active == false) continue;

      float noiseStrength = map(noise(map(p.x, 0, width, 0, 1), map(p.y, 0, height, 0, 1)), 0, 1, .5, 50) * noiseStrengthMod;

      float angle = noise((p.x + xoff)/noiseScale, (p.y + yoff)/noiseScale) * noiseStrength * TWO_PI;
      p.px = p.x;
      p.py = p.y;

      p.x += cos(angle) * p.step;
      p.y += sin(angle) * p.step;

      if (p.x < 0 || p.x > width || p.y < 0 || p.y > height) {
        p.active = false;
      }

      c.line(p.x, p.y, p.px, p.py);
    }
    break;

  case DRAWMODE_FAST: // a few particles undergo many iterations in one frame. gives an instant preview of the image.
    for (int iterations = 0; iterations < 100; iterations++) {
      for (int sample = 0; sample < 250; sample++) {

        Particle p = particles[sample];

        if (p.active == false) continue;

        float noiseStrength = map(noise(map(p.x, 0, width, 0, 1), map(p.y, 0, height, 0, 1)), 0, 1, .5, 50) * noiseStrengthMod;

        float angle = noise((p.x + xoff)/noiseScale, (p.y + yoff)/noiseScale) * noiseStrength * TWO_PI;
        p.px = p.x;
        p.py = p.y;

        p.x += cos(angle) * p.step;
        p.y += sin(angle) * p.step;

        if (p.x < 0 || p.x > width || p.y < 0 || p.y > height) {
          p.active = false;
        }

        c.line(p.x, p.y, p.px, p.py);
      }
    }
    break;
  }
  c.endDraw();

  image(c, 0, 0);

  if (alfa > 1) alfa = alfa * .95; // easy non-linear interpolation toward zero
  pushStyle();
  tint(255, alfa);
  image(flash, 0, 0);
  popStyle();
}
