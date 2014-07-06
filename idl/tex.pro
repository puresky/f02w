;Calculating excitation temperature 
;Usage:
;    .compile tex.pro
;    tex[,infile="Tpeak.fits",outfile="Tex_Tpeak.fits"]
;Output:
;    file: Tex_Tpeak.fits

;Formula: 
;   Tex = T0*(alog(1+(Tmb/T0+JTbg)^(-1)))^(-1) 
;   T0 = h nu / k 
;   JTbg=(exp(T0/2.7)-1)^(-1) 


pro tex,infile=infile,outfile=outfile
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
    T0 = 5.53213817d   ;12CO(1-0) 
    Tex = T0*(alog(1+T0/(Tmb+0.819)))^(-1) 
    
    
    ;FITS HEADER information should be rewritten
    ;BLANK = ; NaN
    ;DATAMAX = 
    ;DATAMIN = 
    fits_write,outfile,Tex,hdr 

end
