;;;;Reducing Data
cube_12CO = 'ngc226412cofinal.fits'
cube_13CO = 'ngc226413cofinal.fits'
cube_C18O = 'ngc2264c18ofinal.fits'

;tpeak,cube_12CO, Tmb_12CO_rms * 3, outfile="Tpeak_12CO.fits",v_range = [-10,40], velocity_file='Vpeak_12CO.fits', mask_data=mask_data, n_span=2
;tpeak,cube_13CO, Tmb_13CO_rms * 3, outfile="Tpeak_13CO.fits",v_range = [-10,35], velocity_file='Vpeak_13CO.fits', mask_data=mask_data, n_span=2
;tpeak,cube_C18O, Tmb_C18O_rms * 1, outfile="Tpeak_C18O.fits",v_range = [  1,12], velocity_file='Vpeak_C18O.fits', mask_data=mask_data, n_span=2.5,/strong_search


;tex, "Tpeak_12CO.fits",outfile="Tex.fits"




;cubemoment, 'ngc226412cofinal.fits', [-10,40]
;cubemoment, 'ngc226413cofinal.fits', [-10,35]
;cubemoment, 'ngc2264c18ofinal.fits', [1,12]
;file_move,'ngc226412cofinal_m0.fits','Wco_12CO_-10_40.fits'
;file_move,'ngc226413cofinal_m0.fits','Wco_13CO_-10_35.fits'
;file_move,'ngc2264c18ofinal_m0.fits','Wco_18CO_1_12.fits'


;fwhm, 'ngc226412cofinal.fits', outfile='fwhm_12CO.fits', v_center_file = 'Vcenter_12CO.fits', v_range = [-35,75],quality_file='Quality_fwhm_12CO.fits';, estimates=[1,5,1,0,0,0]
;fwhm, 'ngc226413cofinal.fits', outfile='fwhm_13CO.fits', v_center_file = 'Vcenter_13CO.fits', v_range = [-20,60]
;fwhm, 'ngc2264c18ofinal.fits', outfile='fwhm_C18O.fits', v_center_file = 'Vcenter_C18O.fits', v_range = [-10,20]

;tau,'Tpeak_13CO.fits',tex_file='Tex.fits',outfile='tau_13CO.fits',threshold=1*Tmb_13CO_rms
;tau,'Tpeak_C18O.fits',tex_file='Tex.fits',outfile='tau_C18O.fits',threshold=1*Tmb_C18O_rms

;n_co, "13CO", 'Wco', "Wco_13CO_-10_35.fits", outfile='Nco_Wco_13CO.fits'
;n_co, "C18O", 'Wco', "Wco_C18O_1_12.fits",   outfile='Nco_Wco_C18O.fits'
;n_co,'13CO', 'Tpeak', 'Tpeak_13CO.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_13CO.fits', outfile='Nco_Tpeak_13CO.fits'
;n_co,'C18O', 'Tpeak', 'Tpeak_C18O.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_C18O.fits', outfile='Nco_Tpeak_C18O.fits'
;n_co, '13CO', 'tau', 'tau_13CO.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_13CO.fits', outfile='Nco_tau_13CO.fits'
;n_co, 'C18O', 'tau', 'tau_C18O.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_C18O.fits', outfile='Nco_tau_C18O.fits'

; .compile n_h2
;n_h2, '12CO', '12co_-10_40_int.fits', outfile='N_H2_Wco_12CO.fits'
;n_h2, '13CO', 'Nco_13co_-10_35_int.fits', outfile='N_H2_Nco_13CO.fits'
;n_h2, 'C18O', 'Nco_c18o_1_12_int.fits', outfile='N_H2_Nco_c18o_1_12_int.fits'
;n_h2, '13CO', 'Nco_Tpeak_13CO.fits', outfile='N_H2_Nco_Tpeak_13CO.fits'
;n_h2, 'C18O', 'Nco_Tpeak_C18O.fits', outfile='N_H2_Nco_Tpeak_C18O.fits'
;n_h2, '13CO', 'Nco_tau_13CO.fits', outfile='N_H2_Nco_tau_13CO.fits'
;n_h2, 'C18O', 'Nco_tau_C18O.fits', outfile='N_H2_Nco_tau_C18O.fits'



;xyad,TexHdr,[0,339],[0,419],RA,Dec
;print,'RA=',RA,'Dec=',Dec	;[98.7031,101.5728][8.1266,11.6182]
;cubemoment, 'ngc226412cofinal.fits', [Dec], direction='B',coveragefile='mask.fits'
;cubemoment, 'ngc226412cofinal.fits', [RA ], direction='L',coveragefile='mask.fits'
;cubemoment, 'ngc226413cofinal.fits', [Dec], direction='B',coveragefile='mask.fits'
;cubemoment, 'ngc226413cofinal.fits', [RA ], direction='L',coveragefile='mask.fits'
;cubemoment, 'ngc2264c18ofinal.fits', [Dec], direction='B',coveragefile='mask.fits'
;cubemoment, 'ngc2264c18ofinal.fits', [RA ], direction='L',coveragefile='mask.fits'


