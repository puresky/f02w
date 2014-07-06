;+
; Project     : HESSI
;
; Name        : HTTP__DEFINE
;
; Purpose     : Define a HTTP class
;
; Explanation : defines a HTTP class to open URL's and download (GET)
;               files. Example:
;
;               a=obj_new('http')                  ; create a HTTP object
;               a->open,'orpheus.nascom.nasa.gov'  ; open a URL socket 
;               a->head,'~zarro/dmz.html'          ; view file info
;               a->list,'~zarro/dmz.html'          ; list text file from server
;               a->copy,'~zarro/dmz.html'          ; copy file
;               a->close                           ; close socket
;
;               If using a proxy server, then set environmental 
;               http_proxy, e.g:
;
;               setenv,'http_proxy=orpheus.nascom.nasa.gov:8080'
;                
;               or
;
;               a->hset,proxy='orpheus.nascom.nasa.gov:8080'
;
; Category    : objects sockets 
;               
; Syntax      : IDL> a=obj_new('http')
;
; History     : Written, 6 June 2001, D. Zarro (EITI/GSFC)
;               Modified, 31 December 2002, Zarro (EER/GSFC) - made PORT
;               a property
;               Modified, 5 January 2003, Zarro (EER/GSFC) - improved
;               proxy support
;               13-Jan-2002, Zarro (EER/GSFC) - added cache support
;               and /reset
;               26-Jan-2003, Zarro (EER/GSFC) - added URL path check
;               4-May-2003, Zarro (EER/GSFC) - added POST support & switched
;               default to HTTP/1.1
;               20-Sep-2003, Zarro (GSI/GSFC) - added RANGE and CACHE-CONTROL directives
;               30-Sep-2003, Zarro (GSI/GSFC) - added READ_TIMEOUT property to control
;               proxy timeouts
;               28-Jun-2004, Kim Tolbert - set self.unit=0 after closing to avoid conflicts
;               15-Apr-2005, Zarro (L-3Com/GSFC) - added call to HTML_DECHUNK
;               20-Apr-2005, Zarro (L-3Com/GSFC) - allowed PORT to be set from URL
;               11-Sep-2005, Zarro (L-3Com/GSFC) - added COPY_FILE keyword to ::COPY
;               10-Nov-2005, Hourcle (L-3Com/GSFC) - added support for adding headers
;               11-Nov-2005, Zarro (L-3Com/GSFC) - changed from using pointer 
;                to keyword for extra header
;               1-Dec-2005, Zarro (L-3Com/GSFC) - minor bug fixes with
;                closing and validating servers
;               16-Dec-2005, Zarro (L-3Com/GSFC) - fixed case where
;                socket was not closing after a request
;               26-Dec-2005, Zarro (L-3Com/GSFC) - added more
;                diagnostic output to /VERBOSE
;               16-Nov-2006, Zarro (ADNET/GSFC) - sped up copy
;                by not checking remote file size twice.
;               1-March-07, Zarro (ADNET) - added call to better parse_url
;                function in corresponding method.
;               6-Mar-2007, SVH Haugan (ITA) - copy now passes info to 
;                self->make, to allow additional headers
;               21-July-2007, Zarro (ADNET) 
;                - changed parse_url function to url_parse to avoid 
;                  naming conflict with 6.4
;               3-Dec-2007, Zarro (ADNET)
;                - support copying files with unknown sizes
;               4-Jan-2008, Zarro (ADNET)
;                - added LOCAL_FILE keyword (synonym for COPY_FILE)
;               14-Sept-2009, Zarro (ADNET)
;                - added check for content-disposition (thanks, JoeH)
;                  and improved HTTP error code checking (but can be
;                  better)
;               24-Oct-2009, Zarro (ADNET)
;                - improved checking for remote file size by using GET
;                  instead of HEAD, which gets confused by redirects.
;               26-March-2010, Zarro (ADNET)
;                - fixed bug with URL not being parsed correctly when 
;                  server/host name not included.
;               27-May-2010, Kim.
;                - don't print clobber or same size messages if
;                  verbose is set
;               20-Sep-2010, Zarro (ADNET)
;                - added check for Redirects (not bullet-proof yet)
;               17-Nov-2010, Zarro (ADNET)
;                - added username/password support for proxy server
;               19-Aug-2011, Zarro (ADNET)
;                - improved PROXY support; added check for $no_proxy
;                9-Dec-2011, Zarro (ADNET)
;                - added check for proxy server during init
;                - fixed bug where proxy port wasn't appended
;                  to proxy host name 
;                - disabled no-cache directive as it was confusing
;                  proxy servers
;                16-Jan-2012, Zarro (ADNET)
;                - added support for entering protocol as number or
;                  string
;                19-Feb-2012, Zarro (ADNET) 
;                - changed message,/cont to message,/info because
;                  /cont was setting !error_state
;                26-Mar-2012, Zarro (ADNET)
;                - reworked ::LIST and ::COPY to better handle
;                  redirects
;                - added byte-order properties to better handle FITS
;                  files
;                25-May-2012, Zarro (ADNET)
;                - deprecated COPY_FILE keyword
;                15-July-2012, Zarro (ADNET)
;                - added support for $USER_AGENT environment variable
;                15-August-2012, Zarro (ADNET)
;                - more proxy tweaking and improved checking for
;                  existing files
;                7-September-2012, Zarro (ADNET)
;                - moved download progress messages to rdwrt_buff
;                - added more stringent check for valid HTTP status
;                  code 200
;                14-October-2012, Zarro (ADNET)
;                - added byte range support.
;                  [e.g., ranges='200-300' will download bytes 200-300
;                  of file]
;                14-November-2012, Zarro (ADNET)
;                - added NO_OPEN and NO_SEND keywords in REQUEST
;                  method (for testing only)
;                9-Dec-2012, Zarro (ADNET)
;                - changed HEAD method to read formatted text rather
;                  that unformatted bytes (seems faster) 
;                - retired unused properties/keywords (rawio,secure)
;                15-Dec-2012, Zarro (ADNET)
;                - improved error checking for connect/read timeouts
;                  on slow servers and networks
;                6-February-2013, Zarro (ADNET)
;                - made PROTOCOL property a float (removed HTTP/ string portion)
;                1-Mar-2013, Zarro (ADNET)
;                - replaced rdwrt_buff with rd_socket, which handles
;                  chunked-encoding
;                18-Apr-2013, Zarro (ADNET)
;                - removed redundant REDIRECT check from POST method 
;                25-May-2013, Zarro (ADNET)
;                - added file_poll_input check before reading socket
;                  [avoids socket hangs]
;                - restored NO-CACHE capability [CACHE=1 by default]
;                - skip REDIRECT check if URL contains a query
;                  [which implies GET or POST]
;                22-June-2013, Zarro (ADNET)
;                - removed default READ_ and CONNECT_TIMEOUT
;                  keywords; leave these for user to set.
;                26-July-2013, Zarro (ADNET)
;                -  URL_PARSE method now calls URL_PARSE function which
;                   handles username/password
;
; Contact     : dzarro@solar.stanford.edu
;-

