;+
; Project     : VSO
;
; Name        : HTTP_CONTENT
;
; Purpose     : Parse HTTP response content
;
; Category    : utility system sockets
;
; Syntax      : IDL> http_content,response
;
; Inputs      : CONTENT = HTTP response string 
;
; Outputs     : HEADER = response header
;
; Keywords    : CODE = response status code
;             : TYPE = supported type
;             : SIZE = number of bytes in return content
;             : DISPOSITION = alternate return filename
;             : CHUNKED = 1 if content is chunked
;             : LOCATION = alternate URL if redirected
;             : DATE = content date stamp
;             : RANGES = input byte ranges (if byte serving)   
;
; History     : 23-Jan-2013, Zarro (ADNET) - Written
;
;-

pro http_content,response,type=type,size=bsize,date=date,$
               disposition=disposition,location=location,code=code,$
               chunked=chunked,ranges=ranges

if is_blank(response) then begin
 type='' & date='' & bsize=0l & disposition='' & location='' & code=404
 chunked=0b
 return
endif

;-- get type

if arg_present(type) then begin
 type=''
 cpos=stregex(response,'Content-Type:',/bool,/fold)
 chk=where(cpos,count)
 if count gt 0 then begin
  temp=response[chk[0]]
  pos=strpos(temp,':')
  if pos gt -1 then type=strtrim(strmid(temp,pos+1,strlen(temp)),2)
 endif
endif else type=''

;-- get last modified data

if arg_present(date) then begin
 date=''
 cpos=stregex(response,'Last-Modified:',/bool,/fold)
 chk=where(cpos,count)
 if count gt 0 then begin
  temp=response[chk[0]]
  pos=strpos(temp,':')
  if pos gt -1 then begin
   time=strtrim(strmid(temp,pos+1,strlen(temp)),2)
   pie=str2arr(time,delim=' ')
   date=anytim2utc(pie[1]+'-'+pie[2]+'-'+pie[3]+' '+pie[4],/vms)
 endif
endif
endif else date=''

;-- get size

if arg_present(bsize) then begin
 bsize=0l
 cpos=stregex(response,'Content-Length:',/bool,/fold)
 chk=where(cpos,count)
 if count gt 0 then begin
  temp=response[chk[0]]
  pos=strpos(temp,':')
  if pos gt -1 then bsize=long(strmid(temp,pos+1,strlen(temp)))
 endif
endif else bsize=0l

;-- get content disposition

if arg_present(disposition) then begin
 disposition=''
 disposition_index=where(stregex(response,'^Content-Disposition:',/bool,/fold),count)
 if (count gt 0) then begin
  disp = response[disposition_index]
  temp = stregex( disp, '^Content-Disposition:.*filename="([^"]*)"', /extract, /subexp,/fold)
  file = temp[1]

;-- strip out any suspicious characters

  if is_string(file) then begin
   temp = strsplit( file,'[^-0-9a-zA-Z._]+', /regex, /extract )
   disposition=strjoin( temp,'_')
 endif
endif
endif else disposition=''

;-- redirection?

if arg_present(location) then begin
 location=''
 redir=stregex(response,'Location: *([^ ]+)',/fold,/extract,/sub)
 chk=where(redir[1,*] ne '',count)
 if count gt 0 then location=strtrim(redir[1,chk[0]],2)
endif else location=''

;-- status code

if arg_present(code) then begin
 u=stregex(response,'http.+ ([0-9]+)(.*)',/sub,/extr,/fold)
 chk=where(u[1,*] ne '',count)
 if count gt 0 then code=fix(u[1,chk[0]])
endif else code=404

;-- chunked?

if arg_present(chunked) then begin
 chk=where(stregex(response,'Transfer-Encoding: chunked',/bool,/fold) eq 1,count)
 chunked=(count gt 0)
endif else chunked=0b

;-- ranges requested?

if arg_present(ranges) then begin
 accept=''
 cpos=stregex(response,'Accept-Ranges:',/bool,/fold)
 chk=where(cpos,count)
 if count gt 0 then begin
  temp=response[chk[0]]
  pos=strpos(temp,':')
  if pos gt -1 then accept=strmid(temp,pos+1,strlen(temp))
 endif
 if is_blank(accept) then message,'Accept-Ranges not supported.',/info
endif

return & end
