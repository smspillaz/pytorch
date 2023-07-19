# Shaders processing
if(NOT USE_VULKAN)
  return()
endif()

set(VULKAN_GLSL_PATH "${CMAKE_CURRENT_LIST_DIR}/../aten/src/ATen/native/vulkan/glsl")
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
  --glsl-path "${VULKAN_GLSL_PATH}"
  --output-path ${VULKAN_GEN_OUTPUT_PATH}
  --glslc-path=${GLSLC_PATH}
  --tmp-dir-path=${CMAKE_BINARY_DIR}/vulkan/spv
  --env ${VULKAN_GEN_ARG_ENV}
  DEPENDS
  ${VULKAN_GLSL_PATH}/abs.glsl
  ${VULKAN_GLSL_PATH}/abs_.glsl
  ${VULKAN_GLSL_PATH}/adaptive_avg_pool2d.glsl
  ${VULKAN_GLSL_PATH}/add.glsl
  ${VULKAN_GLSL_PATH}/add_.glsl
  ${VULKAN_GLSL_PATH}/add_scalar.glsl
  ${VULKAN_GLSL_PATH}/add_scalar_.glsl
  ${VULKAN_GLSL_PATH}/addmm.glsl
  ${VULKAN_GLSL_PATH}/avg_pool2d.glsl
  ${VULKAN_GLSL_PATH}/batchnorm.glsl
  ${VULKAN_GLSL_PATH}/buffer_to_buffer.glsl
  ${VULKAN_GLSL_PATH}/cat_feature.glsl
  ${VULKAN_GLSL_PATH}/clamp.glsl
  ${VULKAN_GLSL_PATH}/clamp_.glsl
  ${VULKAN_GLSL_PATH}/conv2d.glsl
  ${VULKAN_GLSL_PATH}/conv2d_dw.glsl
  ${VULKAN_GLSL_PATH}/conv_transpose2d.glsl
  ${VULKAN_GLSL_PATH}/cumsum.glsl
  ${VULKAN_GLSL_PATH}/dequantize.glsl
  ${VULKAN_GLSL_PATH}/div.glsl
  ${VULKAN_GLSL_PATH}/div_.glsl
  ${VULKAN_GLSL_PATH}/glu_channel.glsl
  ${VULKAN_GLSL_PATH}/glu_channel_mul4.glsl
  ${VULKAN_GLSL_PATH}/hardshrink.glsl
  ${VULKAN_GLSL_PATH}/hardshrink_.glsl
  ${VULKAN_GLSL_PATH}/hardsigmoid.glsl
  ${VULKAN_GLSL_PATH}/hardsigmoid_.glsl
  ${VULKAN_GLSL_PATH}/hardswish.glsl
  ${VULKAN_GLSL_PATH}/hardswish_.glsl
  ${VULKAN_GLSL_PATH}/image2d_to_nchw.glsl
  ${VULKAN_GLSL_PATH}/image_to_nchw.glsl
  ${VULKAN_GLSL_PATH}/image_to_nchw_int32.glsl
  ${VULKAN_GLSL_PATH}/image_to_nchw_quantized.glsl
  ${VULKAN_GLSL_PATH}/image_to_nchw_quantized_mul4.glsl
  ${VULKAN_GLSL_PATH}/layernorm.glsl
  ${VULKAN_GLSL_PATH}/leaky_relu.glsl
  ${VULKAN_GLSL_PATH}/leaky_relu_.glsl
  ${VULKAN_GLSL_PATH}/lerp.glsl
  ${VULKAN_GLSL_PATH}/lerp_.glsl
  ${VULKAN_GLSL_PATH}/lerp_scalar.glsl
  ${VULKAN_GLSL_PATH}/lerp_scalar_.glsl
  ${VULKAN_GLSL_PATH}/log_softmax.glsl
  ${VULKAN_GLSL_PATH}/max_pool2d.glsl
  ${VULKAN_GLSL_PATH}/mean.glsl
  ${VULKAN_GLSL_PATH}/mean2d.glsl
  ${VULKAN_GLSL_PATH}/mm.glsl
  ${VULKAN_GLSL_PATH}/mul.glsl
  ${VULKAN_GLSL_PATH}/mul_.glsl
  ${VULKAN_GLSL_PATH}/mul_scalar.glsl
  ${VULKAN_GLSL_PATH}/mul_scalar_.glsl
  ${VULKAN_GLSL_PATH}/nchw_to_image.glsl
  ${VULKAN_GLSL_PATH}/nchw_to_image2d.glsl
  ${VULKAN_GLSL_PATH}/nchw_to_image_int32.glsl
  ${VULKAN_GLSL_PATH}/nchw_to_image_int8.glsl
  ${VULKAN_GLSL_PATH}/nchw_to_image_uint8.glsl
  ${VULKAN_GLSL_PATH}/permute_4d.glsl
  ${VULKAN_GLSL_PATH}/quantize_per_tensor_qint32.glsl
  ${VULKAN_GLSL_PATH}/quantize_per_tensor_qint8.glsl
  ${VULKAN_GLSL_PATH}/quantize_per_tensor_quint8.glsl
  ${VULKAN_GLSL_PATH}/quantized_add.glsl
  ${VULKAN_GLSL_PATH}/quantized_conv2d.glsl
  ${VULKAN_GLSL_PATH}/quantized_conv2d_dw.glsl
  ${VULKAN_GLSL_PATH}/quantized_conv2d_pw_2x2.glsl
  ${VULKAN_GLSL_PATH}/quantized_div.glsl
  ${VULKAN_GLSL_PATH}/quantized_mul.glsl
  ${VULKAN_GLSL_PATH}/quantized_sub.glsl
  ${VULKAN_GLSL_PATH}/quantized_upsample_nearest2d.glsl
  ${VULKAN_GLSL_PATH}/reflection_pad2d.glsl
  ${VULKAN_GLSL_PATH}/replication_pad2d.glsl
  ${VULKAN_GLSL_PATH}/select_depth.glsl
  ${VULKAN_GLSL_PATH}/sigmoid.glsl
  ${VULKAN_GLSL_PATH}/sigmoid_.glsl
  ${VULKAN_GLSL_PATH}/slice_4d.glsl
  ${VULKAN_GLSL_PATH}/softmax.glsl
  ${VULKAN_GLSL_PATH}/stack_feature.glsl
  ${VULKAN_GLSL_PATH}/sub.glsl
  ${VULKAN_GLSL_PATH}/sub_.glsl
  ${VULKAN_GLSL_PATH}/tanh.glsl
  ${VULKAN_GLSL_PATH}/tanh_.glsl
  ${VULKAN_GLSL_PATH}/threshold.glsl
  ${VULKAN_GLSL_PATH}/upsample_nearest2d.glsl
  ${VULKAN_GLSL_PATH}/templates/conv2d_dw.glslt
  ${VULKAN_GLSL_PATH}/templates/conv2d_dw_params.yaml
  ${VULKAN_GLSL_PATH}/templates/conv2d_pw.glslt
  ${VULKAN_GLSL_PATH}/templates/conv2d_pw_params.yaml
)
