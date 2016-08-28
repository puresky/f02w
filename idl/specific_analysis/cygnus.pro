;+
;  :Description:
;    Basic analysis for an sky region of interest:
;    1) Probability Density Function Profiles;
;    2) Sky Maps;
;    3) Objects' Masses;
;  :Syntax: 
;    Uncomment some block to make the lines function: @basic_analysis
;    Then comment them, and uncomment others. 
;    And so on.
;    Input :
;      3d (p-p-v) FITS files of CO three-line spectra data, 
;    Output:
;      ps files, fits files,
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
;    V0     2014-09-20         
;    V0.1   2014-09-20 
;    V1.0 
;
;-
;
;Comment Tags:
; http://www.exelisvis.com/docs/IDLdoc_Comment_Tags.html

CD, '/home/xjshao/workspace/CygnusX'
set_plot, 'ps' &    device, xsize=21.0, ysize=29.7, /portrait, /encapsulated, /color           ; A4 sheet
P_former = !P & X_former = !X & Y_former =!Y
!P.charsize=1.6 & !P.charthick=3 & !P.thick=3
!X.thick=3 & !Y.thick=3
!X.margin=[8,8] &  !Y.margin=[4,4] 
!Y.omargin = [1,0]

@constants
 
    RegionName = 'Cygnus '
    RegionDistance = [400]; pc
    
    Region = {Name:'Cygnus', Component:'0_16', Distance:400}
    
    Tmb_12CO_rms = 0.5  ;  K
    Tmb_13CO_rms = 0.38
    Tmb_C18O_rms = 0.3
    dv_12CO = 0.160          ; km/s
    dv_13CO = 0.168
    dv_C18O = 0.168
    
    print, "The area is referred as: ", Region.Name
    print, "This area has only one component: ", "[0,16] km/s"
    print, "The corresponding distance are: ", Region.Distance, "pc"
    print, "Observation Parameters:"
    print, '3 Tmb_12CO_rms = ', 3*Tmb_12CO_rms
    print, '3 Tmb_13CO_rms = ', 3*Tmb_13CO_rms
    print, '3 Tmb_C18O_rms = ', 3*Tmb_C18O_rms
    print, Format='("Channel Width: 12CO ",F0,"  13CO ",F0,"  C18O ",F0)', dv_12CO, dv_13CO, dv_C18O
        
    ;;;;Reducing Data
    reduction = {Tpeak:0, Tex:0, FWHM:0, tau:0, Wco:0, Nco:0, N_H2:0} 
;    @orion_reduce
    
    ;;;;Analysing Data
    analysis = {N_H2_12CO:0, $
                N_H2_13CO:0}
    case Region.Component OF            
;    @orion_0_16
;    @orion_0_16
        '0_16': BEGIN
;                @ orion_0_16
                END
        ELSE  : PRINT, "It's nothing."
    endcase

    thinfile  = 'mosaic_L.fits'
    thinrms   = 'mosaic_L_rms.fits'
    thickfile = 'mosaic_U.fits'
    thickrms  = 'mosaic_U_rms.fits'
    prepmmt, thinfile, thinrms, thickfile, thickrms
    infall_dicision
    extract_cat,'infall_dicision.fits',2
    infall_gaussfit
    extract_cat,'infall_gaussfit.fits',0.6


!P = P_former & !X = X_former & !Y = Y_former
set_plot, 'x'

end
