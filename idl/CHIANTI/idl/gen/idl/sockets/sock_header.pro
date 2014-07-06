;+
; Project     : VSO
;
; Name        : SOCK_HEADER
;
; Purpose     : Wrapper around IDLnetURL object to send HEAD request
;
; Category    : utility system sockets
;
; Syntax      : IDL> header=sock_header(url)
;
; Inputs      : URL = remote URL file name to check
;
; Outputs     : HEADER = response header 
;
; Keywords    : CODE = response code
;             : HOST_ONLY = only check host (not full path)
;             : SIZE = number of bytes in return content
;
; History     : 24-Aug-2011, Zarro (ADNET) - Written
;                6-Feb-2013, Zarro (ADNET)
;               - added call to new HTTP_CONTENT function
;               19-Jun-2013, Zarro (ADNET) - renamed to sock_header
;-

function sock_header_callback, status, progress, data  

;-- since we only need the response header, we just read
;   the first set of bytes and return

if (progress[0] eq 1) then begin
 if ptr_valid(data) then begin
  ourl=(*data).ourl
  if obj_valid(ourl) then begin
   ourl->GetProperty, RESPONSE_CODE=rspCode, $
         RESPONSE_HEADER=rspHdr, RESPONSE_FILENAME=rspFn
   if (rspcode eq 0) then return,1
   *((*data).rsphdr)=rsphdr
   (*data).rspcode=rspcode
   (*data).rspfn=rspfn
   return,0
  endif
 endif
endif
return,0

end

;-----------------------------------------------------------------------------
  
function sock_header,url,err=err,verbose=verbose,passive=passive,$
                       _ref_extra=extra,host_only=host_only

err='' 

if ~since_version('6.4') then begin
 err='Requires IDL version 6.4 or greater.'
 message,err,/info
 return,''
endif

if is_blank(url) then begin
 pr_syntax,'header=sock_header(url)'
 return,''
endif

stc=url_parse(url)
url_path=stc.path
if is_blank(stc.path) then url_path='/'

if stc.scheme eq 'ftp' then message,'FTP not supported. Use at own risk.',/info
 
user='anonymous'
pass='nobody'
if is_string(stc.username) then user=stc.username
if is_string(stc.password) then pass=stc.password
if is_string(username) then user=username
if is_string(password) then pass=password
url_scheme=stc.scheme

;-- create pointer to pass to callback function 

callback_function='sock_header_callback'
if is_number(passive) then passive= (0 > passive < 1) else passive=1
if is_string(stc.query) then url_path=url_path+'?'+stc.query
if keyword_set(host_only) then url_path='/'

ourl=obj_new('idlneturl2',callback_function=callback_function,url_scheme=url_scheme,$
               url_host=stc.host,url_username=user,url_password=pass,verbose=verbose,$
               url_path=url_path,_extra=extra,ftp_connection_mode=1-passive)

callback_data=ptr_new({ourl:ourl,rspcode:0l,rsphdr:ptr_new(/all), rspfn:''})
ourl->setproperty,callback_data=callback_data,verbose=0

;-- have to use a catch since canceling the callback triggers it

error=0
catch, error
IF (error ne 0) then begin
 catch,/cancel
 message,/reset
 goto, bail
endif

result = oUrl->Get(/buffer)  

bail:

;-- retrieve response values from pointer since network object resets
;   them

rsphdr=''
if ptr_valid(callback_data) then begin
 code=(*callback_data).rspcode
 if code gt 0 then begin
  rsphdr=*((*callback_data).rsphdr)
  rsphdr=byte2str(byte(rsphdr),newline=13,skip=2)
 endif
 heap_free,callback_data
endif 

http_content,rsphdr,_extra=extra
obj_destroy,ourl

return,rsphdr & end  