;-- init HTTP socket

function http::init,err=err,_ref_extra=extra

err=''

if ~allow_sockets(err=err,_extra=extra) then return,0b

;-- initialize USER-AGENT string 

sagent='IDL/'+!version.release+' '+!version.os+'/'+!version.arch
chk1=chklog('USER_AGENT')
chk2=chklog('user_agent')
if is_string(chk1) then sagent=chk1 else if is_string(chk2) then sagent=chk2

;-- check for PROXY server

self->set_proxy

self->hset,buffsize=1024l,protocol=1.1,port=80,_extra=extra,$
      user_agent=sagent,read_timeout=-1,connect_timeout=-1,cache=1

return,1

end
;--------------------------------------------------------------------------

;-- parse URL input

pro http::url_parse,url,host,file,port=port,query=query

query=''
file=''
port=80
host='' 
if is_blank(url) then return
res=url_parse(url)
host=res.host
file=res.path
query=res.query
if is_string(query) then file=file+'?'+query
port=fix(res.port)

return & end

;---------------------------------------------------------------------------

pro http::cleanup

self->close

return & end

;--------------------------------------------------------------------------

function http::hget,_ref_extra=extra

return,self->getprop(_extra=extra)

end

;---------------------------------------------------------------------------
;-- send request for specified type [def='text']

