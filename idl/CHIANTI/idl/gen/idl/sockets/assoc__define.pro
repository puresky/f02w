;+
; Project     : VSO
;
; Name        : ASSOC__DEFINE
;
; Purpose     : Object wrapper around ASSOC function that supports
;               reading socket units.
;
; Category    : utility system sockets i/o
;
; Syntax      : IDL> assoc=obj_new('assoc')
;               IDL> assoc->set,unit=unit,data=bytarr(100),offset=10
;                                 or
;               IDL>assoc->set,file='image.dat',data=fltarr(1024,1024)
;                                 or
;               IDL>assoc->set,file='http://host.domain/image.dat',data=fltarr(1024,1024)
;
;               IDL> data1=assoc->read(0)
;               IDL> data2=assoc->read(1)
;
; Inputs      : None
;
; Outputs     : ASSOC = object with read method to access records 
;
; Keywords    : DATA = expression that defines record structure
;               UNIT = unit number of opened file 
;               FILE = name or URL of file to read
;               OFFSET = byte offset to start of data [def=0]
;
; History     : 26-November-2012, Zarro (ADNET) - Written
;
;-

function assoc::init,_extra=extra

self.data=ptr_new(/all)
self.assoc=ptr_new(/all)
if is_struct(extra) then self->set,_extra=extra

return,1
end

;------------------------------------------------------------

pro assoc::cleanup

ptr_free,self.data,self.assoc

return & end

;-----------------------------------------------------------

function assoc::get,_ref_extra=extra

return,self->getprop(_extra=extra)

end

;------------------------------------------------------------

pro assoc::set,data=data,offset=offset,unit=unit,_extra=extra,file=file


if is_number(offset) then self.offset=offset
if exist(data) then *self.data=temporary(data) 

if is_url(file) then begin
 self.url=file
 self.socket=1b & return
endif

if is_number(unit) then self.unit=unit

;-- file name entered?

if is_string(file) then begin
 if file_test(file,/read) then begin
  openr,unit,file,/get_lun
  self.unit=unit
 endif
endif

stat=fstat(self.unit)
if ~stat.open or stat.isatty or (stat.name eq '') then begin
 message,'Unit '+strtrim(self.unit,2)+' not attached to open file.',/info
 return
endif

if ~exist(*self.data) then begin
 message,'Data expression not entered.',/info
 return
endif

*self.assoc=assoc(self.unit,*self.data,self.offset,_extra=extra)

return & end

;-------------------------------------------------------------

function assoc::read,record,_ref_extra=extra

if self.socket then return,self->read_socket(record,_extra=extra) else $
 return,self->read_file(record,_extra=extra)

end

;--------------------------------------------------------------

function assoc::read_socket,record,err=err

err=''
if is_blank(self.url) then begin
 err='URL not entered.'
 message,err,/info
 return,-1
endif

;-- parse URL

purl=url_parse(self.url)
host=purl.host
port=fix(purl.port)

;-- open socket

sock_open,unit,host,port=port,err=err
if is_string(err) then return,-1

;-- figure out how many bytes to request

if ~is_number(record) then record=0 else record = record > 0

nbytes=long(n_bytes(*self.data))
range_start=self.offset+nbytes*long(record)
range_end=range_start+nbytes-1
range=strtrim(range_start,2)+'-'+strtrim(range_end,2)

;-- create and send range request

sock_request,self.url,request,range=range
sock_send,unit,request
sock_receive,unit,response

chk=where(stregex(response,'Accept-Ranges: bytes',/bool),count)
if count eq 0 then begin
 err='Range request not satisfied.'
 message,err,/info
 close_lun,unit
 return,-1
endif

;-- read requested bytes

data=*self.data
sock_read,unit,data,_extra=extra,err=err
close_lun,unit

if is_string(err) then return,-1 else return,data
end

;-------------------------------------------------------------

function assoc::read_file,record,err=err

err=''
error=0
catch, error
IF (error ne 0) then begin
 err=err_state()
 message,err,/info
 catch,/cancel
 message,/reset
 return,-1
endif

on_ioerror,null
if ~is_number(record) then record=0 else record=record > 0
if ~exist(*self.assoc) then begin

 err='ASSOC variable not assigned.'
 message,err,/info
 return,-1
endif

data=(*self.assoc)(record)
return,data

null:
err='Error reading file.'
message,err,/info

return,-1
end

;--------------------------------------------------------------
pro assoc__define                                                                
                                                                               
void={ assoc, $                                                                    
       data:ptr_new(),$
       unit:0L,$                                                            
       offset:0L,$
       url:'',$
       socket:0b,$
       assoc:ptr_new(), inherits dotprop, inherits gen}
 

return & end                                              
