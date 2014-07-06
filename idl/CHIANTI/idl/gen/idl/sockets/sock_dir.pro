;+
; Project     : VSO
;
; Name        : SOCK_DIR
;
; Purpose     : Perform directory listing of files at a URL 
;
; Category    : utility system sockets
;
; Syntax      : IDL> sock_dir,url,out_list
;
; Inputs      : URL = remote URL directory to list
;
; Outputs     : OUT_LIST = optional output variable to store list
;
; History     : 27-Dec-2009, Zarro (ADNET) - Written
;               16-Jul-2013, Zarro (ADNET) - Passed keywords thru to pertinent subroutines
;-

pro sock_dir,url,out_list,_ref_extra=extra

if ~is_string(url) then begin
 pr_syntax,'sock_dir,url,out_list'
 return
endif

if is_ftp(url) then sock_dir_ftp,url,out_list,_extra=extra else $
 sock_dir_http,url,out_list,_extra=extra

return & end
