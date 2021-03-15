# Weather Research and Forecasting (WRF) model

WRF is a state-of-the-art atmospheric modeling system designed for both meteorological research and numerical weather prediction. It offers a host of  options for atmospheric processes and can run on a variety of computing platforms. WRF excels in a broad range of applications across scales ranging from tens of meters to thousands of kilometers The Mesoscale and Microscale Meteorology Laboratory (MMM) of NCAR supports the WRF system to the user community, and maintains the WRF code on GitHub. Check out [https://www.mmm.ucar.edu/weather-research-and-forecasting-model](https //www.mmm.ucar.edu/weather-research-and-forecasting-model) for more.

We propose installation scripts for WRF ARW (Advanced Research WRF). The source can be obtained from the ARW users' page ([https://www2.mmm.ucar.edu/wrf/users/](https://www2.mmm.ucar.edu/wrf/users/)). By default, WRF ARW is compiled in a directory where the user has write access, and the full source code is kept. This is because WRF and its pre-processor WPS are usually run directly from the source code directories.  There can be two ways of installing WRF on Slackware:

- The default method taught by the official webpage is to install the dependencies in a custom location and install WRF alongside in a directory.
- The other method is the natural way of installing dependencies using SlackBuilds and compile WRF in a custom directory.


### install_wrfv3.sh

This script installs WRF according to the first method listed above. It should be placed in a directory with all the sources of the dependencies and the WPS and WRF source. The versions and the source tar balls that the script expect are listed below. The links to the webpages where they can be downloaded are included.

- MPICH 3.0.4 : mpich-3.0.4.tar.gz
[https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php](https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php)

- netCDF 4.1.3 : netcdf-4.1.3.tar.gz
[https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php](https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php)

- NCARG 6.6.2 : ncl_ncarg-6.6.2-CentOS7.6_64bit_nodap_gnu485.tar.gz
[https://www.earthsystemgrid.org/dataset/ncl.662_2.nodap/file.html](https://www.earthsystemgrid.org/dataset/ncl.662_2.nodap/file.html)

- udunits 2.2.28 : udunits-2.2.28.tar.gz
[https://www.unidata.ucar.edu/downloads/udunits/](https://www.unidata.ucar.edu/downloads/udunits/)

- Ncview 1.93g : ncview-1.93g.tar.gz
[http://meteora.ucsd.edu/~pierce/ncview_home_page.html](http://meteora.ucsd.edu/~pierce/ncview_home_page.html)

- WRF 3.8.1
[https://www2.mmm.ucar.edu/wrf/users/download/get_source.html](https://www2.mmm.ucar.edu/wrf/users/download/get_source.html)

- WPS 3.8.1
[https://www2.mmm.ucar.edu/wrf/users/download/get_source.html](https://www2.mmm.ucar.edu/wrf/users/download/get_source.html)

__NOTE:__ The source codes for MPICH and netCDF are obtained from the WRF compiling tutorial page. Other dependencies are listed on that page, such as Jasper, libpng and zlib. These packages are already available from the base Slackware system.

WRF is compiled with the dmpar (GNU gfortran/gcc) option. It is option number 34 from the list shown below. This list is obtained by running WRF's internal configure script manually (list is given below).
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

The script will set all permissions with respect to the user running the script. And, the default installation directory is the home directory of the executing user, taken from environment variable ${HOME}. To change target directory, execute script as
```
$ OUTPUT=CUSTOM_PATH ./install_wrfv3.sh
```


