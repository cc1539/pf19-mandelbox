uniform vec3 x_line; // x direction
uniform vec3 y_line; // y direction
uniform vec3 z_line; // z direction
uniform vec3 pos; // position
uniform vec2 res; // resolution
uniform float time; // frames elapsed

uniform float BOX_FOLD;
uniform float MIN_RADIUS;
uniform float LINEAR_SCALE;
uniform float FIXED_RADIUS;
uniform float SCALE;

float magnitude(vec3 v)
{
	return sqrt(dot(v,v));
}

vec3 unit(vec3 v)
{
	return v/magnitude(v);
}

float getMandelboxDistance(vec3 pos) {
	vec4 z = vec4(pos,1.0);
	vec4 c = z;
	for(int i=0;i<16;i++) {
		z.xyz = clamp(z.xyz,-BOX_FOLD,BOX_FOLD)*2.0-z.xyz;
		float z2 = dot(z.xyz,z.xyz);
		if(z2<MIN_RADIUS) {
			z *= LINEAR_SCALE;
		} else if(z2<FIXED_RADIUS) {
			z *= FIXED_RADIUS/z2;
		}
		z = SCALE*z+c;
	}
	return length(z.xyz)/abs(z.w);
}

void main()
{
	gl_FragColor = vec4(vec3(0.0,0.0,0.0),1.0);
	
	vec2 offsetScale = (gl_FragCoord.xy/res)*2.0-vec2(1.0);
	vec3 offset = x_line*offsetScale.x + y_line*offsetScale.y;
	
	vec3 rayDir = unit(z_line+offset);
	vec3 rayPos = pos + offset * 10.0 - z_line*10.0;
	
	float distance = 0;
	int i = 0;
	
	for(;i<4096;i++) {
		
		distance = getMandelboxDistance(rayPos);
		
		if(distance<0.01) {
			//gl_FragColor = vec4(vec3(float(i)/128.0),1.0);
			gl_FragColor = vec4((sin(rayPos/10.0)*.5+vec3(.5))*(float(i)/128.0),1.0);
			break;
		} else if(distance>500.0) {
			break;
		}
		rayPos += rayDir * distance;
	}
	
	if(i>=1024) {
		gl_FragColor = vec4(vec3(gl_FragCoord.xy/res,sin(time/100.0)*.5+.5),1.0);
	}
	
}
