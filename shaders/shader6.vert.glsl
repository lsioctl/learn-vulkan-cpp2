#version 450

/** 
* Note that dvec3, 64 bits use multiple slots
* layout(location = 0) in dvec3 inPosition;
* layout(location = 2) in vec3 inColor;
*/
layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inColor;
layout(location = 2) in vec2 inTexCoord;
layout(location = 3) in vec3 inNormal;

layout(binding = 0) uniform UniformBufferObject {
    mat4 model;
    mat4 view;
    mat4 proj;
} ubo;

layout(location = 0) out vec3 fragColor;
layout(location = 1) out vec2 fragTexColor;
layout(location = 2) out vec3 fragPosition;
layout(location = 3) out vec3 outNormal;

void main() {
    gl_Position = ubo.proj * ubo.view * ubo.model * vec4(inPosition, 1.0);
    // lightning calculations will be in world space so keep this for the frag shader
    // TODO: how the vec3 conversion works here ?
    fragPosition = vec3(ubo.model * vec4(inPosition, 1.0));
    fragColor = inColor;
    fragTexColor = inTexCoord;
    outNormal = inNormal;
}