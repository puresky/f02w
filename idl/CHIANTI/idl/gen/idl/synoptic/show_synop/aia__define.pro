;+
; Project     : SDO
;
; Name        : AIA__DEFINE
;
; Purpose     : Class definition for SDO/AIA
;
; Category    : Objects
;
; History     : Written 15 June 2010, D. Zarro (ADNET)
;
; Contact     : dzarro@solar.stanford.edu
; 
; Modifications:
;  20-Mar-2013, Kim Tolbert
;   -Added normalize keyword to read method. If set, divide image by
;   exposure time.
;  28-Mar-2013, Zarro (ADNET)
;  - added patch to use B0 from PB0R
;  2-Apr-2013, Zarro (ADNET)
;  - NORMALIZE now a supported keyword in AIA_PREP. Check if applied.
;-

function aia::init,_ref_extra=extra

if ~self->sdo::init(_extra=extra) then return,0

;-- setup environment

self->setenv,_extra=extra

return,1 & end

;---------------------------------------------------

function aia::search,tstart,tend,_ref_extra=extra

return,self->sdo::search(tstart,tend,inst='aia',_extra=extra)

end

;----------------------------------------------------
pro aia::read,file, _ref_extra=extra,normalize=normalize

self->getfile,file,local_file=rfile,rice=rice,err=err,_extra=extra,count=count
if (count eq 0) then return

have_path=self->have_path()
if ~have_path then message,'Warning - SDO/AIA software not installed. Level 0 files will not prepped.',/info

for i=0,count-1 do begin
 chk=get_fits_det(rfile[i])

 if ~stregex(chk,'AIA',/bool,/fold) then begin
  err='Input file not an AIA image.'
  message,err,/info
  continue
 endif

 mrd_head,rfile[i],header
 index=fitshead2struct(header)
 if index.lvl_num lt 1.5 and have_path then begin
  read_sdo,rfile[i],index,data,/noshell,/use_shared,_extra=extra
  aia_prep,index,data,oindex,odata,_extra=extra,/quiet,/use_ref,/nearest,$
                       normalize=normalize
  data=temporary(odata)
  index=oindex
 endif else mreadfits,rfile[i],index,data,_extra=extra

 if keyword_set(normalize) then begin
  chk=where(stregex(index.history,'normalization',/bool,/fold),count)
  type=size(data,/tname)
  if count eq 0 then begin
   if index.exptime gt 0. then begin
    data=temporary(data)/index.exptime
    if type eq 'INT' then data=nint(temporary(data))
   endif
  endif
 endif

 id='SDO/AIA '+trim(index.WAVELNTH)
 wcs=fitshead2wcs(index)
 wcs2map,data,wcs,map,id=id,/no_copy
 angles=pb0r(map.time)
 map.b0=angles[1]
 index=rep_tag_value(index,file_basename(rfile[i]),'filename')

 self->set,i,index=index,map=map,/no_copy
 self->set,i,/log_scale,grid=30,/limb

 if rice[i] then file_delete,rfile[i],/quiet
endfor

return & end

;-----------------------------------------------------------------------------
;-- check for AIA branch in !path

function aia::have_path,err=err,verbose=verbose

err=''
if ~self->sdo::have_path(verbose=verbose,err=err) then return,0b

if ~have_proc('aia_prep') then begin
 ssw_path,/aia,/quiet
 if ~have_proc('aia_prep') then begin
  err='SDO/AIA branch of SSW not installed.'
  if keyword_set(verbose) then message,err,/info
  return,0b
 endif
endif

return,1b
end

;------------------------------------------------------------------------
;-- setup AIA environment variables

pro aia::setenv,_extra=extra

if is_string(chklog('AIA_CALIBRATION')) then return
mklog,'$SSW_AIA','$SSW/sdo/aia',/local
file_env=local_name('$SSW/sdo/aia/setup/setup.aia_env')
file_setenv,file_env,_extra=extra
return & end

;------------------------------------------------------
pro aia__define,void                 

void={aia, inherits sdo}

return & end