pro http::send_request,url,type=type,err=err,request=request,$
                     _ref_extra=extra,verbose=verbose,no_send=no_send

err=''
request=''

verbose=keyword_set(verbose)
if verbose then message,'Requesting '+url,/info

self->open,url,err=err,_extra=extra

if is_string(err) then begin
 self->close & return
endif

self->make,request,_extra=extra
if keyword_set(no_send) then return
self->send,request,err=err,_extra=extra

return & end

;--------------------------------------------------------------------------
;-- create request string

pro http::make,request,head=head,$
           no_close=no_close,post=post,form=form,$
           encode=encode,xml=xml,ranges=ranges,info=info,debug=debug

arg=self->hget(/file)
server=self->hget(/server)
port=self->hget(/port)

have_delim=stregex(arg,'^/',/bool)
if ~have_delim then arg='/'+arg

if self->use_proxy() then begin
 tserver=server+':'+trim(port)
 arg='http://'+tserver+arg
endif

;-- assume GET request

cmd='GET '
method='get'
if keyword_set(head) then begin cmd='HEAD ' & method='head' & endif
if is_string(post) then begin cmd='POST ' & method='post' & endif
if keyword_set(debug) then help,method

cmd=cmd+arg

;-- set protocol

protocol=self->hget(/protocol)
if protocol eq 0 then protocol=1.1
hprotocol='HTTP/'+trim(protocol,'(f4.1)')
cmd=cmd+' '+hprotocol

;-- if using HTTP/1.1, need to send host/port information

header=''
port=self->hget(/port)
port=trim(port)
host='Host: '+server+':'+port
if protocol eq 1.1 then header=[header,host]

;-- send user-agent in header

sagent=self->hget(/user_agent)
if is_string(sagent) then begin
 user_agent='User-Agent: '+sagent
 header=[header,user_agent]
endif

;-- append extra header info if included

if is_string(info) then header=[header,strarrcompress(info)]

cache=self->hget(/cache)
if ~cache then begin
 header=[header,'Cache-Control: no-cache','Pragma: no-cache','Expires: 0']
endif

;-- if this is a POST request, then we compute content length
;   if this is a FORM then inform server of content type

if method eq 'post' then begin
 if keyword_set(xml) then header=[header,'Content-type: text/xml'] else $
  if keyword_set(form) then header=[header,'Content-type: application/x-www-form-urlencoded']
 length=strlen(post)
 header=[header,'Content-length: '+strtrim(length,2)] 
endif 

;-- check if partial ranges requested

if (method eq 'get') and is_string(ranges) then header=[header,'Range: bytes='+strtrim(ranges,2)]

;-- if using HTTP/1.0, and want to keep connection open, send keep-alive header

if (protocol eq 1.0) then begin
 if keyword_set(no_close) then header=[header,'Connection: keep-alive'] else header=[header,'Connection: close']
endif

if (protocol eq 1.1) and ~keyword_set(no_close) then header=[header,'Connection: Close']

nhead=n_elements(header)
request=[cmd,header[1:(nhead-1)],'']

if method eq 'post' then begin
 if keyword_set(encode) then request=[request,url_encode(post)] else $
  request=[request,post]
endif

;-- if this is a HEAD request, then we append extra space

