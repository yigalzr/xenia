#include "xenos_draw.hlsli"

struct XeHSControlPointOutput {};

struct XeHSConstantDataOutput {
  float edges[3] : SV_TessFactor;
  float inside : SV_InsideTessFactor;
};

XeHSConstantDataOutput XePatchConstant() {
  XeHSConstantDataOutput output = (XeHSConstantDataOutput)0;
  uint i;

  // 1.0 already added to the factor on the CPU, according to the images in
  // https://www.slideshare.net/blackdevilvikas/next-generation-graphics-programming-on-xbox-360
  // (fractional_even also requires a factor of at least 2.0).

  // Don't calculate any variables for SV_TessFactor outside of this loop, or
  // everything will be broken - FXC will add code to make it calculated only
  // once for all 3 fork instances, but doesn't do it properly.
  [unroll] for (i = 0u; i < 3u; ++i) {
    output.edges[i] = xe_tessellation_factor_range.y;
  }

  output.inside = xe_tessellation_factor_range.y;

  return output;
}

[domain("tri")]
[partitioning("fractional_even")]
[outputtopology("triangle_cw")]
[outputcontrolpoints(3)]
[patchconstantfunc("XePatchConstant")]
void main(InputPatch<XeHSControlPointOutput, 3> input_patch) {}
