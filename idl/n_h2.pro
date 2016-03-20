;Calculating H2 column densities from:
;    1. integrated intensity directly: 12CO
;    2. CO column density: 13CO, C18O
;Usage:
;    .compile n_h2.pro
;    n_h2,"12CO","Int_12CO_-10_40.fits"[, outfile="N_H2_Int_12CO.fits"]
;    n_h2,'13CO','N_CO_Int_13CO_-10_35.fits'
;Output:
;    file: N_H2_Int_12CO_-10_40.fits
;          N_H2_N_CO_Int_13CO_-10_35.fits


pro n_h2,isotope, infile, outfile=outfile, abundance=abundance               ;, quiet=quiet
    if n_params() lt 2 then begin
        print, 'Syntax - n_h2, isotope, infile [, outfile= ][, abundance= ]'
        return
    endif
    if ~keyword_set(outfile) then outfile='N_H2_'+infile
    if ~keyword_set(abundance) then begin
        print, "Abundance is not set. Use default abundance settings:"
        print, "7e5 for 13CO. 7e6 for C18O, 1.8e20 for X"
        ;For more information about CO-to-H2 conversion,
        ;refer to Freking et al. 1982, and Bolatto et al. 2013.
    endif
    
    if file_test(infile) then begin
        fits_read,infile, data, hdr ; Nco in cm^(-2), Wco in K km/s. 
    endif else begin
        print,'file not found: ',infile
        return
    endelse
;    if quiet ne 'quiet' then  outfile = file_write_request(outfile)
    print,'infile is "'+infile+'", outfile is "'+outfile+'"' 

    case isotope of
        '13CO': begin 
            ;2.42 10^14 * 6.157 10^5 = 1.489994 10^20
            ;N = 1.49e20*Wco/(1-exp(-5.289/Tex)) ; cm^(-2)
            ;N_H2/Nco = 7e5                                Nagahama et al. 1998
            ;N_H2/Nco = 5e5                                Dickman 1978
            Nco = temporary(data)
            N_H2 = Nco * 7e5                                 
            prompt = "calculating H2 column density of molecular cloud from 13CO"
            print, prompt
            sxaddhist,prompt,hdr
        end    

        'C18O': begin    
            ;2.24 10^14 * 7 10^6 = 1.568 10^21
            ;2.42 10^14 * 7 10^6 = 1.694 10^21
            ;N = 1.568e21*Wco/(1-exp(-5.27/Tex)) ; cm^(-2)
            ;N_H2/Nco = 7e6                                Warin et al. 1996
            Nco = temporary(data)
            N_H2 = Nco * 7e6
            prompt = "calculating H2 column density of molecular cloud from C18O"
            print, prompt
            sxaddhist,prompt,hdr
        end

        '12CO': begin    
            Wco = temporary(data)
;           X-factor = 1.8e20 cm^(-2) / (K km s^(-1))      Dame et al. 2001, ApJ, 547:792
;                      2.0e20                              Bolatto et al. 2013, ARA&A, 51:207
            N_H2 = 1.8e20 * Wco 
            prompt = "calculating H2 column density of molecular cloud from 12CO using x-factor 1.8e20"
            print,  prompt
            sxaddhist,prompt,hdr
        end

        else: begin
            print, isotope, 'has not been implemented ....'
            print,'Posssible isotopes are: "13CO", "C18O", "12CO".'
            return
        end
    endcase

    
    ;FITS HEADER information should be rewritten
    ;BLANK = ; NaN
    ;DATAMAX = 
    ;DATAMIN = 
    sxaddpar,hdr,'BUNIT', 'cm^(-2)'
    fits_write,outfile,N_H2,hdr

end

