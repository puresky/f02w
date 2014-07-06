;+
; Project     : SDO
;
; Name        : SDO__DEFINE
;
; Purpose     : Class definition for SDO
;
; Category    : Objects
;
; History     : Written 30 August 2012, D. Zarro (ADNET)
;
; Contact     : dzarro@solar.stanford.edu
;-

;---------------------------------------------------

function sdo::search,tstart,tend,_ref_extra=extra

return,vso_files(tstart,tend,_extra=extra,window=30)

end

;----------------------------------------------------
pro sdo::getfile,file,local_file=rfile,rice=rice,_ref_extra=extra,err=err,count=count

err='' & rice=0b & rfile=''

self->fits::getfile,file,local_file=afile,err=err,_extra=extra,count=count
if (count eq 0) then return

self->empty

;-- check if RICE-compressed

rfile=afile
rice=bytarr(count)
for i=0,count-1 do begin
 if is_rice_comp(afile[i]) then begin
  dfile=rice_decomp(afile,err=err)
  if is_string(err) then continue
  rfile[i]=dfile
  rice[i]=1b
 endif 
endfor

if count eq 1 then begin
 rfile=rfile[0]
 rice=rice[0]
endif

return & end

;-----------------------------------------------------

pro sdo::write,file,k,err=err,out_dir=out_dir,$
             verbose=verbose,_ref_extra=extra

if is_blank(file) then begin
 message,'Output filename not entered.',/info
 return
endif

odir=curdir()
ofile=file_break(file,path=path)
if is_string(out_dir) then odir=out_dir else if is_string(path) then odir=path
if ~file_test(odir,/directory,/write) then begin
 message,'Output directory name is invalid or does not have write access.',/info
 return
endif

pmap=self->get(k,/map,/pointer)
index=self->get(k,/index)
if ~ptr_exist(pmap) or ~is_struct(index) then begin
 message,'No data saved in map object.',/info
 return
endif

mwritefits,index,(*pmap).data,outfile=ofile,outdir=odir,loud=verbose,_extra=extra

return & end

;-----------------------------------------------------------------------------
;-- check for SDO branch in !path

function sdo::have_path,err=err,verbose=verbose

err=''
if ~have_proc('read_sdo') then begin
 ssw_path,/ontology,/quiet
 if ~have_proc('read_sdo') then begin
  err='VOBS/Ontology branch of SSW not installed.'
  if keyword_set(verbose) then message,err,/info
  return,0b
 endif
endif

return,1b
end

;------------------------------------------------------
pro sdo__define,void                 

void={sdo, inherits fits}

return & end
