print, "Reducing Data"
DataCubeFile12CO = 'mosaic_U.fits'
DataCubeFile13CO = 'mosaic_L.fits'
DataCubeFileC18O = 'mosaic_L2.fits'



rawpath='~/data/MWISP/'
rmspath='~/workspace/NGC2264/data/rmsdata/'
path='~/workspace/NGC2264/data/'
side_band=['U','L','L2']


IF reduction.rms then begin
;      cuberms, DataCubeFile12CO, [-100,100], window=[-20,35]
;      cuberms, DataCubeFile13CO, [-100,100], window=[-10,20]

    l=[200,206] & b=[-0.5,4]
    l_count=(l[1]-l[0])*2+1 
    b_count=(b[1]-b[0])*2+1
    l_grid=          (indgen(l_count,b_count) mod l_count)*.5 +l[0] 
    b_grid=transpose((indgen(b_count,l_count) mod b_count)*.5)+b[0]
    grid_name = getcellname(l_grid, b_grid)
    counts=l_count*b_count-1
    CD, rmspath
;    FOREACH sideband, side_band DO BEGIN
        cubefile = rawpath+grid_name+ 'U.fits'
        for i=0,counts do cuberms, cubefile[i], [-80,160],window=[-20,50]
        cubefile = rawpath+grid_name+ 'L.fits'
        for i=0,counts do cuberms, cubefile[i], [-80,160],window=[-20,40]
        cubefile = rawpath+grid_name+'L2.fits'
        for i=0,counts do cuberms, cubefile[i], [-80,160],window=[-20,40] ;[-3,15]
;    ENDFOREACH
ENDIF

CD, path
IF reduction.mosaic THEN BEGIN
    mosaic,199,207,-1,5,-80,160,sb='U' ,path=[rawpath,rmspath],/display
    mosaic,199,207,-1,5,-80,160,sb='L' ,path=[rawpath,rmspath],/display
    mosaic,199,207,-1,5,-80,160,sb='L2',path=[rawpath,rmspath],/display
ENDIF

IF reduction.Wco THEN BEGIN 
    cubemoment, 'mosaic_U.fits', [-1,4.5],     direction='B',coveragefile='mosaic_U_coverage.fits',outname='NGC2264_12CO'
    cubemoment, 'mosaic_U.fits', [199.5,206.5], direction='L',coveragefile='mosaic_U_coverage.fits',outname='NGC2264_12CO'
    cubemoment, 'mosaic_U.fits', [-20,-10],   coveragefile='mosaic_U_coverage.fits', outname='NGC2264_12CO_-20_-10'
    cubemoment, 'mosaic_U.fits', [-10,  0],   coveragefile='mosaic_U_coverage.fits', outname='NGC2264_12CO_-10_0'
    cubemoment, 'mosaic_U.fits', [  0, 10],   coveragefile='mosaic_U_coverage.fits', outname='NGC2264_12CO_0_10'
    cubemoment, 'mosaic_U.fits', [ 10, 20],   coveragefile='mosaic_U_coverage.fits', outname='NGC2264_12CO_10_20'
    cubemoment, 'mosaic_U.fits', [ 20, 30],   coveragefile='mosaic_U_coverage.fits', outname='NGC2264_12CO_20_30'
    cubemoment, 'mosaic_U.fits', [ 30, 40],   coveragefile='mosaic_U_coverage.fits', outname='NGC2264_12CO_30_40'
    cubemoment, 'mosaic_U.fits', [ 40, 50],   coveragefile='mosaic_U_coverage.fits', outname='NGC2264_12CO_40_50'
