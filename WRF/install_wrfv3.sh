#!/bin/sh
#
#  Script to install WRF 3.8.1 along with its dependencies.
#
#  Copyright (C) 2021 Nitish Ragoomundun, Mauritius <lrugratz       com>
#                                                            @gmail.
#
#  Redistribution and use of this script, with or without modification, is
#  permitted provided that the following conditions are met:
#
#  1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

#
#  The script will first install
#  - netCDF
#  - MPICH
#  - NCARG
#  - udunits
#  - ncview
#
#  Then it will proceed with the installation of WRF, with WPS included. The
#  default installation directory is a directory named wrfv3 in the current
#  user's home. This is done so that the user has permission to write to the
#  directory, as it is often required when using the WRF model.
#
#  NOTE:
#
#  * WRF and WPS are installed in the Distributed Memory Parallel mode (dmpar).
#    If you wish to change this option to the corresponding choice must be
#    changed following each call to the configure script.
#
#  * the tarballs. of appropriate versions, for each of the listed smaller
#    programs, WRF and WPS should be in the same directory as this script.
#

PRGNAM=wrfv3

# WRF version
WRF_VER=3.8.1
WPS_VER=3.8.1

# MPICH version
MPICH_VER=3.0.4

# netCDF version
NETCDF_VER=4.1.3

# NCAR Graphics version
NCARG_VER=6.6.2

# udunits version
UDUNITS_VER=2.2.28

# ncview version
NCVIEW_VER=1.93g


USERID=`id -u`

if [ -z "$ARCH" ]; then
  case "$( uname -m )" in
    i?86) ARCH=i486 ;;
    arm*) ARCH=arm ;;
       *) ARCH=$( uname -m ) ;;
  esac
fi

CWD=$(pwd)

# Installation directory
OUTPUT=${OUTPUT:-${HOME}}
PKG=${OUTPUT}/${PRGNAM}


export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran
export FCFLAGS="-O2 -fPIC -m64"
export FFLAGS="-m64"
export JASPERINC=/usr/include/jasper
export JASPERLIB=/usr/lib${LIBDIRSUFFIX}
export LDFLAGS=-L/usr/lib${LIBDIRSUFFIX}
export CPPFLAGS=-I/usr/include/jasper
export CXXFLAGS=-I/usr/include/jasper

set -e

rm -rf $PKG
mkdir -p $PKG/{DATA,GEOG,WPS,WRF,deps,utils,build}


###  Initialize environment setup script  ###
echo -e "
#  Initialize environment for WRF

export JASPERINC=/usr/include/jasper
export JASPERLIB=/usr/lib${LIBDIRSUFFIX}
" > ${PKG}/env.sh


###  netCDF  ###
echo
echo "---------------------------------------------------------------"
echo "Building netCDF ${NETCDF_VER} ..."
echo "---------------------------------------------------------------"
echo
mkdir $PKG/deps/netcdf
cd $PKG/build
tar xvf $CWD/netcdf-${NETCDF_VER}.tar.gz
cd netcdf-${NETCDF_VER}
chown -R ${USERID}:${USERID} .
find -L . \
 \( -perm 777 -o -perm 775 -o -perm 750 -o -perm 711 -o -perm 555 \
  -o -perm 511 \) -exec chmod 755 {} \; -o \
 \( -perm 666 -o -perm 664 -o -perm 640 -o -perm 600 -o -perm 444 \
  -o -perm 440 -o -perm 400 \) -exec chmod 644 {} \;

./configure --prefix=${PKG}/deps/netcdf \
            --disable-dap \
            --disable-netcdf-4 \
            --disable-shared \
            --build=$ARCH-slackware-linux

make
make install

export NETCDF=${PKG}/deps/netcdf
export PATH=${NETCDF}/bin:${PATH}
export LD_LIBRARY_PATH=${NETCDF}/lib:${LD_LIBRARY_PATH}

echo -e "
export NETCDF=${PKG}/deps/netcdf
export PATH=\$NETCDF/bin:\$PATH
export LD_LIBRARY_PATH=\$NETCDF/lib:\$LD_LIBRARY_PATH
" >> ${PKG}/env.sh

# Update flags
export LDFLAGS=-L${NETCDF}/lib\ ${LDFLAGS}
export CPPFLAGS=-I${NETCDF}/include\ ${CPPFLAGS}
export CXXFLAGS=-I${NETCDF}/include\ ${CXXFLAGS}
export NETCDF_INC=${NETCDF}/include
export NETCDF_LIB=${NETCDF}/lib



###  MPICH  ###
echo
echo "---------------------------------------------------------------"
echo "Building MPICH ${MPICH_VER} ..."
echo "---------------------------------------------------------------"
echo
mkdir $PKG/deps/mpich
cd $PKG/build
tar xvf $CWD/mpich-${MPICH_VER}.tar.gz
cd mpich-${MPICH_VER}
chown -R ${USERID}:${USERID} .
find -L . \
 \( -perm 777 -o -perm 775 -o -perm 750 -o -perm 711 -o -perm 555 \
  -o -perm 511 \) -exec chmod 755 {} \; -o \
 \( -perm 666 -o -perm 664 -o -perm 640 -o -perm 600 -o -perm 444 \
  -o -perm 440 -o -perm 400 \) -exec chmod 644 {} \;

