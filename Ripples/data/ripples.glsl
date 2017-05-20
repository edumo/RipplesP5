

#ifdef GL_ES
precision highp float;
#endif

#define PROCESSING_COLOR_SHADER

uniform float time;
uniform float damping;

uniform vec2 resolution;

uniform sampler2D currenttexture;
uniform sampler2D lasttexture;

vec4 live = vec4(1.,1.0,1.0,1.);
vec4 dead = vec4(0.,0.,0.,1.);
vec4 blue = vec4(0.,0.,1.,1.);

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;

	vec2 offset[4];

 	offset[0] = pixel  * vec2(-1.0, 0.0);
        offset[1] = pixel  * vec2(1.0, 0.0);
        offset[2] = pixel  * vec2(0.0, 1.0);
        offset[3] = pixel  * vec2(0.0, -1.0);
        
        float sum2 =  0.0;
        
        for (int i = 0; i < 4 ; i++){
            sum2 += texture2D(lasttexture , position + offset[i]).r;
        }
        
        sum2 = (sum2 / 2.0) - texture2D(currenttexture, position).r;
        sum2 *= damping;



	gl_FragColor = vec4(sum2,sum2,sum2, 1.0);
	
}
