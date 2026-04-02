#include <iostream>

// could be only in one file in the project
#define TINYOBJLOADER_IMPLEMENTATION
#include "tiny_obj_loader.h"

#include "model.hpp"


void Model::loadModel(const char* filePath) {
    /**
        * The attrib container holds all of the positions, normals and texture coordinates
        * in its attrib.vertices, attrib.normals and attrib.texcoords vectors.
        * The shapes container contains all of the separate objects and their faces.
        * Each face consists of an array of vertices, and each vertex contains
        * the indices of the position, normal and texture coordinate attributes.
        * OBJ models can also define a material and texture per face, but we will be ignoring those.
        */
    tinyobj::attrib_t attrib;
    std::vector<tinyobj::shape_t> shapes;
    std::vector<tinyobj::material_t> materials;
    std::string warn, err;

    std::cout << "Starting model loading" << std::endl;

    if (!tinyobj::LoadObj(&attrib, &shapes, &materials, &warn, &err, filePath)) {
        throw std::runtime_error(warn + err);
    }


    // We're going to combine all of the faces in the file into a single model, so just iterate over all of the shapes:
    for (const auto& shape : shapes) {
        // The triangulation feature has already made sure that there are three vertices per face,
        // so we can now directly iterate over the vertices and dump them straight into our vertices vector:
        for (const auto& index : shape.mesh.indices) {
            vertex::Vertex vertex{};

                // attrib.vertices array is an array of float values instead of something like glm::vec3
            const auto vertex_x = attrib.vertices[3 * index.vertex_index + 0];
            const auto vertex_y = attrib.vertices[3 * index.vertex_index + 1];
            const auto vertex_z = attrib.vertices[3 * index.vertex_index + 2];

            vertex.pos = {vertex_x, vertex_y, vertex_z};

            // update the bounding box, quick'n dirty way
            if (vertex_x < boundingBox_.min_x_) boundingBox_.min_x_ = vertex_x;
            if (vertex_y < boundingBox_.min_y_) boundingBox_.min_y_ = vertex_y;
            if (vertex_z < boundingBox_.min_z_) boundingBox_.min_z_ = vertex_z;

            if (vertex_x > boundingBox_.max_x_) boundingBox_.max_x_ = vertex_x;
            if (vertex_y > boundingBox_.max_y_) boundingBox_.max_y_ = vertex_y;
            if (vertex_z > boundingBox_.max_z_) boundingBox_.max_z_ = vertex_z;


            // Similarly, there are two texture coordinate components per entry.
            // Texture coordinates (if available)
            if (index.texcoord_index >= 0) {
                vertex.texCoord = {
                    attrib.texcoords[2 * index.texcoord_index + 0], // u
                    // for OBJ format 0 means the bottom of the image
                    // but we've uploaded the image to Vulkan in a top-bottom orientation
                    // so we flip the vertical axis
                    1.0f - attrib.texcoords[2 * index.texcoord_index + 1] // v
                };
            }

            if (index.normal_index >=0) {
                vertex.normal = {
                    attrib.normals[3 * index.normal_index + 0],
                    attrib.normals[3 * index.normal_index + 1],
                    attrib.normals[3 * index.normal_index + 2]
                };
            }

            vertex.color = {1.0f, 1.0f, 1.0f};

            vertices_.push_back(vertex);
            // For simplicity, we will assume that every vertex is unique for now, hence the simple auto-increment indices.
            indices_.push_back(indices_.size());

            
        }
    }

    std::cout << "Model loaded" << std::endl;
    std::cout << "Bounding box: " << std::endl;
    std::cout << "Min x: " << boundingBox_.min_x_ << std::endl;
    std::cout << "Min y: " << boundingBox_.min_y_ << std::endl;
    std::cout << "Min z: " << boundingBox_.min_z_ << std::endl;
    std::cout << "Max x: " << boundingBox_.max_x_ << std::endl;
    std::cout << "Max y: " << boundingBox_.max_y_ << std::endl;
    std::cout << "Max z: " << boundingBox_.max_z_ << std::endl;
}