./configure --prefix=${PKG}/deps/mpich \
            --build=$ARCH-slackware-linux

make
make install

export PATH=${PKG}/deps/mpich/bin:${PATH}
export LD_LIBRARY_PATH=${PKG}/deps/mpich/lib:${LD_LIBRARY_PATH}

echo -e "
export PATH=${PKG}/deps/mpich/bin:\$PATH
export LD_LIBRARY_PATH=${PKG}/deps/mpich/lib:\$LD_LIBRARY_PATH
" >> ${PKG}/env.sh

# Update flags
export LDFLAGS=-L${PKG}/deps/mpich/lib\ ${LDFLAGS}



###  NCAR Graphics  ###
echo
echo "---------------------------------------------------------------"
echo "Installing NCAR Graphics ..."
echo "---------------------------------------------------------------"
echo
mkdir $PKG/utils/ncarg
cd $PKG/utils/ncarg
tar xvf $CWD/ncl_ncarg-${NCARG_VER}-CentOS7.6_64bit_nodap_gnu485.tar.gz
chown -R ${USERID}:${USERID} .
find -L . \
 \( -perm 777 -o -perm 775 -o -perm 750 -o -perm 711 -o -perm 555 \
  -o -perm 511 \) -exec chmod 755 {} \; -o \
 \( -perm 666 -o -perm 664 -o -perm 640 -o -perm 600 -o -perm 444 \
  -o -perm 440 -o -perm 400 \) -exec chmod 644 {} \;

export NCARG_ROOT=${PKG}/utils/ncarg
export PATH=${NCARG_ROOT}/bin:${PATH}
export LD_LIBRARY_PATH=${NCARG_ROOT}/lib:${LD_LIBRARY_PATH}

echo -e "
export NCARG_ROOT=${PKG}/utils/ncarg
export PATH=\$NCARG_ROOT/bin:\$PATH
export LD_LIBRARY_PATH=\$NCARG_ROOT/lib:\$LD_LIBRARY_PATH
" >> ${PKG}/env.sh


###  nvciew  ###
echo
echo "---------------------------------------------------------------"
echo "Building udunits ..."
echo "---------------------------------------------------------------"
echo
mkdir $PKG/deps/udunits
cd $PKG/build
tar xvf $CWD/udunits-${UDUNITS_VER}.tar.gz
cd udunits-${UDUNITS_VER}
chown -R ${USERID}:${USERID} .
find -L . \
 \( -perm 777 -o -perm 775 -o -perm 750 -o -perm 711 -o -perm 555 \
  -o -perm 511 \) -exec chmod 755 {} \; -o \
 \( -perm 666 -o -perm 664 -o -perm 640 -o -perm 600 -o -perm 444 \
  -o -perm 440 -o -perm 400 \) -exec chmod 644 {} \;

./configure --prefix=${PKG}/deps/udunits \
            --disable-shared \
            --build=$ARCH-slackware-linux

make
make install

find $PKG/deps/udunits -print0 | xargs -0 file | grep -e "executable" -e "shared object" | grep ELF \
  | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null || true

UDUNITS=${PKG}/deps/udunits
export PATH=${UDUNITS}/bin:${PATH}
export LD_LIBRARY_PATH=${UDUNITS}/lib:${LD_LIBRARY_PATH}

echo -e "
export PATH=${UDUNITS}/bin:\$PATH
export LD_LIBRARY_PATH=${UDUNITS}/lib:\$LD_LIBRARY_PATH
" >> ${PKG}/env.sh

echo
echo "---------------------------------------------------------------"
echo "Building ncview ..."
echo "---------------------------------------------------------------"
echo
mkdir -p $PKG/utils/ncview/local/lib
cd $PKG/build
tar xvf $CWD/ncview-${NCVIEW_VER}.tar.gz
cd ncview-${NCVIEW_VER}
chown -R ${USERID}:${USERID} .
find -L . \
 \( -perm 777 -o -perm 775 -o -perm 750 -o -perm 711 -o -perm 555 \
  -o -perm 511 \) -exec chmod 755 {} \; -o \
 \( -perm 666 -o -perm 664 -o -perm 640 -o -perm 600 -o -perm 444 \
  -o -perm 440 -o -perm 400 \) -exec chmod 644 {} \;

./configure --prefix=${PKG}/utils/ncview \
            --with-netcdf_incdir=${PKG}/deps/netcdf/include \
            --with-netcdf_libdir=${PKG}/deps/netcdf/lib \
            --with-nc-config=${PKG}/deps/netcdf/bin/nc-config \
            --with-udunits_incdir=${UDUNITS}/include \
            --with-udunits_bindir=${UDUNITS}/bin \
            --build=$ARCH-slackware-linux

