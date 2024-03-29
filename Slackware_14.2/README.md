# SlackBuilds

SlackBuilds scripts for several packages targeting the Slackware GNU/Linux 14.2
operating system. The scripts may work on earlier versions of Slackware as
well.

**Note:** The SlackBuilds for DS9, karma, latex2rtf, pgplot and WCSLib can also
be found at https://slackbuilds.org


## cudatoolkit 10.1.168

The NVIDIA® CUDA® Toolkit provides a development environment for creating
high performance GPU-accelerated applications. With the CUDA Toolkit, you can
develop, optimize and deploy your applications on GPU-accelerated embedded
systems, desktop workstations, enterprise data centers, cloud-based platforms
and HPC supercomputers. The toolkit includes GPU-accelerated libraries,
debugging and optimization tools, a C/C++ compiler and a runtime library to
deploy your application.


## ds9 8.2.1

SAOImageDS9 is an astronomical imaging and data visualization application. DS9
is a stand-alone application which supports FITS images and binary tables,
multiple frame buffers, region manipulation, and many scale algorithms and
colormaps.  DS9 supports a consistent set of GUI and functional capabilities,
as well as advanced features such as 2-D, 3-D and RGB frame buffers, mosaic
images, tiling, blinking, geometric markers, colormap manipulation, scaling,
arbitrary zoom, cropping, rotation, pan, and a variety of coordinate systems.
The GUI for DS9 is user configurable. GUI elements such as the coordinate
display, panner, magnifier, horizontal and vertical graphs, button bar, and
color bar can be configured via menus or the command line.


## karma 1.7.25

ATNF CSIRO Karma is a package for signal and image processing
applications. It contains KarmaLib (the structured library and API)
and a large number of modules and applications to perform many standard
tasks on astronomical data in common formats like FITS. It is a toolkit
for manipulating the Karma network data structure.

Another major component of KarmaLib is the display support. The display
system both provides an abstract interface to the underlying graphics
system (ie. the X window system), and also provides much higher level
functionality than many graphics libraries. As well as supporting simple
geometric primitives and text display, a powerful and flexible image
display system is included. This allows the direct mapping of
application data structures (ie. 2-D and 3-D arrays) to display
windows (canvases).

This SlackBuild script builds a Slackware package from the official
binary distributed by CSIRO.


## latex2rtf 2.3.17

latex2rtf is a translator program to convert LaTeX formatted text files into
"rich text format" (RTF) files. RTF is a published standard format by
Microsoft. This standard can be ambiguous in places, but RTF is supported by
many text editors. Specifically, it is supported by Microsoft Word. This means
that the conversion of a LaTeX document to RTF allows anyone with a copy of
Word to convert LaTeX files to Word .doc or .docx files.

Features

- Conversion of a wide range of input encodings
- Conversion of equations (unfortunately using the broken Microsoft
  implementation of EQ fields)
- Conversion of tables
- Conversion of graphics
- Conversion of cross-references
- Conversion of bibliographies

latex2rtf translates the text and as much of the formatting information from
LaTeX to RTF. Be forewarned that the typeset output is not nearly as good as
what you would get from using LaTeX directly.


## netcdf-fortran 4.5.3

NetCDF (network Common Data Form) is a set of interfaces for array-oriented
data access and a freely-distributed collection of data access libraries for C,
Fortran, C++, Java, and other languages. The netCDF libraries support a
machine-independent format for representing scientific data. Together, the
interfaces, libraries, and format support the creation, access, and sharing of
scientific data.

The netcdf-fortran package provides Fortran application interfaces for
accessing netCDF data. It depends on the netCDF C library, which must be
installed first.


## pgplot 5.2.2

PGPLOT is a Fortran subroutine package for drawing simple scientific
graphs on various graphics display devices. It was originally developed
for use with astronomical data reduction programs in the Caltech
Astronomy Department.

It consists of a library of routines that are Fortran- and C-callable.
There are routines that are device-dependent, in that they can produce
output for various terminals, image displays, dot-matrix printers,
laser printers, and pen plotters. Common file formats supported include
PostScript and GIF.

PGPLOT is not public-domain software. However, it is freely available
for non-commercial use. The source code and documentation are
copyrighted by California Institute of Technology, and may not be
redistributed or placed on public Web servers without permission. The
software is provided "as is" with no warranty.


## wcslib 5.19.1

WCSLIB is a set of C library routines that implements the World
Coordinate System (WCS) standard in FITS (Flexible Image Transport
System). It comes with support for FORTRAN via a set of wrapper
functions. It also includes a general curvilinear axis drawing
routine, PGSBOX, for PGPLOT. Another included utility program is
HPXcvt, which is used to convert 1D HEALPix pixelization data stored
in a variety of forms in FITS into a 2D primary image array with HPX
or XPH coordinate representation.

Usage with gcc compiler: use "-lwcs" command line argument for linking
at compile time.

