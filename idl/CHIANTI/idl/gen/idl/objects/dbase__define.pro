;+
; Project     :	VSO
;
; Name        :	DBASE__DEFINE
;
; Purpose     :	Object wrapper around UIT database software
;
; Category    :	Databases
;
; History     :	3-May-2013, Zarro (ADNET), written.
;
;-

function dbase::init,name

!priv=3

self->set,name=name

return,1

end

;-----------------------------------------------------------

pro dbase::cleanup

self->close

return & end

;------------------------------------------------------------
;-- purge database of deleted entries

pro dbase::purge,err=err

self->open,/write,err=err
if is_string(err) then return

entries = dbfind('deleted=y', /silent,count=count)
if count gt 0 then dbdelete, entries
self->close
return
end

;------------------------------------------------------------

pro dbase::set,name=name,err=err

err=''

if is_string(name) then begin
 dbname=trim(name)
 dbfile=dbname+'.dbf'
 s=find_with_def(dbfile,'ZDBASE')
 if s eq '' then begin
  err='Could not locate database - '+dbname
  message,err,/info
  message,'Check ZDBASE is defined.',/info
  return
 endif
 self.name=dbname
 self.directory=file_dirname(s)
endif

return
end
  
;-------------------------------------------------------------

pro dbase::add,def,err=err,replace=replace

err=''

if ~is_struct(def) then begin
 err='Invalid database entry.'
 message,err,/info
 return
endif

if n_elements(def) gt 1 then begin
 err='Input must be scalar.'
 message,err,/info
 return
endif

if ~self->valid(def) then begin
 err='Invalid metadata input.'
 message,err,/info
 return
endif

; Check if identical entry already in the database
; If input ID ge 0 and different entry found in DB then replace it

replace=keyword_set(replace)
found=1b

if def.id ge 0 then begin
 db_def=self->get(def.id,err=err)
 if is_blank(err) then begin
  if match_struct(def,db_def) then begin
   err='Identical entry already in database.'
   message,err,/info
   if ~replace then return
  endif
  if ~replace then begin
   message,'Entry with same ID already in database. Use /replace to replace',/info
   return
  endif
 endif else found=0b
endif 

;  Open the database for write access.

self->open,/write,err=err
if is_string(err) then return

;  If adding, find the largest ID currently in the database and
;  increment it.

dbname=self->getprop(/name)
n_entries = db_info('entries',dbname)
if n_entries eq 0 then new_id = 0L else begin
 if (def.id lt 0) or ~found then begin
  dbext, -1, 'id', ids
  new_id = max(ids) + 1L
 endif
endelse
if (n_entries eq 0) or (def.id lt 0) or ~found then begin
 message,'Adding new entry with ID = '+trim(new_id),/info
 replace=0
endif

;-- If replacing, delete old entry first

if replace then begin
 new_id=def.id 
 message,'Replacing entry with ID = '+trim(new_id),/info
 entries = dbfind('id='+strtrim(long(new_id),2)+',deleted=n',/silent,count=count)
 if count eq 0 then begin
  err='Could not replace old entry.'
  message,err,/info
  self->close
  return
 endif
 for i=0,n_elements(entries)-1 do dbupdate, entries[i], 'deleted', 'y'
endif 

;  Add the entry to the database.

tags=tag_names(def)
ntags=n_elements(tags)
cmd="dbbuild,new_id"
for i=1,ntags-1 do cmd=cmd+",def.("+trim(i)+")"
cmd=cmd+",'n',status=status"
s=execute(cmd)

;  Update the id number in the structure. Return success.
	
if status ne 0 then def.id = new_id else begin
 err='Write to database was unsuccessful.'
 message,err,/info
endelse 

self->close
return
end

;-------------------------------------------------------------------

pro dbase::delete,id,err=err

err=''

if ~is_number(id) then return
self->open,err=err,/write
if is_string(err) then return

;  Search on ID field.

entries = dbfind('id='+strtrim(long(id),2)+',deleted=n',/silent, count=count)

if count eq 0 then begin
 err='Entry ID not found in database.'
 message,err,/info
endif else begin
 for i=0,n_elements(entries)-1 do dbupdate, entries[i], 'deleted', 'y'
endelse

self->close

return
end


;--------------------------------------------------------------------

function dbase::get,id,err=err

err=''

if ~is_number(id) then return,-1
self->open,err=err
if is_string(err) then return,-1

;  Search on ID field.

entries = dbfind('id='+strtrim(long(id),2)+',deleted=n',/silent, count=count)

;  If no entries were found, then return immediately.

if count eq 0 then begin
 err='Entry ID not found in database.'
 message,err,/info
endif else begin

;  Extract the relevant entry from the database.

 def=self->extract(entries,err=err)
endelse

self->close
if is_string(err) then return,-1 else return,def

return,def
end

;--------------------------------------------------------------------------

function dbase::extract,entries,err=err

err=''

if ~exist(entries) then return,-1
def=self->metadata()

tag_list=tag_names(def)
ntags=n_elements(tag_list)
nstart=0 & nend= (ntags-1) < 11
repeat begin
 stags=tag_list[nstart:nend]
 stag_names=arr2str(stags,delim=',')
 s=execute('dbext,entries,"'+stag_names+'",'+stag_names)
 if s eq 0 then begin
  err= 'Failed to read database.'
  message,err,/info
  self->close
  return,-1
 endif
 nstart=(nend+1) & nend= (ntags-1) < (nstart+11)
 done= (nstart gt nend)
endrep until done

count=n_elements(entries)
if count gt 1 then def=replicate(def,count)
for i=0,n_elements(tag_list)-1 do begin
 cmd='def.'+tag_list[i]+'='+tag_list[i]
 s=execute(cmd)
endfor

return,def 
end

;-------------------------------------------------------------------
;-- open database

pro dbase::open,update,write=write,err=err

err=''
if ~is_number(update) then update=0
if keyword_set(write) then update=1
dbname=self->getprop(/name)
if is_blank(dbname) then begin
 err='No database specified.'
 message,err,/info
 return
endif

if update gt 0 then begin
 if ~self->access() then begin
  err='No write access to database.'
  message,err,/info
  return
 endif
endif

dbopen,dbname,update,unavail=unavail
if unavail eq 1 then begin
 err='Database currently unavailable.'
 message,err,/info
endif

return
end

;---------------------------------------------------------------------

function dbase::access

dbname=self->getprop(/name)
if is_blank(dbname) then return,0b
dbdir=self->getprop(/directory)
if is_blank(dbdir) then return,0b
return,file_test(concat_dir(dbdir,dbname+'.dbf'),/write)

end
;----------------------------------------------------------------------

function dbase::valid,def,err=err

err=''
return,1b

end

;----------------------------------------------------------------------

pro dbase::close

dbclose

return & end

;-----------------------------------------------------------------------

pro dbase__define

struct={dbase,name:'',directory:'',inherits gen}

return & end
