cmake_minimum_required(VERSION 3.14)
project(MyVulkanApp)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# very weird it doesn´t work later on this file ...
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Find required packages
find_package(glfw3 REQUIRED)
find_package(Vulkan REQUIRED)

# Platform-specific configurations
if(UNIX AND NOT APPLE)
    # Linux configuration
    find_package(X11 REQUIRED)
    # find_package(Xrandr REQUIRED)
    message(STATUS "Linux configuration detected")
elseif(APPLE)
    # macOS configuration
    find_package(Cocoa REQUIRED)
    message(STATUS "macOS configuration detected")
else()
    message(FATAL_ERROR "Unsupported platform")
endif()

file(GLOB SOURCES "*.cpp")

add_executable(${PROJECT_NAME} ${SOURCES})

# Link libraries
target_link_libraries(${PROJECT_NAME}
    PRIVATE
    glfw
    ${Vulkan_LIBRARIES}
)

# Headers only libraries
# disable thirdparty warnings with -isystem compiler option
include_directories(
    SYSTEM
    thirdparties/include
)

# Platform-specific linking
if(UNIX AND NOT APPLE)
    # Linux linking
    target_link_libraries(${PROJECT_NAME}
        PRIVATE
        X11::X11
        X11::Xrandr
    )
elseif(APPLE)
    # macOS linking
    target_link_libraries(${PROJECT_NAME}
        PRIVATE
        Cocoa::Cocoa
    )
endif()

# Include directories
target_include_directories(${PROJECT_NAME}
    PRIVATE
    ${Vulkan_INCLUDE_DIRS}
    ${GLFW_INCLUDE_DIRS}
)

# For macOS, we need to set the macOS deployment target
if(APPLE)
    set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15") # macOS Catalina
endif()

# For Vulkan, we need to specify the Vulkan SDK path
if(NOT Vulkan_FOUND)
    message(FATAL_ERROR "Vulkan SDK not found. Please install it from https://vulkan.lunarg.com/")
endif()