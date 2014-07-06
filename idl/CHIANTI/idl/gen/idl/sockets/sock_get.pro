;+
; Project     : VSO
;
; Name        : SOCK_GET
;
; Purpose     : Wrapper around IDLnetURL object to download
;               files via HTTP and FTP
;
; Category    : utility system sockets
;
; Syntax      : IDL> sock_get,url,out_name,out_dir=out_dir
;
; Inputs      : URL = remote URL file name to download
;               OUT_NAME = optional output name for downloaded file
;
; Outputs     : See keywords
;
; Keywords    : LOCAL_FILE = Full name of copied file
;               OUT_DIR = Output directory to download file
;               CLOBBER = Clobber existing file
;               STATUS = 0/1/2 fail/success/file exists
;               CANCELLED = 1 if download cancelled
;               PROGRESS = Show download progress
;               NO_CHECK = Don't check remote server for valid URL.
;                          Use when sure that remote file is available.
;
; History     : 27-Dec-2009, Zarro (ADNET) - Written
;                8-Oct-2010, Zarro (ADNET) - Dropped support for
;                COPY_FILE. Use LOCAL_FILE.
;               28-Sep-2011, Zarro (ADNET) - ensured that URL_SCHEME
;               property is set to that of input URL   
;               19-Dec-2011, Zarro (ADNET) 
;                - made http the default scheme
;               7-Sep-2012, Zarro (ADNET)
;                - added more stringent check for valid HTTP status code
;                  200
;               27-Sep-2012, Zarro (ADNET)
;                - added check for FTP status code
;               27-Dec-2012, Zarro (ADNET)
;                 - added /NO_CHECK
;               12-Mar-2012, Zarro (ADNET)
;                 - replaced SOCK_RESPONSE by SOCK_HEADER
;-

;-----------------------------------------------------------------  
function sock_get_callback, status, progress, data  

if (progress[0] eq 1) and (progress[1] gt 0) then begin
 if ptr_valid(data) then begin
  if (*data).progress then begin
   (*data).completed=progress[1] eq progress[2]
   if ~(*data).completed and ~(*data).cancelled then begin
    if ~widget_valid((*data).pid) then begin
     if allow_windows() then begin
      ourl=(*data).ourl
      if obj_valid(ourl) then begin
       ourl->getproperty,url_hostname=server,url_path=file
       bsize=progress[1]
       bmess=trim(str_format(bsize,"(i10)"))
       cmess=['Please wait. Downloading...','File: '+file_basename(file),$
              'Size: '+bmess+' bytes',$
              'From: '+server,$
              'To: '+(*data).ofile]
        (*data).pid=progmeter(/init,button='Cancel',_extra=extra,input=cmess)
      endif
     endif
    endif
   endif
   if widget_valid((*data).pid) then begin
    val = float(progress[2])/float(progress[1])
    if val le 1 then begin
     if (progmeter((*data).pid,val) eq 'Cancel') then begin
      xkill,(*data).pid
      (*data).cancelled=1b
      return,0
     endif
    endif 
   endif
  endif
 endif
endif

;(*data).ourl->getproperty,verbose=verbose
;if verbose then print,status

if ~exist(bsize) then bsize=0l
if ptr_valid(data) then begin
 (*data).bsize=bsize
 if ((*data).completed or (*data).cancelled) then xkill,(*data).pid
endif
 
; return 1 to continue, return 0 to cancel  

return, 1
end

;-----------------------------------------------------------------------------
  
pro sock_get,url,out_name,clobber=clobber,local_file=local_file,no_check=no_check,$
  progress=progress,err=err,status=status,passive=passive,cancelled=cancelled,$
  out_dir=out_dir,username=username,password=password,_ref_extra=extra,verbose=verbose

err='' & status=0

if ~since_version('6.4') then begin
 err='Requires IDL version 6.4 or greater.'
 message,err,/info
 return
endif

if is_blank(url) then begin
 pr_syntax,'sock_get,url,out_dir=out_dir'
 return
endif

verbose=keyword_set(verbose)
error=0
catch,error
if (error ne 0) then begin  
 if verbose then message,err_state(),/info
 catch, /cancel  
 goto,bail  
