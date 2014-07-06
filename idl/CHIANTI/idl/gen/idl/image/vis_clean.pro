;+
; Name: vis_clean
;
; Purpose: This function returns the clean map including residuals using visibilities
;
; Inputs:
;   - vis - visibility bag
;
; Keyword inputs:
;   - niter        max iterations  (default 100)
;   - image_dim    number of pixels in x and y, 1 or 2 element long vector or scalar
;       images are square so the second number isn't used
;   - pixel        pixel size in asec (pixels are square)
;   - gain         clean loop gain factor (default 0.05)
;   - clean_box    clean only these pixels (1D index) in the fov
;   - negative_max if set stop when the absolute maximum is a negative value (default 1)
;   - beam_width   psf beam width (fwhm) in asec
;   - spatial_frequency_weight
;
; Keyword outputs:
;   - iter
;   - dirty_map    two maps in an [image_dim, 2] array (3 dim), original dirty map first, last unscaled dirty map second
;   - clean_beam   the idealized Gaussian PSF
;   - clean_map    the clean components convolved with normalized clean_beam
;   - clean_components structure containing the fluxes of the identified clean components
;         ** Structure <1ee894d8>, 3 tags, length=8, data length=8, refs=1:
;             IXCTR           INT              0
;             IYCTR           INT              0
;             FLUX            FLOAT            0.00000
;	- clean_sources_map the clean components realized as point sources on an fov map (lik)
;	Finally make all of the outputs available as a single structure for convenience
;	  - info_struct = { $
;          image: clean_image, $  ;image returned by vis_clean, clean image + residual map convolved with clean beam
;          iter: iter, $
;          dirty_map: dirty_map[*,*,0], $
;          last_dirty_map: dirty_map[*,*,1], $
;          clean_map: clean_map, $
;          clean_components: clean_components, $
;          clean_sources_map: clean_sources_map, $
;          resid_map: resid_map }

; History:
;	12-feb-2013, Anna Massone and Richard Schwartz, based on hsi_map_clean
;	11-jun-2013, Richard Schwartz, identified error in subtracting gain modified psf from
;	 dirty map. Before only psf had been subtracted!!!
;	17-jul-2013, Richard Schwartz, converted beam_width to pixel units for st_dev on call to
;	 psf_gaussian for self-consistency
;	23-jul-2013, Richard Schwartz, added info_struct for output consolidation
;	
;-


function vis_clean, vis, niter = niter, image_dim = image_dim_in, pixel = pixel, $
  _extra = _extra,  $
  spatial_frequency_weight = spatial_frequency_weight, $
	gain = gain, clean_box = clean_box, negative_max = negative_max, $
	beam_width = beam_width, $
	clean_beam = clean_beam, $
	;Outputs
	iter = iter, dirty_map = dirty_map,$
	clean_map = clean_map, clean_components = clean_components, $
	clean_sources_map = clean_sources_map, $
	resid_map = resid_map, $
	info_struct = info_struct

;clean using vis
;obj->set, _extra=_extra

;image_dim = obj->get(/image_dim)
default, image_dim_in, 65
default, pixel, 1.0
negative_max = fix(fcheck(negative_max,1)) > 0 < 1
default, niter, 100
default, gain, 0.05
image_dim = image_dim_in[0]
image_dim = image_dim / 2 *2 + 1 ;forces odd image_dim
default, beam_width, 4. ;convolving beam sigma in asec
;beam_width_factor=fcheck(beam_width_factor,1.0) > 1.0
default, clean_beam, psf_gaussian( npixel = image_dim[0], st_dev = beam_width / pixel, ndim = 2)

;realize the dirty map and build a psf at the center, use odd numbers of pixels to center the map

vis_bpmap, vis, map = dmap0, bp_fov = image_dim[0] * pixel, pixel = pixel, /data_only, $
  UNIFORM_WEIGHTING = uniform_weighting, spatial_freqency_weight = spatial_frequency_weight

default, clean_box, where( abs( dmap0)+1) ;every pixel is the default
component = {clean_comp,  ixctr: 0, iyctr: 0, flux:0.0}
clean_components = replicate( component, niter) ;positions in pixel units from center

;Now we can begin a clean loop
;Find the max of the dirty map, save the component, subtract the psf at the peak from dirty
iter = 0
clean_map = dmap0 * 0.0
dmap = dmap0
test = 1
while  test do begin
	
	zflux = max(  ( negative_max ? abs( dmap[clean_box] ) : dmap[ clean_box ] ), iz  )

	if dmap[ clean_box[ iz ] ] lt 0 then begin   ;;;;;; only enters if negative_max is set
		test = 0
		break ;leave while loop
  endif
	
	psf = vis_psf( vis, clean_box[iz], pixel = pixel, psf00 = psf00, image_dim = image_dim )
	default, pkpsf, max( psf )
	flux = zflux * gain / pkpsf
	
	dmap[clean_box] -= psf *flux
	izdm = get_ij( iz, image_dim ) ;convert 1d index to 2d form

	clean_components[ iter ] = { clean_comp, izdm[0], izdm[1], flux }
	clean_map[ iz ] += flux
	iter++
	test = iter lt niter
	endwhile



;Convolve with a clean beam
clean_sources_map = clean_map
clean_map = convol( clean_map, clean_beam, /norm, /center, /edge_zero) / pixel^2 ;add pixel^2 to make it per arcsecond^2

resid_map = dmap / total(clean_beam) / pixel^2   
               ;;;; just as in hsi_map_clean normalize the residuals just like the clean image
               ;;;; 11 feb 2013, N.B. in hsi_map_clean the normalization factor, nn, is used on
               ;;;; both residual map and clean map because they do not use convol() as here with /norm
               ;;;; but instead multiply the clean sources by the unnormalized cbm
dirty_map = [[[dmap0]], [[dmap]]] ;original dirty map first, last unscaled dirty map second
;clean_image=clean_map + resid_map
clean_image = clean_map + convol( resid_map, clean_beam, /norm, /center, /edge_zero)
info_struct = { $
          image: clean_image, $
          iter: iter, $
          dirty_map: dirty_map[*,*,0], $
          last_dirty_map: dirty_map[*,*,1], $
          clean_map: clean_map, $
          clean_components: clean_components, $
          clean_sources_map: clean_sources_map, $
          resid_map: resid_map }
  
return, clean_image
end