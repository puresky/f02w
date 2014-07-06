;
;FWHM = (8 ln(2))^(1/2) sigma
;this script is used to calculate FWHM of spectrum from data cube.
;Usage:
;    .compile fwhm.pro
;    fwhm,"infilename"[, outfile="FWHM.fits", v_range=[-50,50]]
;Output:
;    file: FWHM.fits
;          Position.fits
;          Qulity.fits

pro fwhm,infile,outfile=outfile,v_center_file = v_center_file, v_range=v_range, quality_file=quality_file;, estimates=estimates
    if n_params() lt 1 then begin
        print, 'Syntax - fwhm, infile [, outfile= ][, v_range= ]'
        print, 'velocities in km/s'
        return
    endif
    if ~keyword_set(outfile) then outfile='FWHM_'+infile
    if ~keyword_set(v_center_file) then v_center_file = 'Vcenter_'+infile 
    if ~keyword_set(v_range) then v_range=[-50,50]
;    if ~keyword_set(estimates) then estimates=[1,mean(v_range),0,0,0,0]
    if ~keyword_set(quality_file) then quality_file='Quality_FWHM_'+infile

    print, 'search velocity range: ',v_range
    print, 'infile is "'+infile+'", outfile is "'+outfile+'"'
    print, 'position log file is "'+v_center_file+'"'
    print, 'fitting quality log file is "'+quality_file+'"'

    fits_read,infile,data,hdr

    num_x=n_elements(data[*,0,0])
    num_y=n_elements(data[0,*,0])
    nc = sxpar(hdr,'NAXIS3')
    cv = sxpar(hdr,'CRVAL3')
    cp = sxpar(hdr,'CRPIX3')
    cd = sxpar(hdr,'CDELT3')
    num_z = (v_range*1000d -cv)/cd+cp-1
    num_z = num_z[sort(num_z)]
    num_z = [floor(num_z[0]),ceil(num_z[1])]
;    print,num_z
    if (num_z[0] gt nc) or (num_z[1] lt 0) then begin
        print,'Velocity out of range.'
            hdr='OUT'
            return
    endif
    num_z = num_z >0 <nc
;    print,num_z
    fwhm = dblarr(num_x,num_y)
    position=fwhm
    quality=fwhm
;    x = findgen(num_z[1]-num_z[0]+1)
;    x = ( findgen(num_z[1]-num_z[0]+1) + num_z[0] + 1 - cp ) * cd + cv
    if cd gt 0 then begin
        x = findgen(num_z[1]-num_z[0] + 1)*cd/1000d + v_range[0]
    endif else begin
        x = findgen(num_z[1]-num_z[0] + 1)*cd/1000d + v_range[1]  
    endelse
;y = reform(data[102,180,num_z[0]:num_z[1]])
;yfit = gaussfit(x,y,coeff)
;plot,x,yfit,linestyle=1
;print,coeff
;oplot,x,y,linestyle=1
    for i=0,num_x-1 do begin
        for j=0,num_y-1 do begin
            y = reform(data[i,j,num_z[0]:num_z[1]])
            yfit=gaussfit(x, y, coeff,chisq=chisquare)
            fwhm[i,j] = 2*SQRT(2*ALOG(2))*coeff[2] ;  (8 ln(2))^(1/2) = 2.355    
            position[i,j] = coeff[1]
            quality[i,j] = chisquare
        endfor
    endfor

    ;FITS HEADER
    ;NaN neednot be rewritten as max is always max
    fits_write,outfile,fwhm,hdr
    fits_write,v_center_file,position,hdr
    fits_write,quality_file,quality,hdr

end
