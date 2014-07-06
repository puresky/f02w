;+
; Project     : STEREO
;
; Name        : WCS_INDEX2MAP
;
; Purpose     : Make an image map from index/data pair using WCS software
;
; Category    : imaging
;
; Syntax      : wcs_index2map,index,data,map

; Inputs      : index - vector of 'index' structures (per
;                       mreadfits/fitshead2struct)

;               data  - 2D or 3D
;
; Outputs     : maparr - 2D or 3D array of corresponding 'map structures'
;
; Keywords    : 
;
; History     : Written, 5 September 2012, Zarro (ADNET)
;-

pro wcs_index2map, index, data, map, _ref_extra=extra

error=0
catch,error
if error ne 0 then begin
 message,err_state(),/info
 catch,/cancel
 return
endif

wcs=fitshead2wcs(index,_extra=extra)
wcs2map,data,wcs,map,_extra=extra
return

end


