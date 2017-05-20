// Conway's game of life

#ifdef GL_ES
precision highp float;
#endif

#define PROCESSING_COLOR_SHADER

uniform float time;
uniform float damping;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D currenttexture;
uniform sampler2D lasttexture;

vec4 live = vec4(0.5,1.0,0.7,1.);
vec4 dead = vec4(0.,0.,0.,1.);
vec4 blue = vec4(0.,0.,1.,1.);

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 pixel = 1./resolution;

	if (length(position-mouse) < 0.01) {
		float rnd1 = mod(fract(sin(dot(position + time * 0.001, vec2(14.9898,78.233))) * 43758.5453), 1.0);
		if (rnd1 > 0.5) {
			gl_FragColor = live;
		} else {
			gl_FragColor = blue;
		}
	} else {
		float sum = 0.;
		sum += texture2D(currenttexture, position + pixel * vec2(-1., -1.)).g;
		sum += texture2D(currenttexture, position + pixel * vec2(-1., 0.)).g;
		sum += texture2D(currenttexture, position + pixel * vec2(-1., 1.)).g;
		sum += texture2D(currenttexture, position + pixel * vec2(1., -1.)).g;
		sum += texture2D(currenttexture, position + pixel * vec2(1., 0.)).g;
		sum += texture2D(currenttexture, position + pixel * vec2(1., 1.)).g;
		sum += texture2D(currenttexture, position + pixel * vec2(0., -1.)).g;
		sum += texture2D(currenttexture, position + pixel * vec2(0., 1.)).g;
		vec4 me = texture2D(currenttexture, position);

vec2 offset[4];

 	offset[0] = pixel  * vec2(-1.0, 0.0);
        offset[1] = pixel  * vec2(1.0, 0.0);
        offset[2] = pixel  * vec2(0.0, 1.0);
        offset[3] = pixel  * vec2(0.0, -1.0);
        
        vec3 sum2 = vec3(0.0, 0.0, 0.0);
        
        for (int i = 0; i < 4 ; i++){
            sum2 += texture2D(lasttexture , position + offset[i]).rgb;
        }
        
        sum2 = (sum2 / 2.0) - texture2D(currenttexture, position).rgb;
        sum2 *= damping;


		if (me.g <= 0.1) {
			if ((sum >= 2.9) && (sum <= 3.1)) {
				gl_FragColor = live;
			} else if (me.b > 0.004) {
				gl_FragColor = vec4(0., 0., max(me.b - 0.004, 0.25), 0.);
			} else {
				gl_FragColor = dead;
			}
		} else {
			if ((sum >= 1.9) && (sum <= 3.1)) {
				gl_FragColor = live;
			} else {
				gl_FragColor = blue;
			}
		}

 gl_FragColor = vec4(sum2, 1.0);
	}
}