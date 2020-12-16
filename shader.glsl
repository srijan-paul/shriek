// NOTE: this isn't actually a GLSL shader
// It's actually written in LSL (The LOVE shading language)
// I just put this in a different file to get some
// syntax highlighting.
extern float los_radius;
extern vec2 los_center;

vec4 effect(vec4 color, Image texture, vec2 texture_coords,
            vec2 screen_coords) {
  float dist = distance(los_center, screen_coords);

  // as dist goes from 0 to los_radius, alpha goes from 1.0 to 0.0

  float diff = los_radius - dist;
  color.a = clamp(diff / los_radius, 0.08, 1.0);
  vec4 pixel = Texel(texture, texture_coords);

  if (dist > los_radius) {
    vec4 final = pixel * color;
    float grayscale = (final.r + final.g + final.b) / 3.0;
    return vec4(grayscale, grayscale, grayscale, final.a);
  }

  return pixel * color;
}