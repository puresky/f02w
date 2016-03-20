print, "Reducing Data"
tpeak,"S287_12CO.fits", Tmb_12CO_rms * 3, outfile="Tpeak_12CO_10_19.fits",v_range = [10,19], velocity_file='Vpeak_12CO_10_19.fits', mask_data=mask_data, n_span=2
tpeak,"S287_12CO.fits", Tmb_12CO_rms * 3, outfile="Tpeak_12CO_19_35.fits",v_range = [19,35], velocity_file='Vpeak_12CO_19_35.fits', mask_data=mask_data, n_span=2
tpeak,"S287_12CO.fits", Tmb_12CO_rms * 3, outfile="Tpeak_12CO_45_58.fits",v_range = [45,58], velocity_file='Vpeak_12CO_45_58.fits', mask_data=mask_data, n_span=2
tpeak,"S287_13CO.fits", Tmb_13CO_rms * 3, outfile="Tpeak_13CO_10_19.fits",v_range = [10,19], velocity_file='Vpeak_13CO_10_19.fits', mask_data=mask_data, n_span=2
tpeak,"S287_13CO.fits", Tmb_13CO_rms * 3, outfile="Tpeak_13CO_19_35.fits",v_range = [19,35], velocity_file='Vpeak_13CO_19_35.fits', mask_data=mask_data, n_span=2
tpeak,"S287_13CO.fits", Tmb_13CO_rms * 3, outfile="Tpeak_13CO_45_58.fits",v_range = [45,58], velocity_file='Vpeak_13CO_45_58.fits', mask_data=mask_data, n_span=2
tpeak,"S287_C18O.fits", Tmb_C18O_rms * 1, outfile="Tpeak_C18O_10_19.fits",v_range = [10,19], velocity_file='Vpeak_C18O_10_19.fits', mask_data=mask_data, n_span=2.5,/strong_search
tpeak,"S287_C18O.fits", Tmb_C18O_rms * 1, outfile="Tpeak_C18O_19_35.fits",v_range = [19,35], velocity_file='Vpeak_C18O_19_35.fits', mask_data=mask_data, n_span=2.5,/strong_search
tpeak,"S287_C18O.fits", Tmb_C18O_rms * 1, outfile="Tpeak_C18O_45_58.fits",v_range = [45,58], velocity_file='Vpeak_C18O_45_58.fits', mask_data=mask_data, n_span=2.5,/strong_search

n_co, "13CO", 'Wco', "Wco_13CO_-10_35.fits", outfile='Nco_Wco_13CO.fits'
n_co, "C18O", 'Wco', "Wco_C18O_1_12.fits",   outfile='Nco_Wco_C18O.fits'
;n_co,'13CO', 'Tpeak', 'Tpeak_13CO.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_13CO.fits', outfile='Nco_Tpeak_13CO.fits'
;n_co,'C18O', 'Tpeak', 'Tpeak_C18O.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_C18O.fits', outfile='Nco_Tpeak_C18O.fits'
;n_co, '13CO', 'tau', 'tau_13CO.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_13CO.fits', outfile='Nco_tau_13CO.fits'
;n_co, 'C18O', 'tau', 'tau_C18O.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_C18O.fits', outfile='Nco_tau_C18O.fits'


