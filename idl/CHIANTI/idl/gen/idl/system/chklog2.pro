;+
; Project     : VSO
;
; Name        : CHKLOG2
;
; Purpose     : Wrapper around CHKLOG that supports case-insensitive matches
;
; Category    : system utility
;
; Syntax      : IDL> value=chklog(envar)
;
; Inputs      : ENVAR = environment variable name (string scalar or array)
;
; Keywords:   : FOLD_CASE = set to ignore case
; Outputs     : VAR = variable value
;
; History     : 17-Aug-2012, Zarro (ADNET) - written
;
; Contact     : dzarro@solar.stanford.edu
;-


function chklog2,var,os,_ref_extra=extra,fold_case=fold_case

nvar=n_elements(var)
fold=keyword_set(fold_case)
if nvar eq 0 then return,''
output=strarr(nvar)
for i=0,nvar-1 do begin
 sval=chklog(var[i],os,_extra=extra)
 if fold then begin
  if (sval eq '') or (sval eq var[i]) then begin
   uval=strupcase(var[i])
   lval=strlowcase(var[i])
   sval=chklog(uval,os,_extra=extra)
   if (sval eq '') or (sval eq uval) then sval=chklog(lval,os,_extra=extra)
  endif
 endif
 output[i]=sval
endfor

if nvar eq 1 then output=output[0]
return,output
end