;if method eq 'head' then request=[request,'']

return
end

;---------------------------------------------------------------------------
;-- set method

pro http::hset,file=file,server=server,connect_timeout=connect_timeout,port=port,$
               buffsize=buffsize,protocol=protocol,user_agent=user_agent,$
               proxy=proxy,read_timeout=read_timeout,$
               cache=cache,swap_endian=swap_endian,$
               swap_if_little_endian=swap_if_little_endian,_extra=extra


if is_number(connect_timeout) then self.connect_timeout=connect_timeout
if is_number(read_timeout) then self.read_timeout=read_timeout
if is_string(file) then self.file=strtrim(file,2)
if is_string(server) then begin
 self->url_parse,server,host
 if is_string(host) then self.server=host
endif

if is_number(buffsize) then self.buffsize=abs(long(buffsize)) > 1l
if is_number(protocol) then self.protocol=float(protocol)
if is_string(user_agent,/blank) then self.user_agent=strtrim(user_agent,2)
if is_number(port) then self.port=fix(port)

if is_string(proxy,/blank) then begin
 if strtrim(proxy,2) ne ''  then begin
  self->url_parse,proxy,host,port=port
  if is_string(host) then self.proxy_host=host 
  if is_number(port) then self.proxy_port=fix(port) else self.proxy_port=80
 endif else begin
  self.proxy_host='' & self.proxy_port=0
 endelse
endif

if is_number(cache) then self.cache= 0b > cache < 1b
if is_number(swap_endian) then self.swap_endian= 0b > swap_endian < 1b
if is_number(swap_if_little_endian) then self.swap_if_little_endian= 0b > swap_if_little_endian < 1b

return & end

;---------------------------------------------------------------------------

pro http::help

message,'current server - '+self->hget(/server),/info

if self->use_proxy() then begin
 message,'proxy server - '+self->hget(/proxy_host),/info
 message,'proxy port - '+trim(self->hget(/proxy_port)),/info
endif

if ~self->is_socket_open() then begin
 message,'No socket open',/info
 return
endif


return & end

;--------------------------------------------------------------------------
;-- set proxy parameters from HTTP_PROXY environment

pro http::set_proxy

http_proxy1=chklog('http_proxy')
http_proxy2=chklog('HTTP_PROXY')
if is_blank(http_proxy1) and is_blank(http_proxy2) then begin
 self.proxy_host=''
 self.proxy_port=0
 return
endif

if is_string(http_proxy1) then http_proxy=http_proxy1 else http_proxy=http_proxy2

self->url_parse,http_proxy,host,port=port
if is_string(host) then self.proxy_host=host
if is_number(port) then self.proxy_port=fix(port) else self.proxy_port=80

return & end

;----------------------------------------------------------------------------
;-- check if proxy server being used

function http::use_proxy

server=self->hget(/server)
return,use_proxy(server)

end

;------------------------------------------------------------------------
;-- open URL via HTTP 

pro http::open,url,err=err,_extra=extra,$
               no_open=no_open
err=''

self->url_parse,url,host,file,port=port
if is_blank(host) then begin
 err='Missing remote server name.'
 message,err,/info
 return
endif

server=host
self->hset,port=fix(port)
self->hset,server=server
if is_string(file) then self->hset,file=file

;-- default to port 80 (or URL-entered port) if not via proxy

tserver=server
tport=self->hget(/port)
if self->use_proxy() then begin
 tserver=self->hget(/proxy_host)
 tport=self->hget(/proxy_port)
endif

;-- just parse and return

if keyword_set(no_open) then return

self->close

connect_timeout=self->hget(/connect_timeout)
if connect_timeout ge 0 then tconnect_timeout=connect_timeout

read_timeout=self->hget(/read_timeout)
if read_timeout ge 0 then tread_timeout=read_timeout

swap_endian=self->hget(/swap_endian)
swap_if_little_endian=self->hget(/swap_if_little_endian)

