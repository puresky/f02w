;+
;  :Description:
;      This script is used to get the peak value of spectrum from data cube.
;  :Syntax:
;      .compile tpeak.pro
;      tpeak,"infilename"[, outfile="Tpeak.fits", v_range=[-50,50], velocity_file="Vpeak.fits"]
    
;    Input:
;    Output:
;      files     : Tpeak.fits
;      variables :
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
;    V0     2015-01-04        Maximum of given range.
;    V0.1   2014-09-20 
;    V1.0 
;
;-
;Comment Tags:
;    http://www.exelisvis.com/docs/IDLdoc_Comment_Tags.html

pro tpeak,infile,threshold,outfile=outfile,v_range=v_range, velocity_file=velocity_file, mask_data=mask_data
    ;filename='mosaic_U.fits'
    if n_params() lt 2 then begin
        print, 'Syntax - tpeak, infile [, outfile= ][, v_range= ][, velocity_file=velocity_file]'
        print, 'velocities in km/s'
        return
    endif
;    if ~keyword_set(threshold) then threshold=0
    if ~keyword_set(outfile) then outfile='Tpeak_'+infile
    if ~keyword_set(v_range) then v_range=[-50,50]
    if ~keyword_set(velocity_file) then velocity_file='Vpeak_'+infile
    if ~keyword_set(mask_data) then print,"Hint:No NaN data?"
    
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
;    peak=dblarr(num_x,num_y)       ;total(data[*,*,num_z[0]:num_z[1]],3)
    peak=total(data[*,*,num_z[0]:num_z[1]],3)/sqrt(num_z[1]-num_z[0]+1)
    velocity=dblarr(num_x,num_y,/nozero)
    velocity[*,*]=!Values.F_NaN             ; undefined


    if cd gt 0 then begin
        axis_z = findgen(num_z[1]-num_z[0] + 1)*cd/1000d + v_range[0]    ; in km/s
    endif else begin
        axis_z = findgen(num_z[1]-num_z[0] + 1)*cd/1000d + v_range[1]    ; in km/s
    endelse

    for i=0,num_x-1 do begin
        for j=0,num_y-1 do begin
            n_channel=sort(data[i,j,num_z[0]:num_z[1]])+num_z[0]
            for k=num_z[1]-num_z[0],0,-1 do begin
                if data[i,j,n_channel[k]] lt threshold then break
                if total(data[i,j,(n_channel[k]-2):(n_channel[k]+2)] ge threshold) eq 5 then begin 
                    peak[i,j]=data[i,j,n_channel[k]]   ;                   peak[i,j]=max(data[i,j,num_z[0]:num_z[1]],subs)
                    velocity[i,j]=axis_z[n_channel[k]-num_z[0]]
                    break
                endif
             endfor
        endfor
    endfor
    
    ;NaN regions:
    if keyword_set(mask_data) then begin 
        peak[where(mask_data eq 0)]=!Values.F_NaN
        velocity[where(mask_data eq 0)]=!Values.F_NaN     
    endif

    ;FITS HEADER
    fits_write,outfile,peak,hdr
    sxaddpar,hdr,'BUNIT','km/s'
    fits_write,velocity_file,velocity,hdr
    
end
