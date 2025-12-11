#version 450

layout(location = 0) in vec3 fragColor;
layout(location = 1) in vec2 fragTexCoord;
layout(location = 2) in vec3 fragPosition;
layout(location = 3) in vec3 inNormal;

layout(binding = 1) uniform sampler2D texSampler;

layout(location = 0) out vec4 outColor;

void main() {
    // hardcoded for now
    vec3 lightPosition = vec3(5.0, 5.0, 0.0);
    vec3 lightColor = vec3(0.3, 0.3, 0.3);
    // All this is taken from learnopengl.com:
    vec3 normal = normalize(inNormal);
    vec3 lightDirection = normalize(lightPosition - fragPosition);
    // If the angle between both vectors is greater than 90 degrees then
    // the result of the dot product will actually become negative and 
    // we end up with a negative diffuse component
    float diffuse_component = max(dot(normal, lightDirection), 0.0);
    vec3 diffuse = diffuse_component * lightColor;


    outColor = vec4(diffuse, 1.0) +  texture(texSampler, fragTexCoord);
    // outColor = vec4(diffuse, 1.0);
    // outColor = vec4(1.0);
    // outColor = vec4(normal, 1.0);
    // outColor = vec4(inNormal, 1.0);
    // outColor = vec4(fragPosition, 1.0);
}