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


set_plot, 'ps' &    device, xsize=21.0, ysize=29.7, /portrait, /encapsulated, /color           ; A4 sheet
P_former = !P & X_former = !X & Y_former =!Y
!P.charsize=1.6 & !P.charthick=3 & !P.thick=3
!X.thick=3 & !Y.thick=3
!X.margin=[8,8] &  !Y.margin=[4,4] 
!Y.omargin = [1,0]
forward_function mean
.compile pdf_plot
 
RegionName = 'NGC 2264'
distance = 760 ; pc
RegionDistance = distance

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

;    @ngc2264_reduce
     @ngc2264_undevide
;    @ngc2264_a
;    @ngc2264_b
;    @ngc2264_c
;    @ngc2264_overlap

;xyad,TexHdr,[0,339],[0,419],RA,Dec
;cubemoment, 'ngc226412cofinal.fits', [8.1266,11.6182], direction='B',coveragefile='mask.fits'
;cubemoment, 'ngc226412cofinal.fits', [98.7031,101.5728], direction='L',coveragefile='mask.fits'
;cubemoment, 'ngc226413cofinal.fits', [Dec], direction='B',coveragefile='mask.fits'
;cubemoment, 'ngc226413cofinal.fits', [RA], direction='L',coveragefile='mask.fits'
;cubemoment, 'ngc2264c18ofinal.fits', [Dec], direction='B',coveragefile='mask.fits'
;cubemoment, 'ngc2264c18ofinal.fits', [RA], direction='L',coveragefile='mask.fits'

!P = P_former & !X = X_former & !Y = Y_former
set_plot, 'x'
