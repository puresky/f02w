;+
; Project     : HESSI
;
; Name        : SOCK_LIST
;
; Purpose     : list remote WWW page via sockets
;
; Category    : utility system sockets
;
; Syntax      : IDL> sock_list,url,page
;                  
; Inputs      : URL = URL path to list [e.g. www.cnn.com]
;
; Opt. Outputs: PAGE= captured HTML 
;
; Keywords    : ERR   = string error message
;               USE_NETWORK = set to use IDL network object (via
;               sock_cat)
;               OLD_WAY = force use of older HTTP object
;
; History     : 27-Dec-2001,  D.M. Zarro (EITI/GSFC)  Written
;               26-Dec-2003, Zarro (L-3Com/GSFC) - added FTP capability
;               23-Dec-2005, Zarro (L-3Com/GSFC) - removed COMMON
;               27-Dec-2009, Zarro (ADNET)
;                - piped FTP list thru sock_list2
;               16-Dec-2011, Zarro (ADNET)
;                - use sock_list2 if using a PROXY server
;               13-May-2012, Zarro (ADNET)
;                - added USE_NETWORK
;               13-August-2012, Zarro (ADNET)
;                - added OLD_WAY (for testing purposes only)
;
; Contact     : DZARRO@SOLAR.STANFORD.EDU
;-

pro sock_list,url,page,_ref_extra=extra,use_network=use_network,$
                       old_way=old_way

;-- check if using FTP or PROXY

page=''
use_cat=0b
if is_blank(url) then begin 
 pr_syntax,'sock_list,url,[output]'
 return
endif

use_cat=(since_version('6.4') and ~keyword_set(old_way)) and $
        (have_proxy() or is_ftp(url) or keyword_set(use_network))

if use_cat then sock_cat,url,page,_extra=extra else begin

;-- else use HTTP object

 http=obj_new('http',_extra=extra)
 http->list,url,page,_extra=extra 
 obj_destroy,http

endelse

if n_params(0) eq 1 then print,page

return

end