endif
  
cancelled=0b
local_file=''
clobber=keyword_set(clobber)

stc=url_parse(url)
file=file_break(stc.path)
path=file_break(stc.path,/path)+'/'
if is_blank(file) then begin
 err='File name not included in URL path.'
 message,err,/info
 return
endif

;-- default copying file with same name to current directory
 
odir=curdir()
ofile=file
if n_elements(out_name) gt 1 then begin
 err='Output filename must be scalar string.'
 message,err,/info
 return
endif

if is_string(out_name) then begin
 tdir=file_break(out_name,/path)
 if is_string(tdir) then odir=tdir 
 ofile=file_break(out_name)
endif
if is_string(out_dir) then odir=out_dir
if ~test_dir(odir,/verbose,err=err) then return

user='anonymous'
pass='nobody@home.com'
if is_string(stc.username) then user=stc.username
if is_string(stc.password) then pass=stc.password
if is_string(username) then user=username
if is_string(password) then pass=password
if is_number(passive) then passive=(0 > passive < 1) else passive=1
url_scheme=stc.scheme

bsize=0l & chunked=0b
if ~keyword_set(no_check) and (url_scheme eq 'http') then begin
 response=sock_header(url,code=code,_extra=extra,size=bsize,$
                        chunked=chunked,disposition=disposition)

 ok=((url_scheme eq 'http') and (code eq 200)) or $
    ((url_scheme eq 'ftp') and (code eq 150))
 if ~ok then begin
  err='Error code returned - '+trim(code)
  message,err,/info
  message,'Attempting download...',/info
 endif
 if is_string(disposition) then ofile=disposition
endif

ofile=local_name(concat_dir(odir,ofile))

;-- if file exists, download a new one /clobber or local size
;   differs from remote

chk=file_info(ofile)
have_file=chk.exists
osize=chk.size
if clobber and have_file then file_delete,ofile,/quiet

download=~have_file or clobber or ((bsize ne osize) and (bsize gt 0) and (osize gt 0))

if ~download then begin
 if verbose then message,'Same size local file '+ofile+' already exists (not copied). Use /clobber to recopy.',/info
 local_file=ofile
 status=2
 return
endif

;-- create pointer to pass to callback function 

url_path=path+file
if is_string(stc.query) then url_path=url_path+'?'+stc.query
ourl=obj_new('idlneturl2',url_scheme=url_scheme,$
              verbose=verbose,$
              url_host=stc.host,url_username=user,url_password=pass,$
              url_path=url_path,_extra=extra,ftp_connection_mode=1-passive)

progress=keyword_set(progress) and ~chunked
if progress then begin
 callback_function='sock_get_callback'
 callback_data=ptr_new({ourl:ourl,ofile:ofile,pid:0l,bsize:bsize,progress:progress,cancelled:0b,completed:0b})
 ourl->setproperty,callback_data=callback_data,callback_function=callback_function
endif

;-- start download,

if verbose then t1=systime(/seconds)

result = oUrl->Get(file=ofile,_extra=extra)  

;-- check what happened

bail: 

if is_string(result) then begin
 chk=file_info(ofile)
 have_file=chk.exists
 bsize=chk.size
 if have_file then begin
  if verbose then begin
   t2=systime(/seconds)
   tdiff=t2-t1
   m1=trim(string(bsize,'(i10)'))+' bytes of '+file_basename(ofile)
   m2=' copied in '+strtrim(str_format(tdiff,'(f8.2)'),2)+' seconds.'
   message,m1+m2,/info
  endif
  local_file=ofile
  status=1
 endif else begin
  err='Download failed.'
  message,err,/info
 endelse
endif else begin 
 if ptr_valid(callback_data) then begin
  if (*callback_data).cancelled then begin
   err='Download cancelled.' 
   cancelled=1b
  endif else err='Error in download.'
 endif else err=url+' not found on server.'
 if verbose then message,err,/info
endelse

;-- clean up

if (status eq 0) then file_delete,ofile,/quiet
obj_destroy,ourl
if ptr_valid(callback_data) then heap_free,callback_data

return & end  

