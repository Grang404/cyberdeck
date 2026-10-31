const float CA_PX = 1.2;
const float BLOOM_RADIUS = 6.0;
const float BLOOM_STRENGTH = 0.55;
const float BLOOM_THRESHOLD = 0.15;
const int BLOOM_SAMPLES = 24;
const float SCANLINE_STRENGTH = 0.25;
const float SCANLINE_PX = 6.0;
const float ROLL_STRENGTH = 0.04;
const float ROLL_SPEED = 0.08;
const float FLICKER_STRENGTH = 0.02;
const float GLITCH_PER_SEC = 0.4;
const float GLITCH_PX = 12.0;
const float TRAIL_STRENGTH = 0.5;
const float TRAIL_DURATION = 0.25;
const float TRAIL_WIDTH = 0.35;
const float CURSOR_HALO = 0.08;

float hash(float n) {
    return fract(sin(n) * 43758.5453);
}

vec4 sampleCA(vec2 uv, float px) {
    vec2 o = vec2(px / iResolution.x, 0.0);
    vec4 c = texture(iChannel0, uv);
    float r = texture(iChannel0, uv + o).r;
    float b = texture(iChannel0, uv - o).b;
    return vec4(r, c.g, b, c.a);
}

float segDist(vec2 p, vec2 a, vec2 b) {
    vec2 pa = p - a;
    vec2 ba = b - a;
    float h = clamp(dot(pa, ba) / max(dot(ba, ba), 1e-4), 0.0, 1.0);
    return length(pa - ba * h);
}

// Ghostty cursor uniforms are pixel rects: xy = top-left corner (y grows up), zw = size.
vec2 cursorCenter(vec4 c) {
    return c.xy + vec2(c.z * 0.5, -c.w * 0.5);
}

vec3 cursorTrail(vec2 p) {
    vec2 cur = cursorCenter(iCurrentCursor);
    vec2 prev = cursorCenter(iPreviousCursor);
    float cellH = max(iCurrentCursor.w, 1.0);
    vec3 col = iCurrentCursorColor.rgb;

    float t = clamp((iTime - iTimeCursorChange) / TRAIL_DURATION, 0.0, 1.0);
    float ease = 1.0 - pow(1.0 - t, 3.0);
    vec2 tail = mix(prev, cur, ease);

    float d = segDist(p, tail, cur);
    float width = cellH * TRAIL_WIDTH * (1.0 - t);
    float trail = (1.0 - t) * smoothstep(width, 0.0, d);
    trail += (1.0 - t) * 0.15 * exp(-d / (cellH * 0.2));

    float halo = CURSOR_HALO * exp(-length(p - cur) / (cellH * 0.25));

    return col * (trail * TRAIL_STRENGTH + halo);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    // Glitch: time is split into 8 slots per second, each slot has a small
    // chance of displacing one random horizontal band.
    float slot = floor(iTime * 8.0);
    float glitchOn = step(1.0 - GLITCH_PER_SEC / 8.0, hash(slot));
    float bandY = hash(slot + 1.3);
    float bandH = 0.01 + 0.03 * hash(slot + 2.7);
    float inBand = glitchOn * step(abs(uv.y - bandY), bandH);
    uv.x += inBand * (hash(slot + 4.1) - 0.5) * 2.0 * GLITCH_PX / iResolution.x;

    vec4 color = sampleCA(uv, CA_PX + inBand * 3.0);

    // Bloom: golden-angle spiral of samples, only bright pixels contribute.
    vec3 glow = vec3(0.0);
    float total = 0.0;
    for (int i = 0; i < BLOOM_SAMPLES; i++) {
        float fi = float(i);
        float r = sqrt((fi + 0.5) / float(BLOOM_SAMPLES)) * BLOOM_RADIUS;
        float a = fi * 2.39996323;
        vec2 off = vec2(cos(a), sin(a)) * r / iResolution.xy;
        vec3 s = texture(iChannel0, uv + off).rgb;
        float l = dot(s, vec3(0.2126, 0.7152, 0.0722));
        float w = 1.0 - r / (BLOOM_RADIUS + 1.0);
        glow += s * smoothstep(BLOOM_THRESHOLD, BLOOM_THRESHOLD + 0.2, l) * w;
        total += w;
    }
    color.rgb += glow / total * BLOOM_STRENGTH;

    float scanWave = 0.5 + 0.5 * sin(fragCoord.y * 6.28318 / SCANLINE_PX);
    float scan = 1.0 - SCANLINE_STRENGTH * pow(scanWave, 3.0);
    float roll = 1.0 + ROLL_STRENGTH * smoothstep(0.9, 1.0, sin((uv.y + iTime * ROLL_SPEED) * 6.28318));
    float flicker = 1.0 - FLICKER_STRENGTH * hash(floor(iTime * 30.0));
    color.rgb *= scan * roll * flicker;

    color.rgb += cursorTrail(fragCoord);

    // Raise alpha where glow spills onto the transparent background,
    // otherwise the bloom disappears at background-opacity < 1.
    color.a = clamp(max(color.a, max(color.r, max(color.g, color.b))), 0.0, 1.0);

    fragColor = color;
}
