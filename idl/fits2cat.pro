;;Usage: 
;;    fits2cat, 'allu/w3_12gc_cata',path='/data3/w3_2011/reduced/'
;;    fits2cat, 'alll/w3_13gc_cata'
;;    fits2cat, 'alll2/w3_18gc_cata'


pro fits2cat, file, path=path
    if keyword_set(path) then    cd,path
    fxbopen,unit,file+'.FIT',1
    fxbreadm,unit,[1,2,3,4,5,6,7,8,9,10,11,12,13,14],pid,peak1,peak2,peak3,cen1,cen2,cen3,size1,size2,size3,sum,peak,volume,shape
    fxbclose,unit
    num1=n_elements(pid)
    openw,lun,file+'.cat',/get_lun
    for i=0,num1-1 do begin
        printf,lun,pid[i],peak1[i],peak2[i],peak3[i],cen1[i],cen2[i],cen3[i],size1[i],size2[i],size3[i],sum[i],peak[i],$
        volume[i],shape[i],F='(I4, A, A, A, A, A, A, A, A, A, A, A, e17.7, 2x, 80A)'
    endfor
    free_lun,lun
end

