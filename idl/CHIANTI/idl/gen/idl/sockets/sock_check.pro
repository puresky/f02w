;+
; Project     : VSO
;
; Name        : SOCK_CHECK
;
; Purpose     : Check if URL file exists by sending a GET request for it
;
; Category    : utility system sockets
;
; Syntax      : IDL> chk=sock_check(url)
;
; Inputs      : URL = remote URL file name to check
;
; Outputs     : CHK = 1 or 0 if exists or not
;
; Keywords    : RESPONSE = server response
;
; History     : 10-March-2010, Zarro (ADNET) - Written
;               19-June-2013, Zarro - Reinstated
;-

function sock_check,url,response=response,_ref_extra=extra

response=''
if is_blank(url) then return,0b
if n_elements(url) gt 1 then begin
 message,'Input URL must be scalar.',/info
 return,0b
endif
response=sock_header(url,_extra=extra)
return,is_string(response)

end
