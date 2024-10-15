#include <metal_stdlib>

using namespace metal;

// Rec 709
constant half4x4 rec709 = half4x4(
    1.0f, 0.0f, 1.5748f, -0.790488f,
    1.0f, -0.187324f, -0.468124f, 0.329010f,
    1.0f, 1.855600f, 0.0f, -0.931439f,
    0.0f, 0.0f, 0.0f, 1.0f,
);

kernel void
nv12ToBgra(texture2d<half, access::read> yTexture [[texture(0)]],
           texture2d<half, access::read> uvTexture [[texture(1)]],
           texture2d<half, access::write> outTexture [[texture(2)]],
           uint2 gid [[thread_position_in_grid]])
{
    half y = yTexture.read(gid).r;
    half2 uv = uvTexture.read(gid / 2).rg;
    half4 yuv = half4(y, uv.r, uv.g, 1.0);
    half4 rgba = rec709 * yuv;
    outTexture.write(rgba, gid);
}