;+
;  :Description:
;    Calculating excitation temperature 
;  :Syntax:
;    tex[,infile="Tpeak.fits",outfile="Tex_Tpeak.fits"]
;Formula: 
;   Tex = T0*(alog(1+(Tmb/T0+JTbg)^(-1)))^(-1) 
;   T0 = h nu / k 
;   JTbg=(exp(T0/2.7)-1)^(-1) 
;    Input:
;    Output:
;      file     : Tex_Tpeak.fits
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
;  :Tags:
;    Tex
;  :Author: puresky
;  :History:
;    V0     2015-01-23        
;    V0.1   2015-09-20 
;    V1.0 
;
;-
;Comment Tags:
;    http://www.exelisvis.com/docs/IDLdoc_Comment_Tags.html
;
;


pro tex,infile,outfile=outfile
    if n_params() lt 1 then begin
        print, 'Syntax - tex[, infile= , outfile= ]'
        return
    endif
    if ~keyword_set(infile) then infile = 'Tpeak.fits' 
    if ~keyword_set(outfile) then outfile='Tex_'+infile
    ;if ~keyword_set(v_off) then v_off=[0,0]
    
    print,'infile is "'+infile+'", outfile is "'+outfile+'"' 
    
    fits_read,infile,Tpeak,hdr 
    
    ;Tex derived from 12CO data
    ;T should have been calibrated beam efficience
    ;i.e. Tmb = Tpeak
    ;   T0 * JTbg = 0.819 
    Tmb = temporary(Tpeak)  
    T0 = 5.53213817d   ;12CO(1-0)  h nu / k = 6.6261*115.3/1.3807
    Tex = T0*(alog(1+T0/(Tmb+0.819)))^(-1) 
    
    
    ;FITS HEADER information should be rewritten
    ;BLANK = ; NaN
    ;DATAMAX = 
    ;DATAMIN = 
    fits_write,outfile,Tex,hdr 

end
