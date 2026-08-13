#pragma once

#include "glm/glm.hpp" // IWYU pragma: keep

class Camera
{
private:
    // Create all the vectors that form the intial view/camera space
    glm::vec3 position_;
    glm::vec3 front_;
    glm::vec3 up_;
    bool first_mouse_event_;
    float yaw_;
    float pitch_;
    float sensitivity_;
    float last_mouse_x_;
    float last_mouse_y_;
    double speed_coeff_;
    // View matrix
    // transform from world coordinate to 'camera' coordinates
    glm::mat4 view_matrix_{};
public:
    Camera();
    enum Movement {
        Front,
        Back,
        Right,
        Left
    };
    void updatePosition(Movement camera_movement, double delta_time);
    void resetLastMouseEvent();
    /** 
     * TODO: why not delta_time dependant ?
     * maybe it is a silly question
     * and anyway it would involve tricks with glfw window user pointer
     * ... but doable
     * remark: maybe not as it is a callback, so by it self related
     * to delta time ?
     * */
    void updateOrientation(double mouse_x_pos, double mouse_y_pos);
    // Update the LookAt with position, orientation, ... and return it
    const glm::mat4& getUpdatedViewMatrix();
    const glm::vec3& getPosition() const;
    const glm::vec3& getFront() const;
    float getYaw() const;
    float getPitch() const;
};