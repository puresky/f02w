#!/bin/csh -f
############################################################
# created via WWW at Sat Aug 17 11:20:43 1996
############################################################
setenv SSW /ssw
setenv ssw_host esa.nascom.nasa.gov
setenv ssw_sw_host esa.nascom.nasa.gov
setenv ssw_sw_sets "ssw_ssw_site ssw_ssw_unsupport ssw_soho_eit ssw_soho_gen ssw_ssw_gen ssw_yohkoh_gen ssw_yohkoh_ysgen ssw_yohkoh_sxt"
setenv ssw_db_sets ""
############################################################

#
#                               S.L.Freeland
#				27-May-1996 - adapt from ys_install for SSW
#
#; Name:    ssw_install
#;
#; Purpose: auto-ftp, then install or upgrade from compressed tar files
#;
#; Calling Sequence:
#;   ssw_install [/noftp] [/site] [/nodelete] [/nodbase] [/noexe] [/help]
#;
#; Optional Parameters (override defaults):
#;	/full	  - force full upgrade
#;	/noftp	  - dont ftp new files (use existing $SSW/offline/swmaint/tar)
#;      /site     - force installation of site branch
#;      /nodbase  - dont unpack data base files
#;      /nodelete - dont remove tar files
#;      /noexe    - inhibits execution of customized script
#;      /size	  - print installation disk size requirements and exit
#;      /ysrem	  - remove branches from ys PRIOR to ftp transfer
#;      /help     - print out this header and exit with no action
#;
#; Notes:
#;      site branch - available for local routines and local cusomization
#;                    default is to not clobber this if it exists
#;      dbase files - these include Yohkoh ephemeris, Yohkoh event logs
#;                    goes events/data.... etc  These are highly recommended
#;                    for full SW function unless disk space is extremely
#;                    limited at your site
#;
#;History:      
#;	27-May-1996 - Samuel Freeland, adapted for SSW
#;		      ys->SSW, permit SW installation package from $ssw_host
#;		      (default host = sohoftp.nascom.nasa.gov)
#;

set curdir=`pwd`
setenv ssw_curdir $curdir
if (!($?SSW)) then
   if ($curdir:t == "tar") set curdir=$curdir:h
   if ($curdir:t == "swmaint") then
      setenv SSW $curdir:h
   else
      if( (!($?ys)) && (-e /ys) ) then
        setenv ys /ys
      else
         echo  Please define environmental variable SSW and retry
         echo  or run this from your tar file location...
         exit           #### unstructured exit
      endif
   endif
endif

# --- setup defaults---
setenv ssw_noftp  0	        # default is to ftp files required
setenv ssw_dosite 0            # instll ys_site
setenv ssw_dodata 1            # install any existing non-ys (ydb,etc)
setenv ssw_remove 1            # remove tar files after installation
setenv ssw_doexe  1            # execute customized script
setenv ssw_dohelp 0	        # dont show help
setenv ssw_full   0	        # default is incremental if available
setenv ssw_size   0		# if set, print size diagnostics and exit
setenv ssw_ysrem  0		# if set, remove ys before ftp transfer
# ----------------------------------------------------------------------
# update defaults if site config file exists
if (-e $SSW/site/setup/ssw_install.config) source $$SSW/site/setup/ssw_install.config
# ----------------------------------------------------------------------
# --- handle parameters ---
foreach argx ($argv)
   switch ($argx)
      case full:		# force full upgrade (def=incremental)
      case /full:
         setenv ssw_full 1
	 breaksw
      case site:                # force site branch expansion
      case /site:
         setenv ssw_dosite 1
         breaksw
      case dbase:                # force data base expansion (default)
      case /dbase:
         setenv ssw_dodata 1
         breaksw
      case nodbase:		 # inhibit data base expansion
      case /nodbase:
         setenv ssw_dodata 0
         breaksw
      case delete:              # force tar file removal
      case /delete:
      case remove:
      case /remove:
         setenv ssw_remove 1
         breaksw
      case /nodelete:           # inhibit tar file removal
      case nodelete:
      case noremove:
      case /noremove:
          setenv ssw_remove 0
          breaksw
      case noexe:               # inhibit exectution of script
      case /noexec:
      case /noexe:
         setenv ssw_doexe 0
         breaksw
      case help:
      case /help:
         setenv ssw_dohelp 1
         breaksw
      case noftp:
      case /noftp:
	 setenv ssw_noftp 1
         breaksw
      case ysrem:
      case /ysrem:
         setenv ssw_ysrem 1
         breaksw
      case size:
      case /size:
         setenv ssw_size 1
         breaksw
      default:                                  # dont know this one
          echo Unrecognized option: $argx
	  echo Exiting....
	  exit					### unstructured exit
          breaksw
   endsw
end
# ------------------------------------------------------------------

if ($ssw_dohelp == 1) then
   cat $SSW/offline/swmaint/tar/ssw_install | grep "#;"
   exit
endif

# ----- get newest installation kit ------------
unset noclobber				# protect agains local environ
set workdir=$SSW/offline/swmaint/script
set host=`hostname`
mkdir -p $workdir

# slf 13-Jul-1994 - make boot tape (/noftp) compatible with network install

set instools=ssw_install.tar

if (!($?ssw_sw_host)) then
   setenv ssw_host "150.144.30.91"
endif

if (!($?user)) then
   set user=`whoami`
endif

if ( (-e ssw_install.tar.Z) && ($ssw_noftp == 1)) then
   cp -p ssw_install.tar.Z $workdir			# probably boot tape
   cd $workdir   
else
   cd $workdir
   set ftpins = $workdir/getins.ftp
   echo Generating ftp transfer script
   ########## build ftp script ########
   echo "open "$ssw_host     				>  $ftpins
   echo user ftp "$user""@""$host"			>> $ftpins
   echo binary		     				>> $ftpins
   echo cd /solarsoft/offline/swmaint/tar   		>> $ftpins
   echo get $instools".Z"    				>> $ftpins
   echo bye		     				>> $ftpins
   ####################################
   echo Starting ftp transfer of installation package: $instools".Z"
   ftp -in < $ftpins 
endif

if (!(-e $instools".Z")) then
   if ($ssw_noftp == 1) then
      echo "Could not find installation package:"$instools.".Z"
      echo "Contact freeland@penumbra.nascom.nasa.gov for guidence..."
   else
      echo "Trouble transfering installation package, try again later..."
   endif
endif

uncompress -f $instools".Z"
tar -xf $instools
# transfer control to $workdir/ssw_install.control
echo Transferring control to: $workdir/ssw_install.control
source $workdir/ssw_install.control
exit
