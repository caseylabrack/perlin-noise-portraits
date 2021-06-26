class NoiseWalker {

  float rangex, rangey, speedlow, speedhigh, x, y, angle, px, py, speed, xoff, yoff;
  boolean active = true;

  NoiseWalker (float _rx, float _ry, float _speedlow, float _speedhigh) {
    rangex = _rx; rangey = _ry;
    speedlow = _speedlow; speedhigh = _speedhigh;
    xoff = 0; yoff = 0;
    init();
  }

  void init () {
    //init(0,0);
    x = random(0, rangex);
    y = random(0, rangey);
    px = x;
    py = y;
    speed = random(speedlow, speedhigh);
    active = true;
  }

  void update () {
    if (active == false) return;

    angle = noise((x + xoff)/noiseScale, (y + yoff)/noiseScale) * noiseStrength * TWO_PI;
    px = x;
    py = y;

    x += cos(angle) * speed;
    y += sin(angle) * speed;

    if (x < 0 || x > rangex || y < 0 || y > rangey) {
      active = false;
    }
  }
}
