print, "Reducing Data"
DataCubeFile12CO = 'OrionU.fits'
DataCubeFile13CO = 'OrionL.fits'
DataCubeFileC18O = 'OrionL2.fits'
;Tpeak Vpeak
IF reduction.Tpeak then begin
    tpeak,"OrionU.fits", Tmb_12CO_rms * 3, outfile="Tpeak_12CO_0_16.fits",v_range = [0,16], velocity_file='Vpeak_12CO_0_16.fits', n_span=2
;    tpeak,"S287_12CO.fits", Tmb_12CO_rms * 3, outfile="Tpeak_12CO_19_35.fits",v_range = [19,35], velocity_file='Vpeak_12CO_19_35.fits', mask_data=mask_data, n_span=2
;    tpeak,"S287_12CO.fits", Tmb_12CO_rms * 3, outfile="Tpeak_12CO_45_58.fits",v_range = [45,58], velocity_file='Vpeak_12CO_45_58.fits', mask_data=mask_data, n_span=2
    tpeak,"OrionL.fits", Tmb_13CO_rms * 3, outfile="Tpeak_13CO_0_16.fits",v_range = [0,16], velocity_file='Vpeak_13CO_0_16.fits', n_span=2
;    tpeak,"S287_13CO.fits", Tmb_13CO_rms * 3, outfile="Tpeak_13CO_19_35.fits",v_range = [19,35], velocity_file='Vpeak_13CO_19_35.fits', mask_data=mask_data, n_span=2
;    tpeak,"S287_13CO.fits", Tmb_13CO_rms * 3, outfile="Tpeak_13CO_45_58.fits",v_range = [45,58], velocity_file='Vpeak_13CO_45_58.fits', mask_data=mask_data, n_span=2
;    tpeak,"S287_C18O.fits", Tmb_C18O_rms * 1, outfile="Tpeak_C18O_10_19.fits",v_range = [10,19], velocity_file='Vpeak_C18O_10_19.fits', mask_data=mask_data, n_span=2.5;,/strong_search
;    tpeak,"S287_C18O.fits", Tmb_C18O_rms * 1, outfile="Tpeak_C18O_19_35.fits",v_range = [19,35], velocity_file='Vpeak_C18O_19_35.fits', mask_data=mask_data, n_span=2.5;,/strong_search
;    tpeak,"S287_C18O.fits", Tmb_C18O_rms * 1, outfile="Tpeak_C18O_45_58.fits",v_range = [45,58], velocity_file='Vpeak_C18O_45_58.fits', mask_data=mask_data, n_span=2.5;,/strong_search
endif

;Tex
if reduction.Tex then begin
    tex, "Tpeak_12CO_0_16.fits",outfile="Tex_0_16.fits"
;    tex, "Tpeak_12CO_19_35.fits",outfile="Tex_19_35.fits"
;    tex, "Tpeak_12CO_45_58.fits",outfile="Tex_45_58.fits"
endif

;Velocity Field
if reduction.Tex then begin
fwhm, 'OrionU.fits', outfile='Tfwhm_12CO_0_16.fits', v_center_file = 'Vcenter_12CO_0_16.fits', v_range = [0,16],quality_file='Quality_FWHM_12CO.fits';, estimates=[1,5,1,0,0,0]
fwhm, 'OrionL.fits', outfile='Tfwhm_13CO_0_16.fits', v_center_file = 'Vcenter_13CO_0_16.fits', v_range = [0,16]
;fwhm, 'ngc2264c18ofinal.fits', outfile='fwhm_C18O.fits', v_center_file = 'Vcenter_C18O.fits', v_range = [-10,20]
endif

;Optical Depth
if reduction.tau then begin
tau,'Tpeak_13CO_0_16.fits',tex_file='Tex_0_16.fits',outfile='tau_13CO_0_16.fits',threshold=1*Tmb_13CO_rms
;tau,'Tpeak_C18O.fits',tex_file='Tex.fits',outfile='tau_C18O.fits',threshold=1*Tmb_C18O_rms
;tau,
endif

;Wco

    cubemoment, 'OrionU.fits', [0,16], outname='Orion_12CO_0_16' & file_move,'Orion_12CO_0_16_m0.fits','Orion_Wco_12CO_0_16.fits',/overwrite
;    cubemoment, 'S287_12CO.fits', [19,35], outname='S287_12CO_19_35' & file_move,'S287_12CO_19_35_m0.fits','S287_Wco_12CO_19_35.fits',/overwrite
;    cubemoment, 'S287_12CO.fits', [45,58], outname='S287_12CO_45_58' & file_move,'S287_12CO_45_58_m0.fits','S287_Wco_12CO_45_58.fits',/overwrite
    cubemoment, 'OrionL.fits', [0,16], outname='Orion_13CO_0_16' & file_move,'Orion_13CO_0_16_m0.fits','Orion_Wco_13CO_0_16.fits',/overwrite
