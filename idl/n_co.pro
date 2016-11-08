;Calculating CO column densities from:
;    1. integrated intensity: moment 0, Wco = total(Tmb[*,*,z_v_0:z_v_1],3,/Nan) * abs(sxpar(hdr,'CDELT3')) / 1000d
;    2. optical depth: Tex * tau * fwhm
;    3. T peak: peak * fwhm
;Usage:
;    .compile n_co.pro
;    n_co, "13CO", 'Wco', "Int_13CO_-10_35.fits"
;    n_co, '13CO', 'tau', 'tau_13CO.fits',  tex_file="Tex.fits", fwhm_file='fwhm_13CO.fits', outfile='Nco_tau_13CO.fits'
;    n_co, '13CO', 'Tpeak', 'Tpeak_13CO.fits', tex_file='Tex.fits', fwhm_file='fwhm_13CO.fits', outfile='Nco_Tpeak_13CO.fits'
;Output:
;    file: Nco_Int_13CO_-10_35.fits
;    
;Formulae:
;    For optical thin spectrum:
;        tau(niu) = (c^2 g_u A_ul/(8pi g_t niu^2)) N_l (1-exp(-h niu/(k Tex)))phi(niu)
;        N_total = 3 k/(8 pi^3 niu miu^2 S)Q(Tex)exp(Eu/(k Tex))Int(Tmb,niu)


pro n_co,isotope, method, infile, tex_file=tex_file, fwhm_file=fwhm_file, tau_file=tau_file, outfile=outfile
    if n_params() lt 2 then begin
        print, 'Syntax - n_h2, isotope, infile [, outfile= ]'
        return
    endif
    ;if ~keyword_set(infile) then infile = 'Wco.fits' 
    if ~keyword_set(outfile) then outfile='Nco_'+infile
    if ~keyword_set(tex_file) then tex_file='Tex.fits'
    if ~keyword_set(fwhm_file) then fwhm_file='FWHM.fits'
    if ~keyword_set(tau_file) then tau_file='tau.fits'
    ;if ~keyword_set(v_off) then v_off=[0,0]
    
    if file_test(infile) then begin
        fits_read,infile, data, hdr ; Tpeak in K, Wco in K km/s, tau in 1. 
    endif else begin
        print,'file not found: ',infile
        return
    endelse
    if file_test(tex_file) then begin
        fits_read,tex_file, Tex, hdrTex ; in K 
    endif else begin
        print,'file not found: ',infile
        return
    endelse

    print,'infile is "'+infile+'", outfile is "'+outfile+'"' 

    
    case method of 
        'Wco': begin
            prompt = 'calculating CO column density of molecular cloud using integrated intensity'
            print, prompt
            sxaddhist,prompt,hdr
            product = temporary(data) ; Wco in K km/s.
       end

        'tau FWHM': begin
            
            prompt = 'calculating CO column density of molecular cloud from optical depth'
            print, prompt
            sxaddhist,prompt,hdr
            tau = temporary(data)  ; tau in 1.

            fits_read, fwhm_file, fwhm, hdrfwhm ; in km/s
            

            product = Tex * tau * fwhm ; in K km/s 

        end
        
        
        'Wco tau':begin
             prompt = 'calculating CO column density of molecular cloud from optical depth'
            print, prompt
            sxaddhist,prompt,hdr
            Wco = temporary(data)  ; tau in 1.

            fits_read, tau_file, tau, tauHdr ; in km/s
                    
            product = tau/(1-exp(-tau)) * Wco 
            cube_subscription = where(tau lt 0.01)
            product[cube_subscription]=Wco[cube_subscription] 
                    
        END

        'Tpeak FWHM': begin

            prompt = 'calculating CO column density of molecular cloud from T peak'
            print, prompt
            sxaddhist,prompt,hdr
            Tpeak = temporary(data)  ; Tpeak in K.

            fits_read, fwhm_file, fwhm, hdrfwhm ; in km/s

            product = Tpeak * fwhm ; in K km/s 

        end
        
        'tau m0': begin
            prompt = 'calculating CO column density of molecular cloud from tau cube'
            print, prompt
            sxaddhist, prompt,Hdr
            tau_m0 = temporary(data) ; 
            ;dv = sxpar(hdr,'CDELT3')
            product = tau_m0*Tex
         END

        else: begin
            print, method, 'has not been implemented ....'
            print,'Posssible methods are: "Wco" for integrated intensity, "tau" for optical depth.'
            return
        end


    endcase 

            case isotope of
                '13CO': begin 
                    print, "                                                 from 13CO"
                    ;Tmb = T_ex*tau
                    ;2.42 10^14 * 6.157 10^5 = 1.489994 10^20
                    Nco = 2.42e14 * product/(1-exp(-5.289/Tex)) ; cm^(-2)
                    ;N[where(finite(N,/nan))] = 0
                end    
        
                'C18O': begin    
                    print, "                                                 from C18O"
                    ;2.24 10^14 * 7 10^6 = 1.568 10^21
                    ;2.42 10^14 * 7 10^6 = 1.694 10^21                      Wrong coefficient? 
                    Nco = 2.42e14 * product/(1-exp(-5.27/Tex))
                end
        
        ;        '12CO': begin    
        ;            print, "calculating the mass of molecular cloud from 12CO"
        ;            ;Tmba12 = temporary(TAa12);/0.5
        ;            ;Wco = Tmba12
        ;            N = 1.8e20*Wco
        ;        end
        
                else: begin
                    print, isotope, 'has not been implemented ....'
                    print,'Posssible isotopes are: "13CO", "C18O".'
                    return
                end
            endcase
 
    
    ;FITS HEADER information should be rewritten
    ;BLANK = ; NaN
    ;DATAMAX = 
    ;DATAMIN = 
    ;if file_test(outfile) eq 1 then begin
    
    sxaddpar,hdr,'BUNIT','cm^(-2)'
    fits_write,outfile,Nco,hdr

end

