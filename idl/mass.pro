;Calculate mass of the object:
;    1. column density: the cloud observed in CO(1-0) emissions.
;    2. luminosity

;calculating mass from column density N
;formula:
;    mass = total(N)*(pixel_size*distance)^2*M_molecular_mean
;    mass_in_solar_mass
;         = total(N)*(pixel_size_in_arcsec*distance_in_pc*AU)^2*M_molecular_mean/M_sun
;notes:
;    beam sizes may be different from pixel sizes.
;    N in cm^(-2)
;constants:
;    source: http://physics.nist.gov/constants
;        
;        1 amu = 1.6605402 10^(-24) g ; (unified) atomic mass unit
;    source: IAU define
;        1 AU = 1.49597870700 10^11 m ; astronomical unit
;    1 solar mass = 1.9891×10^30 kg
;    
;    derived: 
;        1 pc = 1 AU / 1 " = 3.0856775814913676 10^18 cm;3.08568025e18
;        206265 = 3600 / !dtor
;        mu = 2.83 ; mean molecular weight 
;Telescope Parameters: These should be read from FITS Header
;    PMODLH:
;        dv_12CO = 0.159 ; km/s
;        dv_13CO = 0.167 ; km/s
;        dv_C18O = 0.167 ; km/s
;        beam_efficience = 0.5  

function mass, N, distance, cellsize=cellsize
    if n_params() lt 2 then begin
        print, 'Syntax - mass(N, distance)';, infile [, outfile= ][, = ]'
        return,0
    endif
    ;if ~keyword_set(outfile) then outfile='tpeak_'+infile
    ;if ~keyword_set(v_off) then v_off=[0,0]
    if ~keyword_set(cellsize) then cellsize = 30d ; in arcsec

    print, 'calculating molecular cloud mass from H2 column density'    
    h2mass= total(N(where(finite(N))))*((cellsize*distance*1.49597870700e13))^2*(2.8*1.6605e-24)/(1.9891e33) ; in solar mass
    return,h2mass
end

   
    