make
make install

cp -a *.ncmap nc_overlay.* ${PKG}/utils/ncview/local/lib

find $PKG/utils/ncview -print0 | xargs -0 file | grep -e "executable" -e "shared object" | grep ELF \
  | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null || true

export XAPPLRESDIR=${HOME}/.app-defaults
export PATH=${PKG}/utils/ncview/bin:${PATH}
export LD_LIBRARY_PATH=${PKG}/utils/ncview/lib:${LD_LIBRARY_PATH}

echo -e "
export XAPPLRESDIR=${HOME}/.app-defaults
export PATH=${PKG}/utils/ncview/bin:\$PATH
export LD_LIBRARY_PATH=${PKG}/utils/ncview/lib:\$LD_LIBRARY_PATH
" >> ${PKG}/env.sh


rm -rf $PKG/build


###  WRF  ###
echo
echo "---------------------------------------------------------------"
echo "Building WRF ${WRF_VER} ..."
echo "---------------------------------------------------------------"
echo
tar -C $PKG/WRF --strip-components=1 -zxf $CWD/WRFV${WRF_VER}.TAR.gz
cd $PKG/WRF
chown -R ${USERID}:${USERID} .
find -L . \
 \( -perm 777 -o -perm 775 -o -perm 750 -o -perm 711 -o -perm 555 \
  -o -perm 511 \) -exec chmod 755 {} \; -o \
 \( -perm 666 -o -perm 664 -o -perm 640 -o -perm 600 -o -perm 444 \
  -o -perm 440 -o -perm 400 \) -exec chmod 644 {} \;

# Clean
./clean -a

# Allow build with GRIB2 support
sed -i '235s/FALSE/TRUE/' arch/Config_new.pl

# Configure with dmpar
./configure << EOF
34
1
EOF

echo "Compiling WRF using command"
echo "compile em_real &> ${PKG}/WRF/log.compile"
echo "..."
./compile em_real &> log.compile

# Check if the executables have been successfully produced
if [ -x main/ndown.exe -a -x main/real.exe -a -x main/tc.exe -a -x main/wrf.exe ]; then
  echo
  echo "The executables ${PKG}/WRF/main/{ndown.exe, real.exe, tc.exe, wrf.exe} have been created successfully."
  echo "----------------------------------------------------------------------"
  echo
else
  echo
  echo "Missing executables from the expected set ${PKG}/WRF/main/{ndown.exe, real.exe, tc.exe, wrf.exe}!"
  echo "Interrupting building process."
  echo
  exit 1
fi


###  WPS  ###
echo
echo "---------------------------------------------------------------"
echo "Building WPS ${WPS_VER} ..."
echo "---------------------------------------------------------------"
echo
tar -C $PKG/WPS --strip-components=1 -zxf $CWD/WPSV${WPS_VER}.TAR.gz
cd $PKG/WPS
chown -R ${USERID}:${USERID} .
find -L . \
 \( -perm 777 -o -perm 775 -o -perm 750 -o -perm 711 -o -perm 555 \
  -o -perm 511 \) -exec chmod 755 {} \; -o \
 \( -perm 666 -o -perm 664 -o -perm 640 -o -perm 600 -o -perm 444 \
  -o -perm 440 -o -perm 400 \) -exec chmod 644 {} \;

# Clean
./clean

# Configure WPS
WRF_DIR=${PKG}/WRF \
./configure << EOF
3
EOF

# Fix path for WRF installation
sed -i '34s/WRFV3/WRF/' configure.wps

# Build
echo "Compiling WPS using command"
echo "compile &> ${PKG}/WPS/log.compile"
echo "..."
WRF_DIR=${PKG}/WRF \
./compile &> log.compile

# Check if the executables have been successfully created
if [ -x geogrid/src/geogrid.exe -a -x metgrid/src/metgrid.exe -a -x ungrib/src/ungrib.exe ]; then
  # Check if the files are zero length
  if [ -s geogrid/src/geogrid.exe -a -s metgrid/src/metgrid.exe -a -s ungrib/src/ungrib.exe ]; then
    echo
    echo "The executables ${PKG}/WPS/{geogrid.exe, metgrid.exe, ungrib.exe} have been created successfully."
    echo "----------------------------------------------------------------------"
    echo
  else
    echo
    echo "Executables ${PKG}/WPS/{geogrid.exe, metgrid.exe, ungrib.exe} exist, but are of zero length!"
    echo
    exit 3
  fi
else
  echo
  echo "Missing executables from the expected set ${PKG}/WPS/{geogrid.exe, metgrid.exe, ungrib.exe} !"
  echo
  exit 2
fi


echo
echo "----------------------------------------------------------------------"
echo "Finished installing WRF, WPS and their dependencies in"
echo "${PKG}/"
echo
echo "You may start using WRF by first setting up the environment with the"
echo "env.sh script from the installation directory:"
echo "> source env.sh"
echo
echo "----------------------------------------------------------------------"
echo


exit 0
