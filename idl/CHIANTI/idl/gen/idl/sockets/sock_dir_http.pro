;+
; Project     : VSO
;
; Name        : SOCK_DIR_HTTP
;
; Purpose     : Wrapper around SOCK_FIND to perform
;               directory listing via HTTP
;
; Category    : utility system sockets
;
; Syntax      : IDL> sock_dir_http,url,out_list
;
; Inputs      : URL = remote URL directory name to list
;
; Outputs     : OUT_LIST = output variable to store list
;
; History     : 27-Dec-2009, Zarro (ADNET) - Written
;               16-Jul-2013, Zarro (ADNET) - Passed thru to sock_find
;-

pro sock_dir_http,url,out_list,_ref_extra=extra

if ~is_string(url) then begin
 pr_syntax,'sock_dir_http,url,out_list'
 return
endif

out_list=sock_find(url+'/',_extra=extra)

return & end  
