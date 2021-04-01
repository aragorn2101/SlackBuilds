# Weather Research and Forecasting (WRF) model

We propose installation scripts for WRF ARW (Advanced Research WRF). The source can be obtained from the ARW users' page ([https://www2.mmm.ucar.edu/wrf/users/](https://www2.mmm.ucar.edu/wrf/users/)). By default, WRF ARW is compiled in a directory where the user has write access, and the full source code is kept. This is because WRF and its pre-processor WPS are usually run directly from the source code directories.  There can be two ways of installing WRF on Slackware:

- The default method, taught by the official webpage, where the dependencies are installed in a directory alongside the WRF installation, in a custom location.
- The other method is the natural way of installing dependencies using SlackBuilds and compile WRF in a custom directory.

**NOTE:** The main requirement is a 64-bit processor and operating system. All the scripts were tested using a 64-bit Slackware 14.2 GNU/Linux installed on an Intel Core i7-7700K machine. Building and installing all the software on that machine takes less than 15 minutes. Since it is a high-end processor, a longer build time would be expected on other machines. The final space taken on disk is around 1.1 GB for the software only, and around 30 GB when the geographical static data is included.


## install_wrfvX.sh

The install scripts install WRF according to the first method listed above. The source code for the dependencies, and the source archives for both WRF and WPS should be placed in the same directory as the script. The script is made executable and run. The generic call is
```
$ NUMJOBS=NUM_OF_CORES_OR_THREADS OUTPUT=CUSTOM_PATH ./install_wrfvX.sh
```
where ``X = 3 or 4``

``NUMJOBS`` is the number of threads or cores used to compile the software. If it is not passed on the command line, the default is calculated from the number of processors present on your machine. If your computer features 4 cores, the number of cores used to build software is 3. ``OUTPUT`` is the directory under which all the software is placed. The script will create a directory with name ``wrfvX`` (where ``X = 3 or 4``), under ``OUTPUT``. At the end of installation, the directory tree will look like this:
```
- [OUTPUT]/
  - wrfvX/
    - DATA/
    - GEOG/
    - WPS/
    - WRF/
    - deps/
    - env.sh
    - utils/
```

The ``DATA`` and ``GEOG`` directories are empty. These are created to allow the user to store input data close to the WRF software. Directory ``DATA`` normally would contain GRIB or netCDF files. It is recommended that the content of the directory obtained by extracting the archive containing the geographical input data mandatory fields is moved to directory ``GEOG``. Then, the field ``geog_data_path``, in namelist.wps, can be set to ``${OUTPUT}/wrfvX/GEOG``.

Directory ``deps`` contains dependency libraries and ``utils`` contains NCAR graphics, NCL and ncview. The script will set all permissions with respect to the user executing it. If it is not passed through the call to the script, the default value of ``OUTPUT`` is the path to the home directory of the user, taken from environment variable ``${HOME}``.

The WPS directory contains the WRF pre-processor source code and the executable resulting from compilation: ``geogrid.exe``, ``ungrib.exe`` and ``metgrid.exe``. The WRF directory is where the WRF source code resides and it contains the four executables: ``real.exe``, ``ndown.exe``, ``wrf.exe`` and ``tc.exe``.

**NOTE:** the ``env.sh`` script is a file which needs to be sourced every time you wish to use WRF or WPS. It sets up the environment required for the good functioning of WRF.
```
$ source env.sh
```

#### WRF

WRF is compiled with the ``(dmpar) GNU (gfortran/gcc)`` option. It means that it is compiled for an architecture supporting Dynamic Memory Parallelism using a GNU/Linux operating system. This is implemented usually by the MPI standard on multi-core CPUs. It is option number 34 from the list shown below. This list is obtained by running WRF's internal configure script manually (list is given below).
```
  1. (serial)   2. (smpar)   3. (dmpar)   4. (dm+sm)   PGI (pgf90/gcc)
  5. (serial)   6. (smpar)   7. (dmpar)   8. (dm+sm)   PGI (pgf90/pgcc): SGI MPT
  9. (serial)  10. (smpar)  11. (dmpar)  12. (dm+sm)   PGI (pgf90/gcc): PGI accelerator
 13. (serial)  14. (smpar)  15. (dmpar)  16. (dm+sm)   INTEL (ifort/icc)
                                         17. (dm+sm)   INTEL (ifort/icc): Xeon Phi (MIC architecture)
 18. (serial)  19. (smpar)  20. (dmpar)  21. (dm+sm)   INTEL (ifort/icc): Xeon (SNB with AVX mods)
 22. (serial)  23. (smpar)  24. (dmpar)  25. (dm+sm)   INTEL (ifort/icc): SGI MPT
 26. (serial)  27. (smpar)  28. (dmpar)  29. (dm+sm)   INTEL (ifort/icc): IBM POE
 30. (serial)               31. (dmpar)                PATHSCALE (pathf90/pathcc)
 32. (serial)  33. (smpar)  34. (dmpar)  35. (dm+sm)   GNU (gfortran/gcc)
 36. (serial)  37. (smpar)  38. (dmpar)  39. (dm+sm)   IBM (xlf90_r/cc_r)
 40. (serial)  41. (smpar)  42. (dmpar)  43. (dm+sm)   PGI (ftn/gcc): Cray XC CLE
 44. (serial)  45. (smpar)  46. (dmpar)  47. (dm+sm)   CRAY CCE (ftn $(NOOMP)/cc): Cray XE and XC
 48. (serial)  49. (smpar)  50. (dmpar)  51. (dm+sm)   INTEL (ftn/icc): Cray XC
 52. (serial)  53. (smpar)  54. (dmpar)  55. (dm+sm)   PGI (pgf90/pgcc)
 56. (serial)  57. (smpar)  58. (dmpar)  59. (dm+sm)   PGI (pgf90/gcc): -f90=pgf90
 60. (serial)  61. (smpar)  62. (dmpar)  63. (dm+sm)   PGI (pgf90/pgcc): -f90=pgf90
 64. (serial)  65. (smpar)  66. (dmpar)  67. (dm+sm)   INTEL (ifort/icc): HSW/BDW
 68. (serial)  69. (smpar)  70. (dmpar)  71. (dm+sm)   INTEL (ifort/icc): KNL MIC
 72. (serial)  73. (smpar)  74. (dmpar)  75. (dm+sm)   FUJITSU (frtpx/fccpx): FX10/FX100 SPARC64 IXfx/Xlfx
```

