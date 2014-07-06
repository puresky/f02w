;+
; Project     : HESSI
;
; Name        : SOCK_FIND
;
; Purpose     : socket version of FINDFILE
;
; Category    : utility system sockets
;
; Syntax      : IDL> files=sock_find(server,file,path=path)
;                   
; Inputs      : server = remote WWW server name
;               FILE = remote file name or pattern to search 
;
; Outputs     : Matched results
;
; Keywords    : COUNT = # of matches
;               PATH = remote path to search
;               ERR   = string error message
;               USE_NETWORK = use IDLnetURL instead of HTTP object in SOCK_LIST
;
; Example     : IDL> a=sock_find('smmdac.nascom.nasa.gov','*.fts',$
;                                 path='/synop_data/bbso')
;               or
;
;               IDL> a=sock_find('smmdac.nascom.nasa.gov/synop_data/bbso/*.fts')
;
; History     : 27-Dec-2001,  D.M. Zarro (EITI/GSFC) - Written
;                3-Feb-2007, Zarro (ADNET/GSFC) - Modified
;                 - return full URL path
;                 - made no-cache the default
;               27-Feb-2009, Zarro (ADNET) 
;                 - restored caching for faster repeat searching of
;                   same directory
;                 - improved regular expression to handle wild card
;                   searches
;               17-Jan-2010, Zarro (ADNET)
;                 - modified to return "http://" in output
;               22-Oct-2010, Zarro (ADNET)
;                 - modified to extract multiple files listed per line
;               22-July-2011, Zarro (ADNET)
;                 - change sock_list to call sock_list2, which has better
;                   proxy support
;               16-Jan-2012, Zarro (ADNET)
;                 - added _extra to sock_list to pass HTTP
;                   keywords 
;               5-Feb-2013, Zarro (ADNET)
;                 - avoid str_replace call if path not in listing
;               25-Feb-2013, Zarro (ADNET)
;                 - made USE_NETWORK = 1 the default so that 
;                  IDL network object is called, which handles
;                  chunked-encoding better.
;               10-Jul-2013, Zarro (ADNET)
;                 - fixed potential bug when search file not entered
;                   (now defaults to *).
;
; Contact     : DZARRO@SOLAR.STANFORD.EDU
;-

function sock_find,server,file,path=path,count=count,err=err,$
                   _ref_extra=extra,use_network=use_network

;--- start with error checking

err=''
count=0
dfile='' 
dpath=''

if is_blank(server) then begin
 err='Missing remote server name.'
 message,err,/info
 return,''
endif

;-- check if server includes full URL 

dserver=server
durl=url_parse(dserver)
if is_string(durl.host) then dserver=durl.host
if is_string(durl.path) then begin
 dpath=durl.path
 bpath=byte(dpath)
 if bpath[n_elements(bpath)-1] ne byte('/') then begin
  dfile=file_basename(dpath)
  dpath=file_dirname(dpath)
 endif
 if dpath eq '.' then dpath=''
endif

if is_string(path) then dpath=path
if is_string(file) then dfile=file

;-- impose defaults

if is_blank(dfile) then dfile='*'
if is_blank(dpath) then dpath='/'
 
;-- escape any metacharacters

dfile=str_replace(dfile,'.','\.')
dfile=str_replace(dfile,'*','[^ "]*')
dpath=str_replace(dpath,'\','/')

;-- remove duplicate delimiters

vpath=str2arr(dpath,delim='/')
ok=where(trim(vpath) ne '',vcount) 
if vcount eq 0 then dpath='/' else dpath='/'+arr2str(vpath[ok],delim='/')+'/'

url=dserver+dpath
dprint,'% Searching '+url
dprint,'% Path ',dpath
dprint,'% File ',dfile

if ~is_number(use_network) then use_network=1b 
sock_list,url,hrefs,err=err,_extra=extra,use_network=use_network
if is_string(err) or is_blank(hrefs) then return,''

if is_string(dfile) then ireg='[^\?\/ "]*'+trim(dfile)+'[^ "]*' else ireg='[^<> "]+'
regex='href *= *"?('+ireg+') *"?.*>'

;-- concatanate into single string and then split on anchor boundaries
;   [must do this so that multiple files per line get separated]

temp=strsplit(strjoin(hrefs),'< *A +',/extract,/regex,/fold)
match=stregex(temp,regex,/subex,/extra,/fold)
chk=where(match[1,*] ne '',count)
if count eq 0 then return,''
hrefs=reform(match[1,chk])
if count eq 1 then hrefs=hrefs[0]
chk=where(strpos(hrefs,dpath) gt -1,scount)
if scount gt 0 then hrefs[chk]=str_replace(hrefs[chk],dpath,'')
if ~stregex(url,'http:',/bool) then url='http://'+url

return,url+hrefs

end


