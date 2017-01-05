;+
;  :Description:
;    Basic analysis for an sky region of interest:
;    1) Probability Density Function Profiles;
;    2) Sky Maps;
;    3) Objects' Masses;
;  :Syntax: 
;    @basic_analysis
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

CD, '/home/xjshao/workspace/NGC2264/results'
set_plot, 'ps' &    device, xsize=21.0, ysize=29.7, /portrait, /encapsulated, /color           ; A4 sheet
P_former = !P & X_former = !X & Y_former =!Y
!P.charsize=1.6 & !P.charthick=3 & !P.thick=3
!X.thick=3 & !Y.thick=3
!X.margin=[8,8] &  !Y.margin=[4,4] 
!Y.omargin = [1,0]
forward_function mean
; .compile pdf_plot
@constants
 
    Region = {Name:'NGC 2264',  $
              Distance: 760 ,   $; pc
              Component:['-10_15', '25_35', 'undevide', 'central', 'north', 'northwest', 'southeast', 'outer'] $
              }


    Tmb_12CO_rms = 0.440401  ; 0.72 K
    Tmb_13CO_rms = 0.237389  ; 0.46
    Tmb_C18O_rms = 0.242055  ; 0.46
    
    print, '3 Tmb_12CO_rms = ', 3*Tmb_12CO_rms
    print, '3 Tmb_13CO_rms = ', 3*Tmb_13CO_rms
    print, '3 Tmb_C18O_rms = ', 3*Tmb_C18O_rms
    dv_12CO = 0.160          ; km/s
    dv_13CO = 0.168
    dv_C18O = 0.168
    print, Format='("Channel Width: 12CO ",F0,"  13CO ",F0,"  C18O ",F0)', dv_12CO, dv_13CO, dv_C18O

    reduction = {rms:0, mosaic:0, Tpeak:0, Trms:0, Tex:0, FWHM:0, tau:0, Wco:1, Nco:0, N_H2:0, PV:0} 
;        @ngc2264_reduce

    analysis = {draw_maps:0, $
                
                N_H2_12CO:0, $
                N_H2_13CO:0}
    CASE Region.Component[0]    OF   
        'undevide' : BEGIN           
                         @ngc2264_undevide
                     END            
        'central'  : BEGIN                    ; NGC 2264, Local Arm
                         @ngc2264_central
                         
                     END
        'north'    : BEGIN                    ; 
                         @ngc2264_north
                     END
        'northwest': BEGIN                    ;
                         @ngc2264_northwest
                     END
        'southeast': BEGIN
                         @ngc2264_southeast
                     END
        'outer'    : BEGIN                    ; Perseus Arm
                         @ngc2264_overlap
                     END
        
        ELSE: PRINT, "Do nothing."
    ENDCASE

;xyad,TexHdr,[0,339],[0,419],RA,Dec
;cubemoment, 'ngc226412cofinal.fits', [8.1266,11.6182], direction='B',coveragefile='mask.fits'
;cubemoment, 'ngc226412cofinal.fits', [98.7031,101.5728], direction='L',coveragefile='mask.fits'
;cubemoment, 'ngc226413cofinal.fits', [Dec], direction='B',coveragefile='mask.fits'
;cubemoment, 'ngc226413cofinal.fits', [RA], direction='L',coveragefile='mask.fits'
;cubemoment, 'ngc2264c18ofinal.fits', [Dec], direction='B',coveragefile='mask.fits'
;cubemoment, 'ngc2264c18ofinal.fits', [RA], direction='L',coveragefile='mask.fits'

!P = P_former & !X = X_former & !Y = Y_former
set_plot, 'x'

END
