#version 450

layout(location = 0) in vec3 fragColor;
layout(location = 1) in vec2 fragTexCoord;
layout(location = 2) in vec3 fragPosition;
layout(location = 3) in vec3 inNormal;
layout(location = 4) in vec3 inBarycentricCoordinate;

layout(binding = 1) uniform sampler2D texSampler;

layout(location = 0) out vec4 outColor;

float computeEdgeFactor(vec3 bCoords) {
    float lineWidth = 0.5;
    // for a "stretched" triangle we will have a "big" derivative for U, V, W in x, y
    // for a "small" triangle a "small" derivative
    vec3 derivative = fwidth(bCoords);

    // we divide by the derivative to be able to compare proximity
    // for differents "stretches" of the edges
    float minU = bCoords.x / derivative.x;
    float minV = bCoords.y / derivative.y;
    float minW = bCoords.z / derivative.z;   

    float minDistance = min(min(minU, minV), minW);

    // use of smoothstep to limit aliasing
    return smoothstep(lineWidth - 1, lineWidth + 1, minDistance);
}

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

    float edgeFactor = computeEdgeFactor(inBarycentricCoordinate);

    outColor = vec4(edgeFactor * (ambient + diffuse), 1.0);
}