;+
;  :Description:
;    Structure of Frequently Used Constants
;    query engine?
;    struture?
;    pointer?
;  :Syntax:
;    
;    Input:
;    Output:
;      file     : 
;      variable :
;  :Todo:
;    advanced function of the routine
;    additional function of the routine
;  :Categories:
;    type of the routine
;  :Uses:
;    .pro
;  :See Also:
;    .pro
;  :Params:
;    x : in, required, type=fltarr
;       independent variable
;    y : in, required, type=fltarr
;       dependent variable
;  :Keywords:
;    keyword1 : In, Type=float
;    keyword2 : In, required
;  :Author: puresky
;  :History:
;    V0     2015-09-20        
;    V0.1   2015-09-20 
;    V1.0 
;
;-
;Comment Tags:
;    http://www.exelisvis.com/docs/IDLdoc_Comment_Tags.html
;
;



;***********************************************************************
;Earth Constants

;Earth's radius
;Weast and Astle 1980,  In m
r_earth = 6.370949e+6

;Gravitational acceleration at Earth's surface
;From NIST 1998,  In m / s^2
g_earth = 9.80665

;Mass of Earth
;From Serway 1992,  In kg
m_earth = 5.98e+24

;Angular rotation speed of Earth ( 1 / s )
omega_earth = 7.292e-5

;Mean sea level pressure on Earth
;From NIST 1998,  In Pa = N / m^2
mslp = 101325.

;Astronomical unit
;From TCAEP 2001,  In m
au = 1.4959787e+11

;***********************************************************************
;Water Properties

;Density of liquid water at 0C
;From Weast and Astle 1980,  In kg / m^3
rho_lwater = 9.9987e+2

;Specific heat of liquid water at 0C
;From Weast and Astle 1980,  In J / kg / K
ct_lwater = 4.2177e+3

;Latent heat of vaporisation of water at 100C
;From Serway 1992,  In J / kg
hv_water = 2.26e+6

;Latent heat of fusion of water at 0C
;From Serway 1992,  In J / kg
hf_water = 3.33e+5

;***********************************************************************
;Air Properties

;Density of dry air at 0C and 100kPa
;From Weast and Astle 1980,  In kg / m^3
rho_dryair = 1.2929e+3



    physics = {SI, c:2.9979245882e5 $ ; km/s Spped of light in a vacuum  
                 , G:6.67384e-11    $ ; m^3/(kg s^-2) Gravitation constant
                   }  

    atom = {CGS, u: 1.660538921e-27 $ ; kg Unified atomic mass unit
               , mn:1.674927351e-27 $ ; kg Neutron mass
                 }

    
    
    molecular = {isotope, frequency:115e9}
    molecular_12CO_1_0={isotope, frequency:115e9}
    molecular_13CO_1_0={isotope, frequency:110e9}
    molecualr_C18O_1_0={isotope, frequency:109e9}

;end
