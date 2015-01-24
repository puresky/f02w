
;+
;  :Description:
;    To generate a customed fits file.
;  :Syntax:
;    
;    Input:
;    Output:
;      file     : 
;      variable :
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
;    V0     2015-09-20        
;    V0.1   2015-09-20 
;    V1.0 
;
;-
;Comment Tags:
;    http://www.exelisvis.com/docs/IDLdoc_Comment_Tags.html
;
;









pro make_grids,Xc,Yc,WCS=WCS,Radius=R
;generate a template for regirding

    if n_params() lt 2 then begin
    	print, "Syntax - Make_Grids, Xc, Yc, WCS='Galactic', Radius=45"
    	print, " Xc,Yc - The center of observation region."
            print, "   WCS - The World Coordinate System."
            print, "Radius - The radius of region, in pixels."
    	return
    endif
    
    mkhdr,hdr,1,[1,1]
    ;fits_read,'test.fits',dat,hdr,/header_only
    
    ;position
    sxaddpar,hdr,'NAXIS1',91		;dimension
    sxaddpar,hdr,'NAXIS2',91
    ;sxaddpar,hdr,'CTYPE1','RA---GLS    '	;projection type,'GLON-GLS    '
    sxaddpar,hdr,'CTYPE1','GLON-GLS    '
    sxaddpar,hdr,'CRVAL1',x			;coordinate of reference pixel
    sxaddpar,hdr,'CDELT1',-30d/3600		;pixel size
    sxaddpar,hdr,'CRPIX1',46		;reference pixel
    sxaddpar,hdr,'CROTA1',0
    ;sxaddpar,hdr,'CTYPE2','DEC--GLS    '
    sxaddpar,hdr,'CTYPE2','GLAT-GLS    '
    sxaddpar,hdr,'CRVAL2',y
    sxaddpar,hdr,'CDELT2',30d/3600
    sxaddpar,hdr,'CRPIX2',46
    sxaddpar,hdr,'CROTA2',0
    
    ;velocity
    ;sxaddpar,hdr,'CTYPE3','VELOCITY    '
    ;sxaddpar,hdr,'NAXIS3',16255
    ;sxaddpar,hdr,'CRPIX3',8128
    ;sxaddpar,hdr,'CDELT3',159
    ;sxaddpar,hdr,'CRVAL3',1000
    
    ;others
    sxaddpar,hdr,'EQUINOX',2000
    ;sxaddpar,hdr,'RA',x
    ;sxaddpar,hdr,'DEC',y
    sxaddpar,hdr,'OBJECT','DLHSURVEY'
    
    dat=bytarr(sxpar(hdr,'NAXIS1'),sxpar(hdr,'NAXIS2'))
    fits_write,'template.fits',dat,hdr
    print,"Template for regriding at "+string(x)+string(y)+" has been generated successfully!"
end
