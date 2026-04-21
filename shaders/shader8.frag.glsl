#version 450

layout(location = 0) in vec3 fragColor;
layout(location = 1) in vec2 fragTexCoord;
layout(location = 2) in vec3 fragPosition;
layout(location = 3) in vec3 inNormal;
layout(location = 4) in vec3 inBarycentricCoordinate;

layout(binding = 1) uniform sampler2D texSampler;

layout(location = 0) out vec4 outColor;

void main() {
    // hardcoded for now
    vec3 lightPosition = vec3(5.0, 5.0, 0.0);
    vec3 lightColor = vec3(1.0, 1.0, 1.0);
    float ambientStrength = 0.1;
    vec3 ambient = ambientStrength * lightColor;
    // All this is taken from learnopengl.com:
    vec3 normal = normalize(inNormal);
    vec3 lightDirection = normalize(lightPosition - fragPosition);
    // If the angle between both vectors is greater than 90 degrees then
    // the result of the dot product will actually become negative and 
    // we end up with a negative diffuse component
    float diffuseComponent = max(dot(normal, lightDirection), 0.0);
    vec3 diffuse = diffuseComponent * lightColor;

    bool fragOnEdge = false;
    // Did not really understand this part
    // I get why we need a derivative, but not how it is calculated
    float lineWidth = 0.5; 
    vec3 derivative = fwidth(inBarycentricCoordinate);

    if ((inBarycentricCoordinate.x < (derivative.x * lineWidth)) 
        || (inBarycentricCoordinate.y < (derivative.y * lineWidth)) 
        || (inBarycentricCoordinate.z < (derivative.z * lineWidth))) {
        fragOnEdge = true;
    }

    // outColor = vec4((ambient + diffuse), 1.0) * texture(texSampler, fragTexCoord);
    if (!fragOnEdge) {
        outColor = vec4((ambient + diffuse), 1.0);
    } else {
        outColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
    // outColor = vec4(1.0);
    // outColor = vec4(normal, 1.0);
    // outColor = vec4(inNormal, 1.0);
    // outColor = vec4(fragPosition, 1.0);
}