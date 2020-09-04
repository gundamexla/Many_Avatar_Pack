
#include "YMT_Common.cginc"

YMT_VertexOutput vert (YMT_VertexInput v) {
    v.isCullBack = 1;
    return vertForward(v);
}

half4 frag (YMT_VertexOutput i) : SV_Target {
    return fragForward(i);
}