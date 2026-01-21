# Learn Vulkan cpp 2

Continuation of following the tutorial in the repo learn-vulkan-cpp


## Reference doc

https://vulkan-tutorial.com

## Ubuntu

### Pre-requisities

```bash
sudo apt install vulkan-tools
sudo apt install libvulkan-dev
# sudo apt install vulkan-validationlayers-dev
sudo apt install vulkan-utility-libraries-dev 
sudo apt install spirv-tools 
sudo apt install libglfw3-dev
sudo apt install libglm-dev
sudo apt install libxxf86vm-dev libxi-dev
```

Note: missing validation layers (commented out because I had issues with apt) so:

```bash
sudo apt-get install vulkan-validationlayers
```

### Prime

Same as for learnopengl, on my Ubuntu with prime, by default the code runs
on embedded GPU on my laptop.

That's because:

* I pick up the first Vulkan capable device
* And the first one is intel on my laptop

For now, same kind of solution as with OpenGL:

https://www.tuxedocomputers.com/en/PRIME-GPU-Render-Offloading/GPU-on-demand-Mode-Guide.tuxedo

```bash
__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia DRI_PRIME=1 thebinary
```

TODO: copy/paste the quick and dirty hack I used for vscode and opengl to pass those env variables

Note: `vkcube` does a better job as it runs on nvidia first

## MacOS

Work in progress

## Install all via brew

* vulkan (TODO: which ones)
* molten
* glfw
* glm

## glslc

Download from github README

Update the `env` copied from `env.example` in shaders folder

## shader compilation

go to the shaders folder, with glslc installed and configured anr run:

```bash
./compile.sh
```

## Coding style

At first wanted to use google's style, but to mostly stick with the tutorial (and glfw, vk style):

* snakecase for vars
* `_` suffix for private var
* snakecase for functions

## Concepts learned

### Image layout transition

either explicitely with pipeline memory barriers or implicitely during render passes

## Real life recommandations

### Staging buffer

> It should be noted that in a real world application, you're not supposed to actually call vkAllocateMemory for every individual buffer. The maximum number of simultaneous memory allocations is limited by the maxMemoryAllocationCount physical device limit, which may be as low as 4096 even on high end hardware like an NVIDIA GTX 1080. The right way to allocate memory for a large number of objects at the same time is to create a custom allocator that splits up a single allocation among many different objects by using the offset parameters that we've seen in many functions.

> You can either implement such an allocator yourself, or use the VulkanMemoryAllocator library provided by the GPUOpen initiative. However, for this tutorial it's okay to use a separate allocation for every resource, because we won't come close to hitting any of these limits for now.

Note: issue encounterd with lucy obj, as vertices + indices where slightly above 4GB, the size of my GPU's RAM.

For now I did a quick'n dirty hook, loading indices on host RAM and vertices on GPU RAM.

Testes on Blender, which uses vk_mem_alloc.h (VulkanMemoryAllocator), it works without any issues


### Index buffer

> The previous chapter already mentioned that you should allocate multiple resources like buffers from a single memory allocation, but in fact you should go a step further. Driver developers recommend that you also store multiple buffers, like the vertex and index buffer, into a single VkBuffer and use offsets in commands like vkCmdBindVertexBuffers. The advantage is that your data is more cache friendly in that case, because it's closer together. It is even possible to reuse the same chunk of memory for multiple resources if they are not used during the same render operations, provided that their data is refreshed, of course. This is known as aliasing and some Vulkan functions have explicit flags to specify that you want to do this.


### Uniforms

In vertex shader:

> Unlike the 2D triangles, the last component of the clip coordinates may not be 1, which will result in a division when converted to the final normalized device coordinates on the screen. This is used in perspective projection as the perspective division and is essential for making closer objects look larger than objects that are further away.

> Using a UBO this way is not the most efficient way to pass frequently changing values to the shader. A more efficient way to pass a small buffer of data to shaders are push constants. We may look at these in a future chapter.

> As some of the structures and function calls hinted at, it is actually possible to bind multiple descriptor sets simultaneously. You need to specify a descriptor layout for each descriptor set when creating the pipeline layout. Shaders can then reference specific descriptor sets like this:

```glsl
layout(set = 0, binding = 0) uniform UniformBufferObject { ... }
```

### mipmaps

> It should be noted that it is uncommon in practice to generate the mipmap levels at runtime anyway. Usually they are pregenerated and stored in the texture file alongside the base level to improve loading speed Implementing resizing in software and loading multiple levels from a file is left as an exercise to the reader.

### RAII and more

Another doc from Vulkan, with:


https://docs.vulkan.org/tutorial/latest/00_Introduction.html


> Compared to the original tutorial, this version of the tutorial is teaching up-to-date concepts:
>
>  Vulkan 1.4 as a baseline
>
>  Dynamic rendering instead of render passes
>
>   Timeline semaphores
>
>   Slang as the primary shading language
>
>   Modern C++ (20) with modules
>
>   Vulkan-Hpp with RAII



### Smart pointers and C API