;    fits_read,  'mosaic_U_rms.fits', RMS12CO, RMS12COHdr
    cubemoment, 'mosaic_U.fits', [-20, 50],   coveragefile='mosaic_U_coverage.fits', outname='NGC2264_12CO_-20_50', rmsfile='mosaic_U_rms.fits', /goodlooking
    
    cubemoment, 'mosaic_L.fits', [-1,4.5],     direction='B',coveragefile='mosaic_L_coverage.fits',outname='NGC2264_13CO'
    cubemoment, 'mosaic_L.fits', [199.5,206.5], direction='L',coveragefile='mosaic_L_coverage.fits',outname='NGC2264_13CO'
    cubemoment, 'mosaic_L.fits', [-20,-10], coveragefile='mosaic_L_coverage.fits', outname='NGC2264_13CO_-20_-10'
    cubemoment, 'mosaic_L.fits', [-10,0],   coveragefile='mosaic_L_coverage.fits', outname='NGC2264_13CO_-10_0'
    cubemoment, 'mosaic_L.fits', [0,10],    coveragefile='mosaic_L_coverage.fits', outname='NGC2264_13CO_0_10'
    cubemoment, 'mosaic_L.fits', [10,20],   coveragefile='mosaic_L_coverage.fits', outname='NGC2264_13CO_10_20'
    cubemoment, 'mosaic_L.fits', [20,30],   coveragefile='mosaic_L_coverage.fits', outname='NGC2264_13CO_20_30'
    cubemoment, 'mosaic_L.fits', [30,40],   coveragefile='mosaic_L_coverage.fits', outname='NGC2264_13CO_30_40'
    cubemoment, 'mosaic_L.fits', [40,50],   coveragefile='mosaic_L_coverage.fits', outname='NGC2264_13CO_40_50'
;    fits_read,  'mosaic_L_rms.fits', RMS13CO, RMS13COHdr
    cubemoment, 'mosaic_L.fits', [-20, 40],   coveragefile='mosaic_L_coverage.fits', outname='NGC2264_13CO_-20_40', rmsfile='mosaic_L_rms.fits', /goodlooking 

    cubemoment, 'mosaic_L2.fits', [-1,4.5],     direction='B',coveragefile='mosaic_L2_coverage.fits',outname='NGC2264_C18O'
    cubemoment, 'mosaic_L2.fits', [199.5,206.5], direction='L',coveragefile='mosaic_L2_coverage.fits',outname='NGC2264_C18O'
    cubemoment, 'mosaic_L2.fits', [-20,-10], coveragefile='mosaic_L2_coverage.fits', outname='NGC2264_C18O_-20_-10'
    cubemoment, 'mosaic_L2.fits', [-10,0],   coveragefile='mosaic_L2_coverage.fits', outname='NGC2264_C18O_-10_0'
    cubemoment, 'mosaic_L2.fits', [0,10],    coveragefile='mosaic_L2_coverage.fits', outname='NGC2264_C18O_0_10'
    cubemoment, 'mosaic_L2.fits', [10,20],   coveragefile='mosaic_L2_coverage.fits', outname='NGC2264_C18O_10_20'
    cubemoment, 'mosaic_L2.fits', [20,30],   coveragefile='mosaic_L2_coverage.fits', outname='NGC2264_C18O_20_30'
    cubemoment, 'mosaic_L2.fits', [30,40],   coveragefile='mosaic_L2_coverage.fits', outname='NGC2264_C18O_30_40'
    cubemoment, 'mosaic_L2.fits', [40,50],   coveragefile='mosaic_L2_coverage.fits', outname='NGC2264_C18O_40_50'
;    fits_read,  'mosaic_L2_rms.fits', RMSC18O, RMSC18OHdr
    cubemoment, 'mosaic_L2.fits', [-3, 15],   coveragefile='mosaic_L2_coverage.fits', outname='NGC2264_C18O_-3_15', rmsfile='mosaic_L2_rms.fits', /goodlooking
ENDIF



;Tpeak Vpeak
IF reduction.Tpeak then begin
    tpeak,"mosaic_U.fits", Tmb_12CO_rms * 3, outfile="Tpeak_12CO_0_16.fits",v_range = [0,16], velocity_file='Vpeak_12CO_0_16.fits', n_span=2
