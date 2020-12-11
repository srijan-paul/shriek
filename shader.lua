return love.graphics.newShader([[
extern float LoS_radius;
extern vec2 LoS_center;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
  float dist = distance(LoS_center, screen_coords);
  
  // as dist goes from 0 to LoS_radius, alpha goes from 1.0 to 0.0

  float diff = LoS_radius - dist;
  color.a = clamp(diff / LoS_radius, 0.08, 1.0);
  vec4 pixel = Texel(texture, texture_coords);

  if (dist > LoS_radius) {
    vec4 final = pixel * color;
    float grayscale = (final.r + final.g + final.b) / 3.0;
    return vec4(grayscale, grayscale, grayscale, final.a);
  }

  return pixel * color;
}
]])

