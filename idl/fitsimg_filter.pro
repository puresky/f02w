;-FileName fitsimg_filter.pro
;-Usage:
;-.compile fitsimg_filter.pro
;-fitsimg_filter,"dataname", e.g., fitsimg_filter,"115ug.fits"

pro fitsimg_filter,file
    fits_read,file,im,hd
    sxaddpar, hd, 'CTYPE1', 'RA---SFL'
    sxaddpar, hd, 'CTYPE2', 'DEC--SFL'
    im2=im
    hd2=hd
    idx=where(im2 lt -30.)
    im2[idx]=!Values.F_NaN
    fits_write,file+'.FIT',im2,hd2
end