;    tpeak,"S287_12CO.fits", Tmb_12CO_rms * 3, outfile="Tpeak_12CO_19_35.fits",v_range = [19,35], velocity_file='Vpeak_12CO_19_35.fits', mask_data=mask_data, n_span=2
;    tpeak,"S287_12CO.fits", Tmb_12CO_rms * 3, outfile="Tpeak_12CO_45_58.fits",v_range = [45,58], velocity_file='Vpeak_12CO_45_58.fits', mask_data=mask_data, n_span=2
    tpeak,"mosaic_L.fits", Tmb_13CO_rms * 3, outfile="Tpeak_13CO_0_16.fits",v_range = [0,16], velocity_file='Vpeak_13CO_0_16.fits', n_span=2
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
if reduction.FWHM then begin
    fwhm, 'OrionU.fits', outfile='Tfwhm_12CO_0_16.fits', v_center_file = 'Vcenter_12CO_0_16.fits', v_range = [0,16],quality_file='Quality_FWHM_12CO.fits';, estimates=[1,5,1,0,0,0]
    fwhm, 'OrionL.fits', outfile='Tfwhm_13CO_0_16.fits', v_center_file = 'Vcenter_13CO_0_16.fits', v_range = [0,16]
    ;fwhm, 'ngc2264c18ofinal.fits', outfile='fwhm_C18O.fits', v_center_file = 'Vcenter_C18O.fits', v_range = [-10,20]
endif

;Optical Depth
if reduction.tau then begin
    tau,'Tpeak_13CO_0_16.fits',tex_file='Tex_0_16.fits',outfile='tau_13CO_0_16.fits',threshold=1*Tmb_13CO_rms
    ;tau,'Tpeak_C18O.fits',tex_file='Tex.fits',outfile='tau_C18O.fits',threshold=1*Tmb_C18O_rms
    ;tau cube
    tau, 'OrionL.fits', tex_file='Tex_0_16.fits', outfile='Orion_tau_13CO.fits', threshold=3*Tmb_13CO_rms
endif

;Wco
IF reduction.Wco then begin
;    cubemoment, 'OrionU.fits', [0,16], outname='Orion_12CO_0_16', threshold=3*Tmb_12CO_rms & file_move,'Orion_12CO_0_16_m0.fits','Orion_Wco_12CO_0_16.fits',/overwrite
;    cubemoment, RegionName+'U.fits', [-20,35], outname=RegionName+'_12CO_-20_35', threshold=3*Tmb_12CO_rms & file_move,RegionName+'_12CO_-20_35_m0.fits',RegionName+'_Wco_12CO_-20_35.fits',/overwrite
;    cubemoment, 'S287_12CO.fits', [45,58], outname='S287_12CO_45_58' & file_move,'S287_12CO_45_58_m0.fits','S287_Wco_12CO_45_58.fits',/overwrite
;    cubemoment, 'OrionL.fits', [0,16], outname='Orion_13CO_0_16', threshold=3*Tmb_13CO_rms & file_move,'Orion_13CO_0_16_m0.fits','Orion_Wco_13CO_0_16.fits',/overwrite
;    cubemoment, 'S287_13CO.fits', [19,35], outname='S287_13CO_19_35' & file_move,'S287_13CO_19_35_m0.fits','S287_Wco_13CO_19_35.fits',/overwrite
;    cubemoment, 'S287_13CO.fits', [45,58], outname='S287_13CO_45_58' & file_move,'S287_13CO_45_58_m0.fits','S287_Wco_13CO_45_58.fits',/overwrite
;    cubemoment, 'S287_C18O.fits', [10,19], outname='S287_C18O_10_19' & file_move,'S287_C18O_10_19_m0.fits','S287_Wco_C18O_10_19.fits',/overwrite
;    cubemoment, 'S287_C18O.fits', [19,35], outname='S287_C18O_19_35' & file_move,'S287_C18O_19_35_m0.fits','S287_Wco_C18O_19_35.fits',/overwrite
;    cubemoment, 'Orion_tau_13CO.fits', [0,16], outname='Orion_tau_13CO_0_16', /zeroth_only
ENDIF

