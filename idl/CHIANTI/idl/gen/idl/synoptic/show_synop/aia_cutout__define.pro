;+
; Project - HESSI
;
; Name        : AIA_CUTOUT__DEFINE
;
; Purpose     : Define an SDO/AIA cutout data object
; 
; Method      : Access the database of AIA cutout FITS files made for each RHESSI
;               flare interval.  Used in SHOW_SYNOP. User selects a time interval,
;               and selects remote site = SDO/AIA cutouts, and click search, a window
;               will pop up allowing them to select the directory (corresponding to 
;               RHESSI flare time) and AIA wavelength.  Then show_synop proceeds as usual
;               displaying the files available for that dir and wave, and the user can
;               choose which ones to download and display. 
;               
;               We use the inherited site class to find the directories of AIA cutouts
;               within the specified times, and use a second interal site object (site2)
;               to find the files in that directory.
;
; Category    : Ancillary GBO Synoptic Objects
;
; Syntax      : IDL> c=obj_new('aia_cutout')
;
; History     : Written 15-Feb-2013, Kim Tolbert
;
; Contact     : kim.tolbert@nasa.gov
; Modifications:
; 1-Aug-2013, Kim. Added /tai to parse_time call in search (needed for caching in show_synop)
; 2-Aug-2013, Kim. Added no_cache to properties, and init to 1, so full list will appear on search in show_synop
;-

function aia_cutout::init,_ref_extra=extra

if ~self->aia::init(_extra=extra) then return,0
if ~self->site::init(_extra=extra) then return, 0

rhost = 'hesperia.gsfc.nasa.gov'
self->setprop, rhost=rhost, ext='', org='month', $
  topdir='/sdo/aia',/full, delim='/'
  
self.site2 = obj_new('site')
self.site2->setprop, rhost='hesperia.gsfc.nasa.gov',ext='fts',org='none',delim='/'
self.no_cache=1b 
  
return,1 & end

;---------------------------------------------------

pro aia_cutout::cleanup
destroy, self.site2
end

;---------------------------------------------------

function aia_cutout::search,tstart,tend,count=count,times=times,err=err,_ref_extra=extra

err = ''
cancel = 0

; use inherited site search to find directories for tstart-tend
urls = self->site::search(tstart,tend,inst='aia',count=nurls,_extra=extra)

; pop up widget for user to select dir and wave 
if nurls gt 0 then files = self->select(urls, count=count, cancel=cancel, _extra=extra)
if cancel then return, -1

if count gt 0 then begin
  times = self->parse_time(files, /tai)
  return, files
endif else begin
  err = 'No files found.'
  return, -1
endelse

end

;---------------------------------------------------

; select method pops up a widget with two selection lists, one for directory (which
; corresponds to RHESSI flare), and one for AIA wavelengths.  User can choose one or
; multiple of each.  Returns file names matching those selections. 
function aia_cutout::select, urls, count=count, cancel=cancel, _ref_extra=extra

count = 0
files = ''
err = 'No files found.'
cancel = 0

waves = trim([94,131,171,193,211,304,335,1600,1700,4500])
; Return directory choice(s) as index, and wavelength choice(s) as string
ind = xsel_list_multi(file_basename(urls), /index, cancel=cancel, $
  title='Select AIA directories and wavelengths', $
  label='Select AIA cutout directories (named by RHESSI flare start time).', $
  n2_items=waves, n2_label='Select wavelength(s):',n2_initial=1, n2_item_sel=n2_item_sel)
if cancel then begin
  err = 'Operation Cancelled.'
  return, ''
endif

; Now use internal site object to search for files within times specified in the directories chosen
tstart = self->getprop(/tstart)
tend = self->getprop(/tend)
for i=0,n_elements(ind)-1 do begin
  url_struct = parse_url(urls[ind[i]])  
  self.site2->setprop, topdir='/'+url_struct.path
  file=self.site2->search(tstart,tend, count=nf, _extra=extra)
  if nf gt 0 then files = [files, temporary(file)]
endfor

; Then select among those files for wavelengths chosen
if n_elements(files) eq 1 then return, ''
chk_waves = arr2str('_' + n2_item_sel + '_', '|')
chk = where(stregex(files, chk_waves, /bool), count)
if count gt 0 then begin
  err = ''
  return, files[chk]
endif

return, ''

end
;---------------------------------------------------

;pro aia_cutout::select_widget, urls

;---------------------------------------------------

;function site::parse_time,input,_ref_extra=extra
;
;return,parse_time(file_basename(input),_extra=extra)
;
;end

pro aia_cutout__define,void                 

void={aia_cutout, no_cache:0b, site2: obj_new(), inherits aia, inherits site}

return & end
