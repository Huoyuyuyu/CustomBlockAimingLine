#version 150

#moj_import <fog.glsl>
const vec4 Color0 = vec4(255, 175, 175, 255) /255; 
const vec4 Color1 = vec4(175, 255, 175, 255) /255; 
const vec4 Color2 = vec4(175, 175, 255, 255) /255;
// 组成渐变的三种颜色   使用RGB格式   第四个值是透明度, 别管就行
const float Duration = 3.0;
// 一次循环的时间, 单位: 秒
const float PosImpact = 0.2;
// 位置对渐变的影响程度

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;
// 全局量:时间 游戏中每经过1天(1200秒)加1

in float vertexDistance;
in vec4 vertexColor;
in vec3 pos;

out vec4 fragColor;

void main() {

    vec4 color = vertexColor * ColorModulator;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    // 原版内容

    if(color.a!=1){
    // 该着色器所控制的内容中, 只有“玩家瞄准线”的透明度不为1, 直接判断
        float dur = Duration/3;
        float t = mod(GameTime * 1200 + (pos.x + pos.y + pos.z)*PosImpact*Duration, Duration);
        // 让t每经过1秒加1 直到一次循环结束 再加上位置信息        
        if(t<dur){
            fragColor = Color0 + t/dur*(Color1 - Color0);
        }else if(t<2*dur){
            t -= dur;
            fragColor = Color1 + t/dur*(Color2 - Color1);
        }else{
            t -= 2*dur;
            fragColor = Color2 + t/dur*(Color0 - Color2);
        }
        //分三部分进行线性插值
    };
};


