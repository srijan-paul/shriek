return love.graphics.newShader([[
extern float los_radius;
extern vec2 los_center;
extern bool los_on;

vec4 get_lum(vec4 color) {
  float grayscale = (color.r + color.g + color.b) / 3.0;
  return vec4(grayscale, grayscale, grayscale, color.a);
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {

  vec4 pixel = Texel(texture, texture_coords);

  // if LOS is off then 
  
  float dist = distance(los_center, screen_coords);
  
  // as dist goes from 0 to los_radius, alpha goes from 1.0 to 0.0

  float diff = los_radius - dist;
  color.a = clamp(diff / los_radius, 0.08, 1.0);

  if (dist > los_radius) {
    if (!los_on) return pixel * vec4(0);
    vec4 final = pixel * color;
    return get_lum(final);
  }

  if (!los_on) {
    color.a = 0.12;
    return pixel * color;
  }

  return pixel * color;
}
]])
