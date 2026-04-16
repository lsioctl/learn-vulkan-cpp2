#version 450

// layout(location = 0) in vec3 inPosition;
// layout(location = 1) in vec3 inColor;
// layout(location = 2) in vec2 inTexCoord;
// layout(location = 3) in vec3 inNormal;

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

// Scaling and translation
// glm seems to use columns matrices
mat4 modelMatrix = mat4(
    0.2, 0.0, 0.0, 0.0, // col1
    0.0, 0.2, 0.0, 0.0, // col2
    0.0, 0.0, 0.2, 0.0, // col3
    0.8, 0.8, 0.0, 1 // col4
);

void main() {
    // gl_Position = vec4(inPosition, 1.0);
    // fragColor = inColor;
    // The built-in gl_VertexIndex variable contains the index of the current vertex.
    gl_Position = ubo.proj * ubo.view * modelMatrix * vec4(positions[gl_VertexIndex], 1.0);
    fragColor = colors[gl_VertexIndex];
}