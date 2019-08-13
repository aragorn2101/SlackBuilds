# SlackBuilds script for NVIDIA CUDA version 10.1.168

The NVIDIA® CUDA® Toolkit provides a development environment for creating high
performance GPU-accelerated applications. With the CUDA Toolkit, you can
develop, optimize and deploy your applications on GPU-accelerated embedded
systems, desktop workstations, enterprise data centers, cloud-based platforms
and HPC supercomputers. The toolkit includes GPU-accelerated libraries,
debugging and optimization tools, a C/C++ compiler and a runtime library to
deploy your application.

If the link from the cudatoolkit.info is not working for downloading the
source, the file can be downloaded from
<https://developer.nvidia.com/cuda-downloads>

The necessary file to download is under the following specifications:
Operating System: Linux
Architecture: x86_64
Distribution: RHEL
Version: 7
Installer Type: runfile (local)

The runfile is 2.4 GiB and the temporary extracted size required is 4.2 GiB.
The compressed package will take around 2.2 GiB.

This is not an official SlackBuild and has not been tested with the NVIDIA
driver and kernel module available from SlackBuilds.org. We use /tmp/SBo as the
default temporary directory but the build tag is "custom". This version of CUDA
has been tested with driver and kernel module version 430.34 and was found to
work correctly.

## Known issues when using CUDA 10

These issues were encountered when using CUDA 10 with a NVIDIA Titan Xp, and
are not strictly due to the build script or the device itself.

### ERR_NVGPUCTRPERM: Permission issue with Performance Counters

By default, access to GPU performance (therefore metrics) is disabled due to
Security Notice: NVIDIA Response to "Rendered Insecure: GPU Side Channel
Attacks are Practical" - November 2018
<https://nvidia.custhelp.com/app/answers/detail/a_id/4738>

Consequently a regular user cannot use the profiler. So, an administrator must
enable access for regular users when loading the module. To make it automatic,
a file can be added to /etc/modprobe.d giving the following option parameter:

```
--  /etc/modprobe.d/nvidia.conf  --

# To allow any user to profile using NVIDIA GPU performance counters
options nvidia "NVreg_RestrictProfilingToAdminUsers=0"
```

### Device not accessible by regular user at boot

The GPU is not accessible by a regular user just after the system boots. For
example, just after the system boots, if a regular user runs the deviceQuery
program from the CUDA demo suite, it will not work. But as soon as root
executes deviceQuery, the regular user can run it successfully as well. Thus,
an easy hack is to add the call to deviceQuery in rc.local and dumping the
output to null.

```
--  /etc/rc.d/rc.local  --

# Wake the GPU
echo "Waking up NVIDIA's Titan Xp ..."
/usr/share/cuda/extras/demo_suite/deviceQuery > /dev/zero
```

