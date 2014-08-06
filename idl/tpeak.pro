;this script is used to get the peak value of spectrum from data cube.
;Usage:
;    .compile tpeak.pro
;    tpeak,"infilename"[, outfile="Tpeak.fits", v_range=[-50,50], velocity_file="Vpeak.fits"]
;Output:
;    file: Tpeak.fits

pro tpeak,infile,outfile=outfile,v_range=v_range, velocity_file=velocity_file
    ;filename='mosaic_U.fits'
    if n_params() lt 1 then begin
        print, 'Syntax - tpeak, infile [, outfile= ][, v_range= ][, velocity_file=velocity_file]'
        print, 'velocities in km/s'
        return
    endif
    if ~keyword_set(outfile) then outfile='Tpeak_'+infile
    if ~keyword_set(v_range) then v_range=[-50,50]
    if ~keyword_set(velocity_file) then velocity_file='Vpeak_'+infile
    
    print, 'search velocity range: ',v_range
    print,'infile is "'+infile+'", outfile is "'+outfile+'", velocity file is "'+velocity_file+'"'
    
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
;    peak = max(data[*,*,num_z[0]:num_z[1]], dimension = 3)
    peak=dblarr(num_x,num_y)
    velocity=peak
    subs=0 
    if cd gt 0 then begin
        x = findgen(num_z[1]-num_z[0] + 1)*cd/1000d + v_range[0]    ; in km/s
    endif else begin
        x = findgen(num_z[1]-num_z[0] + 1)*cd/1000d + v_range[1]    ; in km/s
    endelse


    for i=0,num_x-1 do begin
        for j=0,num_y-1 do begin
;           peak[i,j]=max(data[i,j,v_off[0]:num_z])
            peak[i,j]=max(data[i,j,num_z[0]:num_z[1]], subs)  
            velocity[i,j]=x[subs]
        endfor
    endfor
    
    ;FITS HEADER
    ;NaN neednot be rewritten as max is always max
    fits_write,outfile,peak,hdr
    sxaddpar,hdr,'BUNIT','km/s'
    fits_write,velocity_file,velocity,hdr
    
end
