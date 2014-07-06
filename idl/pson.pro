;-----------------------------------------------------------------
; pson.pro
;
; written by Andreas Reigber
;------------------------------------------------------------------
; switch over to postscript device, go back to X with 'psoff'
; 
; KEYWORDS:
; /HOCH  : Portrait not landscape
; /COLO  : Generate color postscript
; /ENCA  : Generate EPS
;------------------------------------------------------------------
; This software has been released under the terms of the GNU Public
; license. See http://www.gnu.org/copyleft/gpl.html for details.
;------------------------------------------------------------------

pro pson,filename=filename,HOCHKANT=hochkant,COLOR=color,ENCAPSULATED=encapsulated
	set_plot,"ps"
	if keyword_set(filename) then begin
		device,filename=filename,/landscape
	endif else begin
		device,filename="idlplot.ps",/landscape
	endelse
	if keyword_set(hochkant) then device,/portrait
	if keyword_set(color) then device,/color
	if keyword_set(encapsulated) then device,/encapsulated
end