The install script also sets the nesting option to ``basic``. It is option 1 from the list available:
```
Compile for nesting? (1=basic, 2=preset moves, 3=vortex following) [default 1]
```
The above two options are set in the configuration section, just before compiling WRF.  If you have a different machine or need for other nesting options, please feel free to modify the install script.

#### WPS

The WRF pre-processing system (WPS) is compiled with the option ``Linux x86_64, gfortran (dmpar)``. It is option 3 of the following list, which is obtained by manually calling the WPS internal configure script. The option is set by the install script in the configuration section of the process of building WPS. Again, if you are on a different platform, modify accordingly.
```
   1.  Linux x86_64, gfortran    (serial)
   2.  Linux x86_64, gfortran    (serial_NO_GRIB2)
   3.  Linux x86_64, gfortran    (dmpar)
   4.  Linux x86_64, gfortran    (dmpar_NO_GRIB2)
   5.  Linux x86_64, PGI compiler   (serial)
   6.  Linux x86_64, PGI compiler   (serial_NO_GRIB2)
   7.  Linux x86_64, PGI compiler   (dmpar)
   8.  Linux x86_64, PGI compiler   (dmpar_NO_GRIB2)
   9.  Linux x86_64, PGI compiler, SGI MPT   (serial)
  10.  Linux x86_64, PGI compiler, SGI MPT   (serial_NO_GRIB2)
  11.  Linux x86_64, PGI compiler, SGI MPT   (dmpar)
  12.  Linux x86_64, PGI compiler, SGI MPT   (dmpar_NO_GRIB2)
  13.  Linux x86_64, IA64 and Opteron    (serial)
  14.  Linux x86_64, IA64 and Opteron    (serial_NO_GRIB2)
  15.  Linux x86_64, IA64 and Opteron    (dmpar)
  16.  Linux x86_64, IA64 and Opteron    (dmpar_NO_GRIB2)
  17.  Linux x86_64, Intel compiler    (serial)
  18.  Linux x86_64, Intel compiler    (serial_NO_GRIB2)
  19.  Linux x86_64, Intel compiler    (dmpar)
  20.  Linux x86_64, Intel compiler    (dmpar_NO_GRIB2)
  21.  Linux x86_64, Intel compiler, SGI MPT    (serial)
  22.  Linux x86_64, Intel compiler, SGI MPT    (serial_NO_GRIB2)
  23.  Linux x86_64, Intel compiler, SGI MPT    (dmpar)
  24.  Linux x86_64, Intel compiler, SGI MPT    (dmpar_NO_GRIB2)
  25.  Linux x86_64, Intel compiler, IBM POE    (serial)
  26.  Linux x86_64, Intel compiler, IBM POE    (serial_NO_GRIB2)
  27.  Linux x86_64, Intel compiler, IBM POE    (dmpar)
  28.  Linux x86_64, Intel compiler, IBM POE    (dmpar_NO_GRIB2)
  29.  Linux x86_64 g95 compiler     (serial)
  30.  Linux x86_64 g95 compiler     (serial_NO_GRIB2)
  31.  Linux x86_64 g95 compiler     (dmpar)
  32.  Linux x86_64 g95 compiler     (dmpar_NO_GRIB2)
  33.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (serial)
  34.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (serial_NO_GRIB2)
  35.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (dmpar)
  36.  Cray XE/XC CLE/Linux x86_64, Cray compiler   (dmpar_NO_GRIB2)
  37.  Cray XC CLE/Linux x86_64, Intel compiler   (serial)
  38.  Cray XC CLE/Linux x86_64, Intel compiler   (serial_NO_GRIB2)
  39.  Cray XC CLE/Linux x86_64, Intel compiler   (dmpar)
  40.  Cray XC CLE/Linux x86_64, Intel compiler   (dmpar_NO_GRIB2)
```

