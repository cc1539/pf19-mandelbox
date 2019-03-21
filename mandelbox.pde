
public boolean[] input = new boolean[256];
public int keys_down;

public Camera camera;
public PShader sphere_trace;
public PImage cache;

public void setup()
{
  size(640,640,P3D);
  //((PGraphics2D)g).textureSampling(POINT);
  noSmooth();
  background(0);
  
  surface.setTitle("Raytracing Revisited");
  surface.setResizable(true);
  //surface.setIcon(createImage(1,1,ARGB));
  
  textFont(createFont("courier new bold",12));
  
  float scale = 0;
  sphere_trace = loadShader("frag.glsl","vert.glsl");
  sphere_trace.set("BOX_FOLD",1.0*scale);
  sphere_trace.set("MIN_RADIUS",0.5*scale*scale);
  sphere_trace.set("FIXED_RADIUS",1.0*scale*scale);
  sphere_trace.set("LINEAR_SCALE",0.5*scale);
  sphere_trace.set("SCALE",1.75);
  camera = new Camera(0,0,-500);
}

public void keyPressed()
{
  input[keyCode] = true;
  keys_down++;
}

public void keyReleased()
{
  input[keyCode] = false;
  keys_down--;
}

public void draw()
{
  background(0);
  int w = width;
  int h = height-32;
  float multiplier = (mousePressed||keyDown())?0.5:4;
  if(cache==null || camera.moving) {
    cache = camera.render((int)(w*multiplier),(int)(h*multiplier));
  }
  image(cache,0,32,w,h);
  
  camera.drawGumball(30,height-30,25);
  fill(0);
  noStroke();
  rect(0,0,width,32);
  fill(255);
  textAlign(LEFT,TOP);
  text("Position: "+camera.pos.toString(),4,4);
  text("Rotation: "+camera.ang.toString(),4,18);
  
  handleInput();
}

public boolean keyDown(int c)
{
  if(c>32)c-=32;return input[c];
}

public boolean keyDown()
{
  return keys_down>0;
}

public void handleInput()
{
  float walk_speed = 1.0;
  float turn_speed = 0.02;
  
  if(mousePressed) {
    camera.turnX((mouseX-pmouseX) * turn_speed);
    camera.turnY((mouseY-pmouseY) * turn_speed);
  }
  
  if(keyDown('w')) { camera.walk( walk_speed); }
  if(keyDown('s')) { camera.walk(-walk_speed); }
  if(keyDown('d')) { camera.strafe( walk_speed); }
  if(keyDown('a')) { camera.strafe(-walk_speed); }
  if(keyDown(' ')) {
    camera.move(0,walk_speed,0);
    //camera.move(1e4,0,1e4);
    // this is to see the effects of going very far from the origin
    // where floating point errors will become more apparent
  }
  if(keyDown(SHIFT)) {
    camera.move(0,-walk_speed,0);
  }
  
  sphere_trace.set("SCALE",1.5+(sin(frameCount/100.)*.5+.5)*.5);
}
