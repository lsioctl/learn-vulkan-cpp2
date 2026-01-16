#pragma once

#include <vector>
#include <cstdint>

#include "vertex.hpp"

class Model {
public:
    // TODO: clumsy, would be better to load the model in the constructor
    // but don´t want to spend time on C++ patterns for now
    void loadModel(const char* filePath);
    const std::vector<vertex::Vertex>& getVertices() const noexcept {
        return vertices_;
    }
    const std::vector<uint32_t>& getIndices() const noexcept {
        return indices_;
    }
    struct BoundingBox {
        float min_x_;
        float min_y_;
        float min_z_;
        float max_x_;
        float max_y_;
        float max_z_;
    };
    const BoundingBox getBoundingBox() const noexcept {
        return boudingBox_;
    }
    
private:
    std::vector<vertex::Vertex> vertices_;
    std::vector<uint32_t> indices_;
    BoundingBox boudingBox_;
};