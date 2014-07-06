;+
; Project     : HESSI
;
; Name        : SOCK_RESPONSE
;
; Purpose     : return the HTTP header of a remote URL
;
; Category    : utility sockets 
;
; Syntax      : IDL> header=sock_response(url)
;                   
; Inputs      : URL = remote URL 
;
; Outputs     : HEADER = string header
;
; Keywords    : ERR   = string error message
;               HOST_ONLY = only check host name (without full path)
;
; History     : 28-Feb-2012, Zarro (ADNET) - written
;
; Contact     : DZARRO@SOLAR.STANFORD.EDU
;-

function sock_response,url,_ref_extra=extra,host_only=host_only

if is_blank(url) then begin
 pr_syntax,'header=sock_response(url)'
 return,''
endif

if is_ftp(url) then begin
 message,'Not applicable to FTP.',/info
 return,''
endif

durl=url
stc=url_parse(durl)
if keyword_set(host_only) then durl=stc.host

http=obj_new('http',_extra=extra)
http->head,durl,response,_extra=extra
obj_destroy,http

http_content,response,_extra=extra
return,response

end


