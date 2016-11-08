
;this script is used to get the optical depth of spectrum from data cube.
;                     
;Usage:
;    .compile ttau.pro
;    tau,'tr_file', 'tex_file'[, tau_file="tau.fits"][, v_range=[-50,50]][, isotope=isotope]
;Output:
;    file: tau.fits
;          N_CO_taufwhm.fits
;          N_H2_CO_taufwhm.fits

;Formula: 
;   tau = -alog(1-Tmb/(5.289*(JTbg-0.164)))
;   Tex = T0*(alog(1+(Tmb/T0+JTbg)^(-1)))^(-1) 
;   T0 = h nu / k 
;   JTbg = (exp(T0/2.7)-1)^(-1)  
;   JTex = (exp(T0/Tex)-1)^(-1)
;   J(T0,T) = (exp(T0/T)-1)^(-1)  J(T0,Tbg)=0.164, 0.166
;   T0 * JTbg = 0.819 

function J, T0, T
    if n_params() lt 2 then begin
        print, 'Syntax - J, T0, T'
        print, 'temperature in K'
        return, 0
    endif
    J = (exp(T0/T)-1)^(-1)  
    return, J
end

;function tau,T0,Tmb,Tex
;    if n_params() lt 2 then begin
;        print, 'Syntax - tau(T0, Tmb,Tex)'
;        print, 'temperature in K'
;        return, 0
;    endif
;    Tbg = 2.7                          ;   K
;    return, -alog(1-Tmb/(T0*(J(T0,Tex)-J(T0,Tbg))))
;end


pro tau,infile,tex_file=tex_file,outfile=outfile,isotope=isotope, threshold=threshold
    if n_params() lt 1 then begin
        print, 'Syntax - tau, infile, tex_file[, outfile= ][, v_range= ]'
        print, 'velocities in km/s'
        print, 'Formula: '
        print, '   tau = -alog(1-Tmb/(5.289*(JTbg-0.164)))'
        print, '   Tex = T0*(alog(1+(Tmb/T0+JTbg)^(-1)))^(-1) '
        print, '   T0 = h nu / k '
        print, '   JTbg = (exp(T0/2.7)-1)^(-1)  '
        print, '   JTex = (exp(T0/Tex)-1)^(-1)'
        print, '   J(T0,T) = (exp(T0/T)-1)^(-1)  J(T0,Tbg)=0.164, 0.166'
        print, '   T0 * JTbg = 0.819 '
        return
    endif
;    if ~keyword_set(tr_file)  then tr_file='Tpeak.fits'
    if ~keyword_set(tex_file) then tex_file='Tex.fits'
    if ~keyword_set(outfile) then outfile='tau_'+infile
;    if ~keyword_set(v_range) then v_range=[-50,50]
;    if ~keyword_set(isotope) then isotope='13CO'
;    if ~keyword_set(n_co_file) then n_co_file='N_CO_taufwhm.fits'
;    if ~keyword_set(n_h2_file) then n_h2_file='N_H2_taufwhm.fits'
    
;    print, 'velocity range: ',v_range
    print, 'input files are: "', infile,', ', tex_file,'"'
    print, ' output files are: "', outfile,'"'
    
    fits_read, infile, Tmb, hdr
    fits_read, tex_file, Tex, hdrtex

    nu = sxpar(hdr,'RESTFREQ')       ;  0.1102013530000E+12 0.1097821730000E+12
    h = 6.62606957e-34                 ;   J s
    k = 1.3806488e-23                  ;   J/K
    T0 = h * nu / k                    ;   5.289 K, 5.27 K
    Tbg = 2.7                          ;   K
;    Tmb = temporary(Tpeak)
    IF SIZE(Tmb, /N_DIMENSION) EQ 3 THEN BEGIN 
        tau=DBLARR(SIZE(Tmb,/DIMENSION))             
        for i=0, (SIZE(Tmb,/DIMENSION))[2]-1 do tau[*,*,i] = -alog(1-Tmb[*,*,i]/(T0*(J(T0,Tex)-J(T0,Tbg))))
    ENDIF ELSE BEGIN
        tau = -alog(1-Tmb/(T0*(J(T0,Tex)-J(T0,Tbg))))
    ENDELSE
;    case isotope of 
;        '13CO (1-0)': begin
;
;
;
;        end
;        
;        'C18O (1-0)': begin
;
;        end
;
;        else: begin
;            print, isotope, 'has not been implemented ....'
;            print,'Posssible isotopes and transitions are: "13CO (1-0)", "C18O (1-0)", "12CO".'
;            return
;        end
;    endcase
    
   
    
    ;FITS HEADER
    ;NaN
    if keyword_set(threshold) then tau[where(Tmb lt threshold)]=!Values.F_NaN
    sxaddpar,hdr,'BUNIT','1'
    fits_write,outfile, tau, hdr
    
end
