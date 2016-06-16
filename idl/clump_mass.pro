;+
;  Description:  
;      used for calculations after clump find.
;      Fits files are multi-layered.
;-

pro clump_mass, ClumpCatalog, ClumpFits, cube_thick, cube_thin
    if ~keyword_set(ClumpCatalog) then ClumpCatalog = 'out_13CO.fit' ;clumpfind output catalog
    if ~keyword_set(ClumpFits)    then ClumpFits    = 'out_13CO.fits'	;clumpfind output fits, convert from sdf
    if ~keyword_set(cube_thick)   then cube_thick = 'cube_12CO_like13CO.fits' ;datacube with the same shape as 13CO datacube
    if ~keyword_set(cube_thin)    then cube_thin  = 'cube_13CO.fits'          ;datacube of 13CO

    fits_read, ClumpCatalog, tab, hdr		
    fits_read, ClumpFits,  clump, header	
    fits_read, cube_thick, T12, h12	
    fits_read, cube_thin,  T13, h13		
;    T12 /= 0.5	;beam eff
;    T13 /= 0.5	;beam eff
    
    nclump=sxpar(hdr,'NAXIS2')
    
    openw,lun,'clump_mass.dat',/get_lun
    for i=1,nclump do begin
    	c = clump eq i
    	Wco = total(T13*c, 3)*0.168	;integrated intensity
    	errWco=0.154/0.5*0.168*sqrt(total(c,3))	;error of ii
    	Tmb = max(T12*c,dim=3)		;12CO T_MB
    	errtmb=0.228/0.5		;rms of T_MB
    	Tex=tmb2tex(tmb)
    	errTex=(tmb2tex(tmb+errtmb)-tmb2tex(tmb-errtmb))/2
    	m=wco2mass(Wco,Tex)
    	errm=(wco2mass(Wco+errWco,Tex+errTex)-wco2mass(Wco-errWco,Tex-errTex))/2
    	print,i,' ',max(Tex[where(Wco gt 0)]),' ',mean(errTex[Wco gt 0]),' ',m,' ',errm
    	printf,lun,i,' ',max(Tex[where(Wco ne 0)]),' ',mean(errTex[Wco ne 0]),' ',m,' ',errm
    endfor
    close,lun
    free_lun,lun
end

function tmb2tex, tmb
   T0 = 5.53213817d
   JTbg=(exp(T0/2.7)-1)^(-1)
   Tex = T0*(alog(1+(Tmb/T0+JTbg)^(-1)))^(-1)
   return,Tex
end

function wco2mass, Wco, Tex
    N = 1.49e20*Wco/(1-exp(-5.29/Tex))
    return,total(N)*((30d*600*1.49597870700e13))^2*(2.8*1.6605e-24)/(1.9891e33)
end
