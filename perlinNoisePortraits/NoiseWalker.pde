class NoiseWalker {

  float rangex, rangey, speedlow, speedhigh, x, y, angle, px, py, speed;
  boolean active = true;

  NoiseWalker (float _rx, float _ry, float _speedlow, float _speedhigh) {
    rangex = _rx; rangey = _ry;
    speedlow = _speedlow; speedhigh = _speedhigh;
    init();
  }

  void init () {
    x = random(0, rangex);
    y = random(0, rangey);
    px = x;
    py = y;
    speed = random(speedlow, speedhigh);
    active = true;
  }

  void update () {
    if (active == false) return;

    angle = noise(x/noiseScale, y/noiseScale) * noiseStrength * TWO_PI;
    px = x;
    py = y;

    x += cos(angle) * speed;
    y += sin(angle) * speed;

    if (x < 0 || x > rangex || y < 0 || y > rangey) {
      active = false;
    }
  }
}
