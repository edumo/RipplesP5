// GLSL version of Conway's game of life, ported from GLSL sandbox:
// http://glsl.heroku.com/e#207.3
// Exemplifies the use of the ppixels uniform in the shader, that gives
// access to the pixels of the previous frame.
PShader conway;
PGraphics pg;
PGraphics pg2;
PGraphics pg3;
PGraphics target;

int pingpong = 0;
float damping = 0.990;

PShader blend;  
PImage bg;

//Using three FBO because I can't use the current

int w= 400;
int h = 400;

void setup() {
  size(800, 400, P3D);  

  bg = loadImage("rocks.jpg");
  bg.resize(w, h);

  pg = createGraphics(w, h, P2D);
  pg.noSmooth();
  pg.beginDraw();
  pg.background(0);
  pg.endDraw();

  pg2 = createGraphics(w, h, P2D);
  pg2.noSmooth();
  pg2.beginDraw();
  pg2.background(0);
  pg2.endDraw();

  pg3 = createGraphics(w, h, P2D);
  pg3.noSmooth();
  pg3.beginDraw();
  pg3.background(0);
  pg3.endDraw();

  target = createGraphics(w, h, P2D);
  target.noSmooth();
  target.beginDraw();
  target.background(0);
  target.endDraw();

  conway = loadShader("ripples.glsl");
  conway.set("resolution", float(pg.width), float(pg.height));

  blend = loadShader("blend.glsl");
  

  
}

void draw() {
  
  PGraphics pgTemp = null;
  PGraphics pgLast = null;
  PGraphics pgLast2 = null;

  int pingpongSize = 3;

  PGraphics[] pgs = {pg, pg2, pg3};

  pgTemp = pgs[pingpong%pingpongSize];
  pgLast = pgs[(pingpong+1)%pingpongSize];
  pgLast2 = pgs[(pingpong+2)%pingpongSize];

  pingpong++;// = !pingpong;


  conway.set("currenttexture", pgLast);
  conway.set("lasttexture", pgLast2);
  conway.set("damping", damping);

  pgLast2.beginDraw();

  pgLast2.resetShader();
  if (pmouseX != mouseX) {
    pgLast2.fill(255);
    pgLast2.ellipse(mouseX, mouseY, 5, 5);
    pgLast2.ellipse(mouseX+100, mouseY, 5, 5);
  }
  pgLast2.endDraw();

  pgTemp.beginDraw();
  pgTemp.background(0);
  pgTemp.shader(conway);
  pgTemp.rect(0, 0, pg.width, pg.height);
  pgTemp.endDraw();  

  blend.set("bgTexture", bg);
  target.beginDraw();
  target.shader(blend);
  target.image(pgTemp, 0, 0);
  target.endDraw();
  image(target, bg.width, 0);
  
  image(pgTemp,0, 0);
  text(frameRate+"\ndamping "+damping, 10, 10);
}

void keyPressed() {
  if (keyCode == UP) {
    damping+=0.005;
  } else {
    damping-=0.005;
  }
}