```c++
// From SO https://stackoverflow.com/questions/35793672/use-unique-ptr-with-glfwwindow
// because the error was not easy to read
struct DestroyglfwWin{
    void operator()(GLFWwindow* ptr){
         glfwDestroyWindow(ptr);
    }
};

// class member declaration, can't assign value at this point
std::unique_ptr<GLFWwindow, DestroyglfwWin> window_;

// somehere in a init window function
window_ = std::unique_ptr<GLFWwindow, DestroyglfwWin>(glfwCreateWindow(WIDTH, HEIGHT, "Vulkan", nullptr, nullptr));
```

### Qt

* Simple Window class: https://doc.qt.io/qt-6/qvulkanwindow.html
* default renderpass
* more advanced example: https://doc.qt.io/qt-6/qtgui-hellovulkancubes-example.html

> QVulkanWindow is a Vulkan-capable QWindow that manages a Vulkan device, a graphics queue, a command pool and buffer, a depth-stencil image and a double-buffered FIFO swapchain, while taking care of correct behavior when it comes to events like resize, special situations like not having a device queue supporting both graphics and presentation, device lost scenarios, and additional functionality like reading the rendered content back. Conceptually it is the counterpart of QOpenGLWindow in the Vulkan world.

Note: QVulkanWindow does not always eliminate the need to implement a fully custom QWindow subclass as it will not necessarily be sufficient in advanced use cases.


https://doc.qt.io/qt-6/qwindow.html


### Dynamic rendering vs render passes

Since Vulkan ~1.3 we can use Dynamic rendering instead of render passes.

https://docs.vulkan.org/samples/latest/samples/extensions/dynamic_rendering/README.html

current vulkan guide uses it:

https://vkguide.dev/

Legacy one uses render passes

https://vkguide.dev/docs/old_vkguide

### MacOS

Had a driver not found and came to the same solution as the recommandation of Dave Hunter

on 

https://vulkan-tutorial.com/Drawing_a_triangle/Setup/Validation_layers

> First, when setting values for createInfo, add the following.
createInfo.flags = VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR;

Next, in GetRequiredExtensions, under if (enableValidationLayers) add the following line.

extensions.push_back(VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME);

### The vulkan loader

MacOS issues made me dig a bit more the loader

Excellent documentation here:

https://github.com/KhronosGroup/Vulkan-Loader/blob/main/docs/LoaderInterfaceArchitecture.md

As a side note on Ubuntu ICD files and more are here:

```bash
find /usr/share/vulkan
/usr/share/vulkan
/usr/share/vulkan/implicit_layer.d
/usr/share/vulkan/implicit_layer.d/VkLayer_MESA_device_select.json
/usr/share/vulkan/implicit_layer.d/nvidia_layers.json
/usr/share/vulkan/icd.d
/usr/share/vulkan/icd.d/gfxstream_vk_icd.x86_64.json
/usr/share/vulkan/icd.d/virtio_icd.x86_64.json
/usr/share/vulkan/icd.d/nouveau_icd.x86_64.json
/usr/share/vulkan/icd.d/lvp_icd.x86_64.json
/usr/share/vulkan/icd.d/intel_icd.x86_64.json
/usr/share/vulkan/icd.d/nvidia_icd.json
/usr/share/vulkan/icd.d/radeon_icd.x86_64.json
/usr/share/vulkan/icd.d/intel_hasvk_icd.x86_64.json
/usr/share/vulkan/explicit_layer.d
/usr/share/vulkan/explicit_layer.d/VkLayer_INTEL_nullhw.json
/usr/share/vulkan/explicit_layer.d/VkLayer_MESA_overlay.json
/usr/share/vulkan/explicit_layer.d/VkLayer_khronos_validation.json
/usr/share/vulkan/registry
/usr/share/vulkan/registry/parse_dependency.py
/usr/share/vulkan/registry/apiconventions.py
/usr/share/vulkan/registry/cgenerator.py
/usr/share/vulkan/registry/validusage.json
/usr/share/vulkan/registry/video.xml
/usr/share/vulkan/registry/reg.py
/usr/share/vulkan/registry/vkconventions.py
/usr/share/vulkan/registry/stripAPI.py
/usr/share/vulkan/registry/vk.xml
/usr/share/vulkan/registry/profiles
/usr/share/vulkan/registry/profiles/VP_KHR_roadmap_2022.json
/usr/share/vulkan/registry/spec_tools
/usr/share/vulkan/registry/spec_tools/conventions.py
/usr/share/vulkan/registry/spec_tools/util.py
/usr/share/vulkan/registry/generator.py
```

```bash
$ cat /usr/share/vulkan/icd.d/nvidia_icd.json
{
    "file_format_version" : "1.0.1",
    "ICD": {
        "library_path": "libGLX_nvidia.so.0",
        "api_version" : "1.4.312"
    }
}
```

```bash
$ dpkg -S /usr/share/vulkan/icd.d/nvidia_icd.json
libnvidia-gl-580:amd64: /usr/share/vulkan/icd.d/nvidia_icd.json
```

### SPIRV reflection

In Vulkan-Samples/framework/core/shader_module.cpp

```cpp
// Reflection is used to dynamically create descriptor bindings

	SPIRVReflection spirv_reflection;
	// Reflect all shader resources
	if (!spirv_reflection.reflect_shader_resources(stage, spirv, resources, shader_variant))
```

### Online shader compilation

https://github.com/google/shaderc/blob/main/examples/online-compile/main.cc

