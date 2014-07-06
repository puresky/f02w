pro clump_mass

    fits_read,'out_13CO.fit',tab,hdr		;clumpfind output catalog
    fits_read,'out_13CO.fits',clump,header		;clumpfind output fits, convert from sdf
    fits_read,'../cube_12CO_like13CO.fits',T12,h12	;datacube with the same shape as 13CO datacube
    fits_read,'../cube_13CO.fits',T13,h13		;datacube of 13CO
    T12 /= 0.5	;beam eff
    T13 /= 0.5	;beam eff
    
    nclump=sxpar(hdr,'NAXIS2')
    
    openw,lun,'clump_mass.dat',/get_lun
    for i=1,nclump do begin
    	c = clump eq i
    	sum = total(T13*c, 3)*0.168	;integrated intensity
    	errsum=0.154/0.5*0.168*sqrt(total(c,3))	;error of ii
    	Tmb = max(T12*c,dim=3)		;12CO T_MB
    	errtmb=0.228/0.5		;rms of T_MB
    	tex=tmb2tex(tmb)
    	errtex=(tmb2tex(tmb+errtmb)-tmb2tex(tmb-errtmb))/2
    	m=mass(sum,tex)
    	errm=(mass(sum+errsum,tex+errtex)-mass(sum-errsum,tex-errtex))/2
    	print,i,' ',max(Tex[where(sum gt 0)]),' ',mean(errtex[sum gt 0]),' ',m,' ',errm
    	printf,lun,i,' ',max(Tex[where(sum ne 0)]),' ',mean(errtex[sum ne 0]),' ',m,' ',errm
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

function mass, sum, tex
    N = 1.49e20*sum/(1-exp(-5.29/Tex))
    return,total(N)*((30d*600*1.49597870700e13))^2*(2.8*1.6605e-24)/(1.9891e33)
end