;    cubemoment, 'S287_13CO.fits', [19,35], outname='S287_13CO_19_35' & file_move,'S287_13CO_19_35_m0.fits','S287_Wco_13CO_19_35.fits',/overwrite
;    cubemoment, 'S287_13CO.fits', [45,58], outname='S287_13CO_45_58' & file_move,'S287_13CO_45_58_m0.fits','S287_Wco_13CO_45_58.fits',/overwrite
;    cubemoment, 'S287_C18O.fits', [10,19], outname='S287_C18O_10_19' & file_move,'S287_C18O_10_19_m0.fits','S287_Wco_C18O_10_19.fits',/overwrite
;    cubemoment, 'S287_C18O.fits', [19,35], outname='S287_C18O_19_35' & file_move,'S287_C18O_19_35_m0.fits','S287_Wco_C18O_19_35.fits',/overwrite
;    cubemoment, 'S287_C18O.fits', [45,58], outname='S287_C18O_45_58' & file_move,'S287_C18O_45_58_m0.fits','S287_Wco_C18O_45_58.fits',/overwrite


;CO column density
    n_co, '13CO', 'Wco', "Orion_Wco_13CO_0_16.fits", tex_file="Tex_0_16.fits", outfile=RegionName+'Nco_Wco_13CO_0_16.fits'
;    n_co, '13CO', 'Wco', "S287_Wco_13CO_19_35.fits", tex_file="Tex_19_35.fits", outfile='Nco_Wco_13CO_19_35.fits'
;    n_co, '13CO', 'Wco', "S287_Wco_13CO_45_58.fits", tex_file="Tex_45_58.fits", outfile='Nco_Wco_13CO_45_58.fits'
;    n_co, "C18O", 'Wco', "S287_Wco_C18O_10_19.fits", tex_file="Tex_10_19.fits", outfile='Nco_Wco_C18O_10_19.fits'
;    n_co, "C18O", 'Wco', "S287_Wco_C18O_19_35.fits", tex_file="Tex_19_35.fits", outfile='Nco_Wco_C18O_19_35.fits'
;    n_co, "C18O", 'Wco', "S287_Wco_C18O_45_58.fits", tex_file="Tex_45_58.fits", outfile='Nco_Wco_C18O_45_58.fits'
;n_co,'13CO', 'Tpeak', 'Tpeak_13CO.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_13CO.fits', outfile='Nco_Tpeak_13CO.fits'
;n_co,'C18O', 'Tpeak', 'Tpeak_C18O.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_C18O.fits', outfile='Nco_Tpeak_C18O.fits'
;n_co, '13CO', 'tau', 'tau_13CO.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_13CO.fits', outfile='Nco_tau_13CO.fits'
;n_co, 'C18O', 'tau', 'tau_C18O.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_C18O.fits', outfile='Nco_tau_C18O.fits'

;H2 column density
;.compile n_h2
;    n_h2, '12CO', 'S287_Wco_12CO_10_19.fits',     outfile='S287_N_H2_Wco_12CO_10_19.fits'
    n_h2, '12CO', 'Orion_Wco_12CO_0_16.fits',     outfile='Orion_N_H2_Wco_12CO_0_16.fits'
;    n_h2, '12CO', 'S287_Wco_12CO_45_58.fits',     outfile='S287_N_H2_Wco_12CO_45_58.fits'
    n_h2, '13CO', 'Orion_Nco_Wco_13CO_0_16.fits', outfile='Orion_N_H2_Wco_13CO_0_16.fits'
;    n_h2, '13CO', 'S287_Nco_Wco_13CO_19_35.fits', outfile='S287_N_H2_Wco_13CO_19_35.fits'
;    n_h2, '13CO', 'S287_Nco_Wco_13CO_45_58.fits', outfile='S287_N_H2_Wco_13CO_45_58.fits'
;    n_h2, 'C18O', 'S287_Nco_Wco_C18O_10_19.fits', outfile='S287_N_H2_Wco_C18O_10_19.fits'
;    n_h2, 'C18O', 'S287_Nco_Wco_C18O_19_35.fits', outfile='S287_N_H2_Wco_C18O_19_35.fits'
;    n_h2, 'C18O', 'S287_Nco_Wco_C18O_45_58.fits', outfile='S287_N_H2_Wco_C18O_45_58.fits'
;n_h2, '13CO', 'Nco_Tpeak_13CO.fits', outfile='N_H2_Nco_Tpeak_13CO.fits'
;n_h2, 'C18O', 'Nco_Tpeak_C18O.fits', outfile='N_H2_Nco_Tpeak_C18O.fits'
;n_h2, '13CO', 'Nco_tau_13CO.fits', outfile='N_H2_Nco_tau_13CO.fits'
;n_h2, 'C18O', 'Nco_tau_C18O.fits', outfile='N_H2_Nco_tau_C18O.fits'



