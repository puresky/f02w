function file_write_request,filename
    while file_test(filename) do begin
        print,'file ', filename, ' exists'
        print,'overwrite it?'
        answer = ''
        read, answer, prompt='y/n?: '
        if answer eq 'y' then begin
            return,filename
        endif else begin
            read, filename, prompt='please input another output file name:'
        endelse
    endwhile
    return,filename
end
