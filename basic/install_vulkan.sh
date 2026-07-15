apt-get update && apt-get install -y libvulkan1 vulkan-tools

# Provide the NVIDIA Vulkan ICD manifest (libGLX_nvidia.so.0 is the NVIDIA Vulkan driver,
# already mounted by the nvidia container runtime since graphics caps are on):
mkdir -p /usr/share/vulkan/icd.d
cat > /usr/share/vulkan/icd.d/nvidia_icd.json <<'EOF'
{
    "file_format_version" : "1.0.0",
    "ICD": {
        "library_path" : "libGLX_nvidia.so.0",
        "api_version" : "1.3.277"
    }
}
EOF