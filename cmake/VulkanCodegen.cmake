# Shaders processing
if(NOT USE_VULKAN)
  return()
endif()

set(VULKAN_GEN_OUTPUT_PATH "${CMAKE_BINARY_DIR}/vulkan/ATen/native/vulkan")
set(VULKAN_GEN_ARG_ENV "")

if(USE_VULKAN_RELAXED_PRECISION)
  list(APPEND VULKAN_GEN_ARG_ENV "precision=mediump")
endif()
if(USE_VULKAN_FP16_INFERENCE)
  list(APPEND VULKAN_GEN_ARG_ENV "format=rgba16f")
endif()

# Precompiling shaders
if(ANDROID)
  if(NOT ANDROID_NDK)
    message(FATAL_ERROR "ANDROID_NDK not set")
  endif()

  set(GLSLC_PATH "${ANDROID_NDK}/shader-tools/${ANDROID_NDK_HOST_SYSTEM_NAME}/glslc")
else()
  find_program(
    GLSLC_PATH glslc
    PATHS
    ENV VULKAN_SDK
    PATHS "$ENV{VULKAN_SDK}/${CMAKE_HOST_SYSTEM_PROCESSOR}/bin"
    PATHS "$ENV{VULKAN_SDK}/bin"
  )

  if(NOT GLSLC_PATH)
    message(FATAL_ERROR "USE_VULKAN glslc not found")
  endif(NOT GLSLC_PATH)
endif()

set(PYTHONPATH "$ENV{PYTHONPATH}")
set(NEW_PYTHONPATH ${PYTHONPATH})
list(APPEND NEW_PYTHONPATH "${CMAKE_CURRENT_LIST_DIR}/..")
set(vulkan_generated_cpp ${VULKAN_GEN_OUTPUT_PATH}/spv.cpp)
set(vulkan_generated_h ${VULKAN_GEN_OUTPUT_PATH}/spv.h)
add_custom_command(
  OUTPUT "${vulkan_generated_cpp}" "${vulkan_generated_h}"
  COMMAND cmake -E env "PYTHONPATH=${NEW_PYTHONPATH}" "${PYTHON_EXECUTABLE}"
  ${CMAKE_CURRENT_LIST_DIR}/../tools/gen_vulkan_spv.py
  --glsl-path ${CMAKE_CURRENT_LIST_DIR}/../aten/src/ATen/native/vulkan/glsl
  --output-path ${VULKAN_GEN_OUTPUT_PATH}
  --glslc-path=${GLSLC_PATH}
  --tmp-dir-path=${CMAKE_BINARY_DIR}/vulkan/spv
  --env ${VULKAN_GEN_ARG_ENV}
)
