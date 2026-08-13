#version 450

// _ prefix for unused layouy locations
layout(location = 0) in vec3 _inPosition;
layout(location = 1) in vec3 _inColor;
layout(location = 2) in vec2 _inTexCoord;
layout(location = 3) in vec3 _inNormal;

layout(binding = 0) uniform UniformBufferObject {
    mat4 model;
    mat4 view;
    mat4 proj;
} ubo;

layout(location = 0) out vec3 fragColor;

// should be in vertex buffer
// but vertex buffer in vk will be seen later on
vec3 positions[36] = vec3[](
    vec3(-0.5, -0.5, 00.5), // 1, bottom left front
    vec3(0.5, -0.5, 0.5), // 2, bottom right front
    vec3(0.5, 0.5, 0.5), // 3 top right front
    vec3(0.5, 0.5, 0.5), // 3 top right front
    vec3(-0.5, 0.5, 0.5), // 4 top left front
    vec3(-0.5, -0.5, 0.5), // 1, bottom left front
    vec3(0.5, 0.5, 0.5), // 3 top right front
    vec3(0.5, -0.5, 0.5), // 2, bottom right front
    vec3(0.5, -0.5, -0.5), // 7, bottom right back
    vec3(0.5, -0.5, -0.5), // 7, bottom right back
    vec3(0.5, 0.5, -0.5), // 6, top right back
    vec3(0.5, 0.5, 0.5), // 3 top right front
    vec3(0.5, 0.5, -0.5), // 6, top right back
    vec3(0.5, -0.5, -0.5), // 7, bottom right back
    vec3(-0.5, -0.5, -0.5), // 8, bottom left back
    vec3(-0.5, -0.5, -0.5), // 8, bottom left back
    vec3(-0.5, 0.5, -0.5), // 5, top right back
    vec3(0.5, 0.5, -0.5), // 6, top right back
    vec3(-0.5, 0.5, -0.5), // 5, top right back
    vec3(-0.5, -0.5, -0.5), // 8, bottom left back
    vec3(-0.5, -0.5, 00.5), // 1, bottom left front
    vec3(-0.5, -0.5, 00.5), // 1, bottom left front
    vec3(-0.5, 0.5, 0.5), // 4 top left front
    vec3(-0.5, 0.5, -0.5), // 5, top right back
    vec3(-0.5, -0.5, -0.5), // 8, bottom left back
    vec3(0.5, -0.5, -0.5), // 7, bottom right back
    vec3(0.5, -0.5, 0.5), // 2, bottom right front
    vec3(0.5, -0.5, 0.5), // 2, bottom right front
    vec3(-0.5, -0.5, 00.5), // 1, bottom left front
    vec3(-0.5, -0.5, -0.5), // 8, bottom left back
    vec3(0.5, 0.5, 0.5), // 3 top right front
    vec3(0.5, 0.5, -0.5), // 6, top right back
    vec3(-0.5, 0.5, -0.5), // 5, top right back
    vec3(-0.5, 0.5, -0.5), // 5, top right back
    vec3(-0.5, 0.5, 0.5), // 4 top left front
    vec3(0.5, 0.5, 0.5) // 3 top right front
);

vec3 colors[36] = vec3[](
    vec3(0.0, 0.0, 0.0), // 1, bottom left front
    vec3(1.0, 0.0, 0.0), // 2, bottom right front
    vec3(1.0, 1.0, 0.0), // 3 top right front
    vec3(1.0, 1.0, 0.0), // 3 top right front
    vec3(0.0, 1.0, 0.0), // 4 top left front
    vec3(0.0, 0.0, 0.0), // 1, bottom left front
    vec3(1.0, 1.0, 0.0), // 3 top right front
    vec3(1.0, 0.0, 0.0), // 2, bottom right front
    vec3(1.0, 0.0, 1.0), // 7, bottom right back
    vec3(1.0, 0.0, 1.0), // 7, bottom right back
    vec3(1.0, 1.0, 1.0), // 6, top right back
    vec3(1.0, 1.0, 0.0), // 3 top right front
    vec3(1.0, 1.0, 1.0), // 6, top right back
    vec3(1.0, 0.0, 1.0), // 7, bottom right back
    vec3(0.0, 0.0, 1.0), // 8, bottom left back
    vec3(0.0, 0.0, 1.0), // 8, bottom left back
    vec3(0.0, 1.0, 1.0), // 5, top right back
    vec3(1.0, 1.0, 1.0), // 6, top right back
    vec3(0.0, 1.0, 1.0), // 5, top right back
    vec3(0.0, 0.0, 1.0), // 8, bottom left back
    vec3(0.0, 0.0, 0.0), // 1, bottom left front
    vec3(0.0, 0.0, 0.0), // 1, bottom left front
    vec3(0.0, 1.0, 0.0), // 4 top left front
    vec3(0.0, 1.0, 1.0), // 5, top right back
    vec3(0.0, 0.0, 1.0), // 8, bottom left back
    vec3(1.0, 0.0, 1.0), // 7, bottom right back
    vec3(1.0, 0.0, 0.0), // 2, bottom right front
    vec3(1.0, 0.0, 0.0), // 2, bottom right front
    vec3(0.0, 0.0, 0.0), // 1, bottom left front
    vec3(0.0, 0.0, 1.0), // 8, bottom left back
    vec3(1.0, 1.0, 0.0), // 3 top right front
    vec3(1.0, 1.0, 1.0), // 6, top right back
    vec3(0.0, 1.0, 1.0), // 5, top right back
    vec3(0.0, 1.0, 1.0), // 5, top right back
    vec3(0.0, 1.0, 0.0), // 4 top left front
    vec3(1.0, 1.0, 0.0) // 3 top right front
);

void main() {
    // gl_Position = vec4(inPosition, 1.0);
    // fragColor = inColor;
    // The built-in gl_VertexIndex variable contains the index of the current vertex.
    // The scaling and the placement used to be hardcoded here, they now come from
    // the uniform: ubo.model only scales the cube, and ubo.view holds the camera
    // orientation followed by a fixed offset in view space, which is what keeps
    // the cube at the same place on screen (see updateAxisUniformBuffer)
    gl_Position = ubo.proj * ubo.view * ubo.model * vec4(positions[gl_VertexIndex], 1.0);
    fragColor = colors[gl_VertexIndex];
}