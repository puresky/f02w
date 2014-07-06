;+
; Project     : SOHO_CDS
;
; Name        : PLOT_MAP
;
; Purpose     : Plot an image map
;
; Category    : imaging
;
; Syntax      : plot_map,map
;
; Inputs      : MAP = image structure map created by MAKE_MAP
;               INDEX = optional index (if array of maps) [def=0]
;
; Keywords    : See plot_map_index

; History     : 13 June 2012, Zarro (ADNET)
;               - written as vectorized wrapper to plot_map_index
;               25 February 2013, Zarro (ADNET)
;               - added call to REM_DUP_KEYWORDS to protect
;                against duplicate keyword strings (e.g. LOG vs LOG_SCALE)
;               
;
; Contact     : dzarro@solar.stanford.edu
;-

pro plot_map,map,index,_ref_extra=extra,nearest=nearest

nmaps=n_elements(map)
if ~is_number(index) then index=0 else index= 0 > index < (nmaps-1)

;-- establish plot time for map arrays

if (nmaps gt 1) and valid_map(map) then begin
 if valid_time(nearest) then tnear=anytim2tai(nearest) 
 if valid_map(nearest) then tnear=get_map_time(nearest,/tai)
 if valid_time(tnear) then begin
  diff=abs(tnear-get_map_time(map,/tai))
  chk= where(diff eq min(diff))
  index=chk[0]
  message,'Plotting nearest map at '+map[index].time,/info
 endif 
endif

extra=rem_dup_keywords(extra)

if (nmaps le 1) then plot_map_index,map,_extra=extra else $
 plot_map_index,map[index],_extra=extra

return & end
