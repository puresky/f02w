;+
; Project     : SDO
;
; Name        : HMI__DEFINE
;
; Purpose     : Class definition for SDO/HMI
;
; Category    : Objects
;
; History     : Written 15 June 2010, D. Zarro (ADNET)
;
; Contact     : dzarro@solar.stanford.edu
;-

function hmi::search,tstart,tend,_ref_extra=extra

return,self->sdo::search(tstart,tend,inst='hmi',_extra=extra)

end

;-------------------------------------------------------------
pro hmi::read,file,_ref_extra=extra

err=''

self->getfile,file,local_file=rfile,rice=rice,err=err,_extra=extra
if is_string(err) then return

chk=get_fits_det(rfile)
if ~stregex(chk,'HMI',/bool,/fold) then begin
 err='Input file not an HMI image.'
 message,err,/info
 return
endif

mrd_head,rfile,header
index=fitshead2struct(header)
if ~self->have_path(err=err,/verbose) then return
read_sdo,rfile,index,data,/noshell,/use_shared,_extra=extra

id='SDO/HMI '+trim(index.content)

wcs=fitshead2wcs(index)
wcs2map,data,wcs,map,id=id,/no_copy
index=rep_tag_value(index,file_basename(rfile),'filename')
self->set,index=index,map=map,/no_copy
self->set,grid=30,/limb

if rice then file_delete,rfile,/quiet

return & end

;------------------------------------------------------
pro hmi__define,void                 

void={hmi, inherits sdo}

return & end
