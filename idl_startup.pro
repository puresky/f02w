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
