NoiseWalker[] walkers = new NoiseWalker[10000];
PGraphics c;
float noiseScale;
float noiseStrength;

void setup () {
  //size(500,500,P2D);
  fullScreen(P2D);
  for (int i = 0; i < walkers.length; i++) walkers[i] = new NoiseWalker(width, height, 1, 5);

  c = createGraphics(width, height, P2D);
  c.beginDraw();
  c.colorMode(HSB, 360, 100, 100, 1);
  c.noFill();
  c.endDraw();
  init();
}

void init () {
  noiseSeed((int)random(1e6));
  noiseScale = random(100, 500);
  noiseStrength = random(1, 10);

  c.beginDraw();
  if (random(1) > .66) {
    c.background(0, 0, 0, 1);
    c.blendMode(ADD);
    c.stroke(random(360), 70, 80, .25);
  } else {
    c.background(0, 0, 100, 1);
    c.blendMode(MULTIPLY);
    c.stroke(random(360), 70, 80, .1);
  }
  c.endDraw();

  for (int i = 0; i < walkers.length; i++) walkers[i].init();

  //println(noiseScale + "  " + noiseStrength);
}

void touchStarted() {
  init();
}

void mouseClicked() {
  init();
}

void draw () {

  for (NoiseWalker w : walkers) w.update();

  c.beginDraw();
  for (int i = 0; i < walkers.length; i++) {
    if (walkers[i].active==false) continue;
    c.line(walkers[i].x, walkers[i].y, walkers[i].px, walkers[i].py);
  }
  c.endDraw();

  image(c, 0, 0);
}