#### Version 3 : install_wrfv3.sh

The versions and the source tar balls that the script expect are listed below. The links to the webpages where they can be downloaded are included.

- WRF 3.8.1 </br>
``WRFV3.8.1.TAR.gz`` </br>
[https://www2.mmm.ucar.edu/wrf/users/download/get_source.html](https://www2.mmm.ucar.edu/wrf/users/download/get_source.html)

- WPS 3.8.1 </br>
``WPSV3.8.1.TAR.gz`` </br>
[https://www2.mmm.ucar.edu/wrf/users/download/get_source.html](https://www2.mmm.ucar.edu/wrf/users/download/get_source.html)

- MPICH 3.0.4 </br>
``mpich-3.0.4.tar.gz`` </br>
[https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php](https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php)

- netCDF 4.1.3 </br>
``netcdf-4.1.3.tar.gz`` </br>
[https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php](https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php)

- NCARG 6.6.2 </br>
``ncl_ncarg-6.6.2-CentOS7.6_64bit_nodap_gnu485.tar.gz`` </br>
[https://www.earthsystemgrid.org/dataset/ncl.662_2.nodap/file.html](https://www.earthsystemgrid.org/dataset/ncl.662_2.nodap/file.html)

- udunits 2.2.28 </br>
``udunits-2.2.28.tar.gz`` </br>
[https://www.unidata.ucar.edu/downloads/udunits/](https://www.unidata.ucar.edu/downloads/udunits/)

- Ncview 1.93g </br>
``ncview-1.93g.tar.gz`` </br>
[http://meteora.ucsd.edu/~pierce/ncview_home_page.html](http://meteora.ucsd.edu/~pierce/ncview_home_page.html)

__NOTE:__ The source codes for MPICH and netCDF are obtained from the WRF compiling tutorial page ([https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php](https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php)). Other dependencies are listed on that page, such as Jasper, libpng and zlib. These packages are already available from the base Slackware system.


#### Version 4 : install_wrfv4.sh

The versions and the source tar balls that the script expect are listed below. The links to the webpages where they can be downloaded are included.

- WRF 4.2.2 </br>
``WRF-4.2.2.tar.gz`` </br>
[https://www2.mmm.ucar.edu/wrf/users/download/get_source.html](https://www2.mmm.ucar.edu/wrf/users/download/get_source.html)

- WPS 4.2 </br>
``WPS-4.2.tar.gz`` </br>
[https://www2.mmm.ucar.edu/wrf/users/download/get_source.html](https://www2.mmm.ucar.edu/wrf/users/download/get_source.html)

- MPICH 3.4.1 </br>
``mpich-3.4.1.tar.gz`` </br>
[https://www.mpich.org/downloads](https://www.mpich.org/downloads)

- netCDF 4.7.4 </br>
``netcdf-c-4.7.4.tar.gz`` </br>
[https://www.unidata.ucar.edu/downloads/netcdf](https://www.unidata.ucar.edu/downloads/netcdf)

- netCDF Fortran 4.5.3 </br>
``netcdf-fortran-4.5.3.tar.gz`` </br>
[https://www.unidata.ucar.edu/downloads/netcdf](https://www.unidata.ucar.edu/downloads/netcdf)

- NCARG 6.6.2 </br>
``ncl_ncarg-6.6.2-CentOS7.6_64bit_nodap_gnu485.tar.gz`` </br>
[https://www.earthsystemgrid.org/dataset/ncl.662_2.nodap/file.html](https://www.earthsystemgrid.org/dataset/ncl.662_2.nodap/file.html)

- udunits 2.2.28 </br>
``udunits-2.2.28.tar.gz`` </br>
[https://www.unidata.ucar.edu/downloads/udunits/](https://www.unidata.ucar.edu/downloads/udunits/)

- Ncview 1.93g </br>
``ncview-1.93g.tar.gz`` </br>
[http://meteora.ucsd.edu/~pierce/ncview_home_page.html](http://meteora.ucsd.edu/~pierce/ncview_home_page.html)


#### Version 4 with OpenMPI : install_wrfv4_OpenMPI.sh

Originally, MPICH was used for the WRF installations as the WRF website recommended its use based on their experience. However, we noticed that, with WRF version 4, OpenMPI can also be used. Thus, we include this script, which installs the same batch of software as the other script, except for the MPI package. For this script, the OpenMPI source must be fetched:

- OpenMPI 4.1.0 </br>
``openmpi-4.1.0.tar.bz2`` </br>
[https://www.open-mpi.org/software/ompi/v4.1/](https://www.open-mpi.org/software/ompi/v4.1/)

We made this alternate script to give users a choice. Also, OpenMPI gives the opportunity to explicitly specify using threads instead of cores when executing a program. For example, when using Intel processors there are hyperthreads available which can be used to launch jobs, analogous to having distinct physical cores. The functionality is used as follows:
```
mpirun --use-hwthread-cpus -np [NUM]
```