dprint,tread_timeout,tconnect_timeout

on_ioerror,bail
socket,lun,tserver,tport,/get_lun,_extra=extra,error=error,$
  read_timeout=tread_timeout,connect_timeout=tconnect_timeout


if error eq 0 then begin
 self.unit=lun
 return
endif

bail: 

on_ioerror,null
message,err_state(),/info
err='Failed to connect to '+tserver+' on port '+trim(tport)
message,err,/info
self->close

return & end

;-------------------------------------------------------------------------
;-- check if socket is open

function http::is_socket_open

stat=fstat(self.unit)
return,stat.open

end

;-------------------------------------------------------------------------
;-- close socket

pro http::close

if self.unit gt 0 then close_lun,self.unit
self.unit = 0
return & end

;---------------------------------------------------------------------------
;--- send a request to server

pro http::send,request,err=err,_ref_extra=extra


err=''
if is_blank(request) then return

if ~self->is_socket_open() then self->open,err=err,_extra=extra
if is_string(err) then return

dprint,'% HTTP::SEND: ',request

printf,self.unit,request,format='(a)'
;for i=0,n_elements(request)-1 do printf,self.unit,request[i]

return & end

;---------------------------------------------------------------------------
;--- send HEAD request to determine server response

pro http::head,url,response,_ref_extra=extra,err=err

response=''

self->send_request,url,/head,_extra=extra,err=err
if is_string(err) then begin
 self->close
 return
endif

self->read_response,response,err=err,_extra=extra

self->close

if is_string(response) and n_params() eq 1  then print,response

return & end

;----------------------------------------------------------------------------
;-- compare local and remote file sizes

function http::same_size,url,lfile,err=err,rsize=rsize,lsize=lsize,_ref_extra=extra

err=''

rsize=-1 & lsize=-1
if is_blank(url) or is_blank(lfile) then return,0b

lsize=file_size(lfile)
if lsize lt 0 then begin
 err='Local file not found'
 return,0b
endif

if ~self->file_found(url,response,err=err,_extra=extra) then return,0b
http_content,response,size=rsize

dprint,'% lsize, rsize: ',trim(lsize),' ',trim(rsize)
return, lsize eq rsize

end

;----------------------------------------------------------------------------
;-- get URL file type

function http::get_url_type,url,err=err,_ref_extra=extra

err=''
if ~self->file_found(url,response,err=err,_extra=extra) then return,''
http_content,response,type=type

return,type
end

;--------------------------------------------------------------------------
;-- POST content to a server

pro http::post,url,content,output,_ref_extra=extra

if is_blank(content) then begin
 output=''
 return
endif

self->list,url,output,post=content,_extra=extra,/no_check
 
return & end

;---------------------------------------------------------------------------
;--- list text file from server

pro http::list,url,output,err=err,count=count,_ref_extra=extra,$
           verbose=verbose,no_check=no_check


verbose=keyword_set(verbose)
err=''
if is_blank(url) or (n_elements(url) ne 1) then url='/'

output=''
self->url_parse,url,server,query=query

if is_blank(server) then begin
 err='Missing remote server name'
 message,err,/info
 return
endif

;-- check for redirect

durl=url
if ~keyword_set(no_check) and is_blank(query) then begin
 self->head,url,response,err=err,_extra=extra
 if is_string(err) then return
 http_content,response,location=location
 if is_string(location) then begin
  durl=location
  if verbose then message,'Redirecting...',/info 
 endif
endif

self->send_request,durl,err=err,_extra=extra
if is_string(err) then goto,bail

self->read_response,header,err=err,_extra=extra
if is_string(err) then goto,bail

http_content,header,chunked=chunked,size=bsize

;if ~stregex(type,'(text|html|xml)',/bool) then begin
; err='Remote listing is not ASCII format.'
; message,err,/info
; goto,bail
;endif

if chunked and verbose then message,'Reading chunked-encoded data...',/info

