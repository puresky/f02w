;+
; Project     : VSO
;
; Name        : IDLNETURL2__DEFINE
;
; Purpose     : Wrapper around IDLnetURL class to override SETPROPERTY
;               method to permit updating HEADERS. 
;               Also checks for HTTP_PROXY and USER_AGENT environment variables
;
; Category    : utility system sockets
;
; Syntax      : IDL> o=obj_new('idlneturl2')
;
; Inputs      : None
;
; Outputs     : O = IDL network object
;
; Keywords    : USER_AGENT = user-agent string passed to SETPROPERTY
;
; History     : 14-July-2012, Zarro (ADNET) - Written
;
;-

function idlneturl2::init,_extra=extra,verbose=verbose

ok=self->idlneturl::init()
if ~ok then return,0

;-- check if $http_proxy environment variable defined

proxy1=chklog('http_proxy')
proxy2=chklog('HTTP_PROXY')
if is_string(proxy2) then proxy=proxy2 else if is_string(proxy1) then proxy=proxy1

if is_string(proxy) then begin
 if ~stregex(proxy,'^http',/bool) then proxy='http://'+proxy
 ptc=url_parse(proxy)
 if is_string(ptc.host) then begin
  proxy_hostname=ptc.host
  if is_string(ptc.username) then proxy_username=ptc.username
  if is_string(ptc.password) then proxy_password=ptc.password
  if is_string(ptc.port) then proxy_port=ptc.port
  if keyword_set(verbose) then message,'Using proxy server - '+proxy,/info
 endif
endif

;-- check for USER_AGENT environment variable

chk1=chklog('user_agent') 
chk2=chklog('USER_AGENT')
if is_string(chk1) then user_agent=chk1 else if is_string(chk2) then user_agent=chk2

self->setproperty,user_agent=user_agent,verbose=verbose,_extra=extra,$
      proxy_hostname=proxy_hostname,proxy_port=proxy_port,$
      proxy_username=proxy_username,proxy_password=proxy_password

return,ok

end

;-------------------------------------------------------------------------------
pro idlneturl2::setproperty,_extra=extra,$
      user_agent=user_agent,headers=headers,verbose=verbose

;-- insert keyword into HEADERS keyword

if is_string(user_agent,/blank) then begin
 agent_header='User-Agent: '+strtrim(user_agent)
 if is_string(headers) then begin
  chk=where(stregex(headers,'User-Agent',/bool,/fold),complement=comp,ncomp=ncomp)
  if ncomp gt 0 then headers=[headers[comp],agent_header] else headers=agent_header
 endif else headers=agent_header
endif

if keyword_set(verbose) then begin
 if is_string(headers) then begin 
  message,'Headers: ',/info
  print,headers
 endif
endif

self->idlneturl::setproperty,_extra=extra,headers=headers,verbose=verbose

self->getproperty,url_hostname=server

if ~use_proxy(server,verbose=verbose) then begin
 self->getproperty,proxy_hostname=proxy_hostname
 self->idlneturl::setproperty,proxy_hostname='',proxy_port=''
endif

return & end

;-----------------------------------------------
pro idlneturl2__define

temp={idlneturl2, inherits idlneturl}

return & end