;CO column density
IF reduction.Nco THEN BEGIN 
    n_co, '13CO', 'Wco', "NGC 2264_Wco_13CO_0_16.fits", Tex_file="Tex_0_16.fits", outfile=RegionName+'_Nco_Wco_13CO_0_16.fits'
    n_co, '13CO', 'Wco tau', "NGC 2264_Wco_13CO_0_16.fits", Tex_file="Tex_0_16.fits", tau_file="tau_13CO_0_16.fits", outfile=RegionName+'_Nco_Wcotau_13CO_0_16.fits'
    n_co, '13CO', 'tau m0', "NGC 2264_tau_13CO_0_16_m0.fits", tex_file="Tex_0_16.fits", outfile=RegionName+'_Nco_tau_m0_13CO_0_16.fits'
;    n_co, "C18O", 'Wco', "S287_Wco_C18O_10_19.fits", tex_file="Tex_10_19.fits", outfile='Nco_Wco_C18O_10_19.fits'
;    n_co, "C18O", 'Wco', "S287_Wco_C18O_19_35.fits", tex_file="Tex_19_35.fits", outfile='Nco_Wco_C18O_19_35.fits'
;    n_co, "C18O", 'Wco', "S287_Wco_C18O_45_58.fits", tex_file="Tex_45_58.fits", outfile='Nco_Wco_C18O_45_58.fits'
;n_co,'13CO', 'Tpeak', 'Tpeak_13CO.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_13CO.fits', outfile='Nco_Tpeak_13CO.fits'
;n_co,'C18O', 'Tpeak', 'Tpeak_C18O.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_C18O.fits', outfile='Nco_Tpeak_C18O.fits'
;n_co, '13CO', 'tau', 'tau_13CO.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_13CO.fits', outfile='Nco_tau_13CO.fits'
;n_co, 'C18O', 'tau', 'tau_C18O.fits', tex_file="Tex.fits", fwhm_file='Tfwhm_C18O.fits', outfile='Nco_tau_C18O.fits'
ENDIF

;H2 column density
IF reduction.N_H2 THEN BEGIN
;.compile n_h2
    n_h2, '12CO', RegionName+'_Wco_12CO_-20_35.fits',   outfile=RegionName+'_N_H2_Wco_12CO_-20_35.fits'
    n_h2, '12CO', RegionName+'_Wco_12CO_0_16.fits',     outfile=RegionName+'_N_H2_Wco_12CO_0_16.fits'
;    n_h2, '12CO', 'S287_Wco_12CO_45_58.fits',     outfile='S287_N_H2_Wco_12CO_45_58.fits'
    n_h2, '13CO', 'Orion_Nco_Wco_13CO_0_16.fits', outfile='Orion_N_H2_Wco_13CO_0_16.fits'
    n_h2, '13CO', RegionName+'_Nco_Wcotau_13CO_0_16.fits', outfile=RegionName+'_N_H2_Wcotau_13CO_0_16.fits'
    n_h2, '13CO', RegionName+'_Nco_tau_m0_13CO_0_16.fits', outfile=RegionName+'_N_H2_tau_m0_13CO_0_16.fits'
;    n_h2, 'C18O', 'S287_Nco_Wco_C18O_10_19.fits', outfile='S287_N_H2_Wco_C18O_10_19.fits'
;    n_h2, 'C18O', 'S287_Nco_Wco_C18O_19_35.fits', outfile='S287_N_H2_Wco_C18O_19_35.fits'
;    n_h2, 'C18O', 'S287_Nco_Wco_C18O_45_58.fits', outfile='S287_N_H2_Wco_C18O_45_58.fits'
;n_h2, '13CO', 'Nco_Tpeak_13CO.fits', outfile='N_H2_Nco_Tpeak_13CO.fits'
;n_h2, 'C18O', 'Nco_Tpeak_C18O.fits', outfile='N_H2_Nco_Tpeak_C18O.fits'
;n_h2, '13CO', 'Nco_tau_13CO.fits', outfile='N_H2_Nco_tau_13CO.fits'
;n_h2, 'C18O', 'Nco_tau_C18O.fits', outfile='N_H2_Nco_tau_C18O.fits'
ENDIF


