
public class Camera
{
  private boolean moving;
  
  public class vec3
  {
    public double x;
    public double y;
    public double z;
    
    public vec3(double x, double y, double z)
    {
      this.x = x;
      this.y = y;
      this.z = z;
    }
    
    public vec3(vec3 v)
    {
      this(v.x,v.y,v.z);
    }
    
    public vec3() {}
    
    public vec3 add(double a,double b,double c){return new vec3(x+a,y+b,z+c);}
    public vec3 sub(double a,double b,double c){return new vec3(x-a,y-b,z-c);}
    public vec3 mul(double a,double b,double c){return new vec3(x*a,y*b,z*c);}
    public vec3 div(double a,double b,double c){return new vec3(x/a,y/b,z/c);}
    public vec3 add(vec3 v){return add(v.x,v.y,v.z);}
    public vec3 sub(vec3 v){return sub(v.x,v.y,v.z);}
    public vec3 mul(vec3 v){return mul(v.x,v.y,v.z);}
    public vec3 div(vec3 v){return div(v.x,v.y,v.z);}
    public vec3 mul(double s){return mul(s,s,s);}
    public vec3 div(double s){return div(s,s,s);}
    
    public vec3 rotateX(double theta)
    {
      if(theta!=0) {
        double s = Math.sin(theta);
        double c = Math.cos(theta);
        return new vec3(x,c*y+s*z,-s*y+c*z);
      }
      return new vec3(this);
    }
    
    public vec3 rotateY(double theta)
    {
      if(theta!=0) {
        double s = Math.sin(theta);
        double c = Math.cos(theta);
        return new vec3(-s*z+c*x,y,c*z+s*x);
      }
      return new vec3(this);
    }
    
    public vec3 rotateZ(double theta)
    {
      if(theta!=0) {
        double s = Math.sin(theta);
        double c = Math.cos(theta);
        return new vec3(c*x+s*y,-s*x+c*y,z);
      }
      return new vec3(this);
    }
    
    public vec3 degrees()
    {
      return new vec3(
        (int)(x/TWO_PI*360),
        (int)(y/TWO_PI*360),
        (int)(z/TWO_PI*360)
      );
    }
    
    public vec3 radians()
    {
      return mul(TWO_PI/360);
    }
    
    public String toString()
    {
      return x+", "+y+", "+z;
    }
    
    public PVector toPVector()
    {
      return new PVector((float)x,(float)y,(float)z);
    }
    
  }
  
  private vec3 pos;
  private vec3 ang;
  
  public Camera(double x, double y, double z)
  {
    pos = new vec3(x,y,z);
    ang = new vec3();
  }
  
  public Camera()
  {
    this(0,0,0);
  }
  
  public vec3 getDirection(vec3 lookVector)
  {
    return lookVector
      .rotateZ(ang.z)
      .rotateX(ang.x)
      .rotateY(ang.y);
  }
  
  public vec3 getDirection(double x, double y, double z)
  {
    return getDirection(new vec3(x,y,z));
  }
  
  public vec3 getDirection()
  {
    return getDirection(0,0,1);
  }
  
  public void walk(double speed)
  {
    move(getDirection().mul(speed));
    moving = true;
  }
  
  public void strafe(double speed)
  {
    move(getDirection(1,0,0).mul(speed));
    moving = true;
  }
  
  public void move(double dx, double dy, double dz)
  {
    pos.x += dx;
    pos.y += dy;
    pos.z += dz;
    moving = true;
  }
  
  public void move(vec3 v)
  {
    move(v.x,v.y,v.z);
  }
  
  public void turnX(float theta)
  {
    ang.y -= theta;
    moving = true;
  }
  
  public void turnY(float theta)
  {
    ang.x -= theta;
    moving = true;
  }
  
  public void drawGumball(float x, float y, double length)
  {
    vec3 x_line = getDirection(1,0,0).mul(1,-1,0).mul(length).add(x,y,0);
    vec3 y_line = getDirection(0,1,0).mul(1,-1,0).mul(length).add(x,y,0);
    vec3 z_line = getDirection(0,0,1).mul(1,-1,0).mul(length).add(x,y,0);
    
    stroke(127,0,0); line(x,y,(float)x_line.x,(float)x_line.y);
    stroke(0,127,0); line(x,y,(float)y_line.x,(float)y_line.y);
    stroke(0,0,127); line(x,y,(float)z_line.x,(float)z_line.y);
    
    textAlign(CENTER,CENTER);
    fill(255,0,0); text("x",(float)x_line.x,(float)x_line.y);
    fill(0,255,0); text("y",(float)y_line.x,(float)y_line.y);
    fill(0,0,255); text("z",(float)z_line.x,(float)z_line.y);
  }
  
  public PImage render(int width, int height)
  {
    moving = false;
    
    sphere_trace.set("x_line",getDirection(1,0,0).toPVector());
    sphere_trace.set("y_line",getDirection(0,1,0).toPVector());
    sphere_trace.set("z_line",getDirection(0,0,1).toPVector());
    sphere_trace.set("pos",pos.toPVector());
    sphere_trace.set("res",(float)width,(float)height);
    sphere_trace.set("time",(float)frameCount);
    
    PGraphics canvas = createGraphics(width,height,P2D);
    canvas.beginDraw();
    canvas.shader(sphere_trace);
    canvas.rect(0,0,width,height);
    canvas.endDraw();
    
    return canvas.get();
  }
  
}
