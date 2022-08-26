#define product(a, b) vec2(a.x*b.x-a.y*b.y, a.x*b.y+a.y*b.x)
#define conjugate(a) vec2(a.x,-a.y)
#define divide(a, b) vec2(((a.x*b.x+a.y*b.y)/(b.x*b.x+b.y*b.y)),((a.y*b.x-a.x*b.y)/(b.x*b.x+b.y*b.y)))

const int ITERATIONS = 256;
const bool SHOW_OVERLAY = true; // Show both sets over each other
const vec3 COLOUR = vec3(0.5,0.3,0.7); // Shading colour

float mandelbrot(vec2 p, int iterations) {
    vec2 c = p;
    vec2 z = vec2(0.0);

    for(int i=0; i<iterations; i++) {
        z = product(z,z) + c;
        if (z.x*z.x+z.y*z.y > 4.) return float(i);
    }
    return float(0.0);
}

float julia(vec2 m, vec2 p, int iterations) {
    vec2 c = m;
    vec2 z = p;

    for(int i=0; i<iterations; i++) {
        z = product(z,z) + c;
        if (abs(z.x) > 4.) return float(i);
    }
    return 0.0;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.y - .5 ; uv.x -= .4 ; uv *= 2.5; // Centralize uv and mouse coordinates
    vec4 m = iMouse / iResolution.y - .5 ; m.x -= .4 ; m *= 2.5;
    float l = mandelbrot(uv.xy, ITERATIONS);
    if( m.z>0.0 ) { l = julia(m.xy, uv.xy, ITERATIONS) + l * 0.05 * float(SHOW_OVERLAY); } // Show Julia set when mouse down

    vec3 col = vec3(10.0*l/float(ITERATIONS)) * COLOUR; // Apply colouring

    fragColor = vec4(col,1.0);
}