;+
; Project     :	VSO
;
; Name        :	EOVSA_DB__DEFINE
;
; Purpose     :	Object wrapper around EOVSA database software
;
; Category    :	Databases
;
; History     :	3-May-2013, Zarro (ADNET), written.
;
;-

function eovsa_db::init

mklog,'ZDBASE','$SSW/radio/eovsa/catalog'

return,self->dbase::init('eovsa')

end

;----------------------------------------------------------

pro eovsa_db::test,reset=reset

if keyword_set(reset) then mklog,'ZDBASE','$SSW/radio/eovsa/catalog' else $
 mklog,'ZDBASE','~/idl/database'

return 
end
;-----------------------------------------------------------
;-- define metadata fields

function eovsa_db::metadata

b=strpad('',80)
def={id:-1l,type:0,date_obs:0d,date_end:0d,freqmin:0.,freqmax:0.,xcen:0.,ycen:0.,$
     polarization:0., resolution:0., antenna:0, file_name:'',file_date:0d,cat_date:0d}

return,def & end

;--------------------------------------------------------------------
;-- update catalog with FITS header metadata

pro eovsa_db::update,files,replace=replace,verbose=verbose

verbose=keyword_set(verbose)
replace=keyword_set(replace)
if is_blank(files) then return
nfiles=n_elements(files)
updated=0

for i=0,nfiles-1 do begin
 if verbose then message,'Processing '+files[i],/info

 self->parse,files[i],metadata

;-- First check for metadata nearest file time. If none, then add it.
;-- If same, check that it differs

 window=5*60.d
 time=metadata.date_obs
 tstart=time-window & tend=time+window
 self->list,tstart,tend,entries,count=count,err=err
 if count eq 0 then begin
  self->add,metadata,err=err
  updated=updated+1
  continue
 endif

;-- How does this one differ?

 check=where(trim(metadata.file_name) eq trim(entries.file_name),count)

 if count eq 0 then begin
  self->add,metadata,err=err
  updated=updated+1
  continue
 endif

 if count gt 1 then begin
  message,'Duplicate file names!',/info
  continue
 endif

 if count eq 1 then begin
  entry=entries[check]
  same=match_struct(metadata,entry,exclude=['id','cat_date'],dtag=dtag)
  if same then continue
  if verbose then message,'Metadata differences - '+arr2str(dtag),/info
  metadata.id=entry.id 
  self->add,metadata,err=err,/replace
  updated=updated+1
 endif

endfor

if verbose then message,trim(updated) +' catalog entries updated.',/info

return
end

;--------------------------------------------------------------------
;-- parse FITS file header into catalog metadata

pro eovsa_db::parse,file,metadata,err=err,header=header

hfits=obj_new('hfits')
hfits->read,file,header=header,err=err
obj_destroy,hfits
if is_string(err) then begin
 message,err,/info
 return
endif

stc=fitshead2struct(header)
metadata=self->metadata()
struct_assign,stc,metadata
metadata.id=-1
metadata.date_obs=anytim2tai(stc.date_obs)
metadata.date_end=anytim2tai(stc.date_end)
metadata.file_name=file_basename(file)

if is_url(file) then begin
 resp=sock_header(file,date=date)
endif else begin
 info=file_info(file)
 date=systim(0,info.mtime,/utc)
endelse
metadata.file_date=anytim2tai(date)

get_utc,utc
metadata.cat_date=anytim2tai(utc)

return
end 

;---------------------------------------------------------------------


pro eovsa_db::list,tstart,tend,items,count=count,err=err

day_secs=24.d*3600.d
count=0
items=-1
if ~valid_time(tstart,err=err) or ~valid_time(tend,err=err) then return

tai_tstart=anytim2tai(tstart)
tai_tend=anytim2tai(tend)

;  Open the database.

self->open,err=err
if is_string(err) then return

;  Find all the entries in the requested time range.

test = trim(tai_tstart,'(f15.3)')+' < date_obs < '+trim(tai_tend,'(f15.3)') 
entries = dbfind(test+',deleted=n',/silent)
if !err eq 0 then begin
 count = 0
 err='No matching entries found.'
 message,err,/info
 return
endif
     
entries = entries[uniq(entries)]
count = n_elements(entries)

;  Extract the requested entries, sorted by times.

entries = dbsort(entries,'date_obs')
items=self->extract(entries,err=err)

return
end

;----------------------------------------------------------------------
;-- check if item is valid metadata

function eovsa_db::valid,item

if ~is_struct(item) then return,0b
def=self->metadata()
if ~match_struct(item,def,/tags_only) then return,0b
if ~valid_time(item.date_obs) then return,0b
check=where(item.type eq [0,1,2],count)
if count eq 0 then return,0b

return,1b

end
;-----------------------------------------------------------------------

pro eovsa_db__define

struct={eovsa_db,inherits dbase}

return & end
