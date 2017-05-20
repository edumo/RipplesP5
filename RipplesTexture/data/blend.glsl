#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform sampler2D bgTexture;
uniform vec2 texOffset;

uniform float r;
uniform float g;
uniform float b;

uniform vec2 mouse;
uniform float zmouse;

uniform vec2 resolution;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void) {
    
    vec2 st = vertTexCoord.st;
    
    float offsetX = texture2D(texture, st + vec2(-texOffset.s, 0.0)).r - texture2D(texture, st + vec2(texOffset.s, 0.0)).r;
    float offsetY = texture2D(texture, st + vec2(0.0,- texOffset.t)).r - texture2D(texture, st + vec2(0.0, texOffset.t)).r;
    
    float shading = offsetX;
   //  shading = 0.0;
    
    vec4 pixel = texture2D(bgTexture, st);// + vec2(offsetX, offsetY));
    
    pixel.r += shading;
    pixel.g += shading;
    pixel.b += shading;
    
    gl_FragColor =  pixel;
}