rd_socket,self.unit,output,maxsize=bsize,chunked=chunked,/ascii,err=err

bail: 

self->close

return & end

;--------------------------------------------------------------------------
;-- check if file exists on server by sending a request 
;   and examining response 

function http::file_found,url,response,err=err,_ref_extra=extra,$
               no_close=no_close,verbose=verbose

err=''
self->send_request,url,err=err,_extra=extra
if is_string(err) then begin
 self->close
 return,0b
endif

;-- examine the response header

self->read_response,response,_extra=extra
http_content,response,code=code

if code ne 200 then begin
 err='Could not find - '+url 
 if keyword_set(verbose) then message,err,/info
 self->close
 return,0b
endif

if ~keyword_set(no_close) then self->close

return,1b & end


;---------------------------------------------------------------------
;-- check HTTP header for tell-tale errors

pro http::check_header,content,err=err,verbose=verbose,url=url
err=''
verbose=keyword_set(verbose)

if is_string(url) then tfile=url else tfile=''

chk=where(stregex(content,'http.+200.*',/bool,/fold),count)
if count eq 1 then return

;u=stregex(content,'http.+ ([0-9]+)(.*)',/sub,/extr,/fold)
message,content[0],/info

chk=where(stregex(content,'http.+400.*',/bool,/fold),count)
if count gt 0 then begin
 err=strcompress('File '+tfile+' bad request')
 if verbose then message,err,/info
 return
endif

chk=where(stregex(content,'http.+404.*',/bool,/fold),count)
if count gt 0 then begin
 err=strcompress('File '+tfile+' not found')
 if verbose then message,err,/info
 return
endif

chk=where(stregex(content,'http.+403.*',/bool,/fold),count)
if count gt 0 then begin
 err=strcompress('File '+tfile+' access denied')
 if verbose then message,err,/info
 return
endif

err=strcompress('File '+tfile+' unknown error')
if verbose then message,err,/info

return

end

;---------------------------------------------------------------------------
;-- read ASCII response header

pro http::read_response,header,debug=debug,err=err

tries=1
again:
on_ioerror, bail
err='' & linesread=0 & count=0 
text='xxx'
header = strarr(256)
while strtrim(text,2) ne '' do begin
 if ~file_poll_input(self.unit) then begin
  help,/files
  err='No response from server.'
  message,err,/info
  header=''
  return
 endif 
 readf,self.unit,text
 if keyword_set(debug) then print,text
 header[linesread]=text
 linesread=linesread+1
 if (linesread mod 256) eq 0 then header=[header, strarr(256)]
endwhile

if tries eq 2 then message,'Success!',/info
np=n_elements(header)
if linesread gt 0 then begin
 chk=where(strtrim(header,2) eq '',count)
 if (count gt 0) and (count ne np) and (chk[0] lt np) then begin
  header=header[0: chk[0] < (np-1)]
  return
 endif
endif

bail:on_ioerror,null
tries=tries+1
message,err_state(),/info
message,/reset
if tries eq 2 then begin
 message,'Retrying...',/info
 goto,again
endif
header=''
err='No response from server.'

return & end

;---------------------------------------------------------------------------
;-- GET binary data from server

pro http::copy,url,new_name,err=err,out_dir=out_dir,verbose=verbose,$
                    clobber=clobber,status=status,prompt=prompt,$
                    cancelled=cancelled,_ref_extra=extra,$
                    local_file=local_file,no_check=no_check,response=response

status=0
err=''
verbose=keyword_set(verbose)
cancelled=0b
local_file=''
clobber=keyword_set(clobber)

self->url_parse,url,server,file,query=query

if is_blank(server) or is_blank(file) then begin
 err='Missing or invalid URL filename entered'
 message,err,/info
 return
endif

if is_string(out_dir) then tdir=local_name(out_dir) else begin
 tdir=curdir()
 out_dir=tdir
endelse

