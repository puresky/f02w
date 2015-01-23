#MIRIAD
setenv MIR /opt/miriad
source /opt/miriad/scripts/MIRRC
setenv PATH /opt/miriad/linux64/bin:$PATH
 
#GILDAS
setenv GAG_ROOT_DIR /opt/gildas-exe-mar13a
setenv GAG_EXEC_SYSTEM      x86_64-fedora17-gfortran-g95
source $GAG_ROOT_DIR/etc/login
#setenv GAG_ROOT_DIR=/opt/gildas-exe-may12b
#setenv      GAG_EXEC_SYSTEM=x86_64-fedora17-gfortran-g95
#source $GAG_ROOT_DIR/etc/login
