// GLSL version of Conway's game of life, ported from GLSL sandbox:
// http://glsl.heroku.com/e#207.3
// Exemplifies the use of the ppixels uniform in the shader, that gives
// access to the pixels of the previous frame.
PShader conway;
PGraphics pg;
PGraphics pg2;
PGraphics pg3;

int pingpong = 0;

//Using three FBO because I can't use the current

void setup() {
  size(400, 400, P3D);    
  pg = createGraphics(400, 400, P2D);
  pg.noSmooth();
  pg.beginDraw();
  pg.background(0);
  pg.endDraw();

  pg2 = createGraphics(400, 400, P2D);
  pg2.noSmooth();
  pg2.beginDraw();
  pg2.background(0);
  pg2.endDraw();

  pg3 = createGraphics(400, 400, P2D);
  pg3.noSmooth();
  pg3.beginDraw();
  pg3.background(0);
  pg3.endDraw();

  conway = loadShader("ripples.glsl");
  conway.set("resolution", float(pg.width), float(pg.height));
}

void draw() {
  conway.set("time", millis()/1000.0);
  float x = map(mouseX, 0, width, 0, 1);
  float y = map(mouseY, 0, height, 1, 0);

  PGraphics pgTemp = null;
  PGraphics pgLast = null;
  PGraphics pgLast2 = null;

  int pingpongSize = 3;

  PGraphics[] pgs = {pg, pg2, pg3};

  pgTemp = pgs[pingpong%pingpongSize];
  pgLast = pgs[(pingpong+1)%pingpongSize];
  pgLast2 = pgs[(pingpong+2)%pingpongSize];

  pingpong++;// = !pingpong;

  conway.set("mouse", x, y);  
  conway.set("currenttexture", pgLast);
  conway.set("lasttexture", pgLast2);
  conway.set("damping", 0.990);
  pgTemp.beginDraw();
  pgTemp.background(0);
  pgTemp.shader(conway);
  pgTemp.rect(0, 0, pg.width, pg.height);
  pgTemp.endDraw();  
  image(pgTemp, 0, 0, width, height);
  text(frameRate, 10, 10);
  frameRate(25);
}