break_file,local_name(file),dsk,dir,name,ext
out_name=trim(name+ext)

if is_string(new_name) then begin
 break_file,local_name(new_name),dsk,dir,name,ext
 out_name=trim(name+ext)
 if is_string(dsk+dir) then tdir=trim(dsk+dir)
endif

;-- ensure write access to download directory

if ~write_dir(tdir,/verbose,err=err) then return
ofile=concat_dir(tdir,out_name)
bsize=0l
osize=0l

;-- send HEAD request to check for redirect (except for queries)

durl=url
if ~keyword_set(no_check) and is_blank(query) then begin
 self->head,url,response,err=err,_extra=extra
 if is_string(err) then begin
  message,err,/info
  return
 endif
 http_content,response,location=location

;-- check for redirect

 if is_string(location) then begin
  durl=location
  ofile=concat_dir(tdir,file_basename(durl)) 
  if verbose then message,'Redirecting...',/info
 endif
endif

;-- send get request

self->send_request,durl,_extra=extra,err=err
if is_string(err) then begin
 self->close
 return
endif

self->read_response,response,_extra=extra,err=err
if is_string(err) then begin
 self->close
 return
endif

http_content,response,code=code,size=bsize,chunked=chunked,$
                     disposition=disposition,type=type

scode=strmid(strtrim(code,2),0,1)
if scode ne 2 then begin
 err='Error accessing '+durl
 if verbose then begin
  message,err,/info
  help,code
 endif
 self->close
 return
endif

;-- check for file name change

if is_string(disposition) then ofile=concat_dir(tdir,disposition)

;-- if file exists, download a new one if /clobber or local size
;   differs from remote

chk=file_info(ofile)
have_file=chk.exists
osize=chk.size
if clobber and have_file then file_delete,ofile,/quiet
download=~have_file or clobber or ((bsize ne osize) and (bsize gt 0) and (osize gt 0))

if ~download then begin
 if verbose then message,'Same size local file '+ofile+' already exists (not copied). Use /clobber to recopy.',/info
 local_file=ofile
 self->close
 status=2
 return
endif

;-- check if FITS

;is_fits=stregex(type,'(fts)|(fits)',/bool)
;if is_fits then begin
; if verbose then message,'Downloading FITS image...',/info
; self->hset,/swap_if_little_endian
;endif
 
;-- prompt before downloading

if keyword_set(prompt) and (bsize gt 0) then begin
 ans=xanswer(["Remote file: "+ofile+" is "+trim(str_format(bsize,'(i10)'))+" bytes.",$
              "Proceed with download?"])
 if ~ans then begin self->close & return & endif
endif

if bsize eq 0 then mess='?' else mess=trim(str_format(bsize,"(i10)"))
cmess=['Please wait. Downloading...','File: '+file_basename(ofile),$
       'Size: '+mess+' bytes',$
       'From: '+server,'To: '+tdir]

if verbose and chunked then message,'Reading chunked-encoded data...',/info

;-- read bytes from socket

rd_socket,self.unit,file=ofile,maxsize=bsize,err=err,counts=counts,omessage=cmess, $
          _extra=extra,verbose=verbose,cancelled=cancelled,chunked=chunked

if ((bsize gt 0) and (counts ne bsize)) or is_string(err) or cancelled then begin
 file_delete,ofile,/quiet
 message,err,/info
 return
endif

status=1
chmod,ofile,/g_write,/g_read
local_file=ofile

bail:on_ioerror,null
self->close
if status eq 0 then begin
 err='Error downloading file.'
 message,err,/info
endif

return & end

;-----------------------------------------------------------------------
pro http__define                 

struct={http,server:'',unit:0l,file:'',connect_timeout:0.,buffsize:0l,$
         user_agent:'',protocol:0.,proxy_host:'',proxy_port:0,swap_endian:0b,$
         swap_if_little_endian:0b,$
         port:0,read_timeout:0.,cache:0b, inherits gen}

return & end
