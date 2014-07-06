;+
; Project     : VSO
;
; Name        : SOCK_POST
;
; Purpose     : Wrapper around IDLnetURL object to issue POST request
;
; Category    : utility system sockets
;
; Syntax      : IDL> output=sock_post(url,content)
;
; Inputs      : URL = remote URL file to send content
;               CONTENT = string content to post
;
; Outputs     : OUTPUT = server response
;
; Keywords    : HEADERS = optional string array with headers 
;                         For example: ['Accept: text/xml']
;               FILE = if set, OUTPUT is name of file containing response
;
; History     : 23-November-2011, Zarro (ADNET) - Written
;              
;-

function sock_post,url,content,err=err,file=file,_extra=extra

err='' & output=''

if ~since_version('6.4') then begin
 err='Requires IDL version 6.4 or greater.'
 message,err,/info
 return,output
endif

if is_blank(url) or is_blank(content) then begin
 pr_syntax,'output=sock_post(url,content,headers=headers)'
 return,output
endif

;-- parse out URL

stc=url_parse(url)
if is_blank(stc.host) then begin
 err='Host name missing from URL.'
 message,err,/info
 return,output
endif

ourl=obj_new('idlneturl2',url_host=stc.host,url_scheme='http',url_path=stc.path,$
              _extra=extra,url_password=stc.password,url_username=stc.username,$
               url_query=stc.query)

cdir=curdir()
error=0
catch, error
IF (error ne 0) then begin
 catch,/cancel
 goto,bail
endif

;-- have to send output to writeable temp directory

tdir=get_temp_dir()
sdir=concat_dir(tdir,'temp'+get_rid())

file_mkdir,sdir
cd,sdir

result = ourl->put(content,/buffer,/post)

;-- clean up

bail: cd,cdir
obj_destroy,ourl
sresult=file_search(sdir,'*.*',count=count)
if count eq 1 then result=sresult[0]
if ~file_test(result) then begin
 message,'POST request failed.',/info
 return,''
endif

if keyword_set(file) then return,result 
output=rd_ascii(result)
file_delete,sdir,/quiet,/recursive

return,output 
end  
