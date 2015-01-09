;+
;  :Description:
;    function of the routine
;  :Syntax:
;    
;    Input:
;    Output:
;      file     : 
;      variable :
;  :Todo:
;    advanced function of the routine
;    additional function of the routine
;  :Categories:
;    type of the routine
;  :Uses:
;    .pro
;  :See Also:
;    .pro
;  :Params:
;    x : in, required, type=fltarr
;       independent variable
;    y : in, required, type=fltarr
;       dependent variable
;  :Keywords:
;    keyword1 : In, Type=float
;    keyword2 : In, required
;  :Author: puresky
;  :History:
;    V0     2014年9月20日 13:30:29
;    V0.1  2014年9月20日 13:30:54
;    V1.0 
;
;-
;Comment Tags:
;    http://www.exelisvis.com/docs/IDLdoc_Comment_Tags.html
;
;

print,"Initializing...."
print,''
    if(!version.os_family eq 'unix') then device,true_color=24
    
    window,/free,/pixmap,colors=-10
    wdelete,!d.window
    device,retain=2,decomposed=0,set_character_size=[10,12]
    device,get_visual_depth=depth
        print,'Display depth:',depth
        print,'Color table size:',!d.table_size
        pathsep = PATH_SEP(/SEARCH_PATH)
        !PATH = EXPAND_PATH('+~/scripts/idl') + pathsep + !PATH     ; Won't change IDL_PATH preference.
        print,'Customed path added: ~/scripts/idl. To see more by typing "print,!PATH"'
print,''
print,'Initialized.'
