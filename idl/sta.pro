;pro sta_g
;if NOT keyword_set(file) then begin
;  print,'procedure sta,file=filename'
;  return
;endif
eff=0.46  ;main beam efficiency
d=1.95  ;source distance
b=60.0    ;beam FWHM
path='/data3/w3_2011/reduced/'
cd,path
file1='allu/w3_12gc_cata'
file2='alll/w3_13gc_cata'
file3='alll2/w3_18gc_cata'
;;;;;;;;;
readcol,file1+'.cat',F='I,D,D,D,D,D,D,D,D,D,D,D,D,X,X,X,D,D,D,D,D',PID,Peak1,Peak2,Peak3,Cen1,Cen2,Cen3,Size1,Size2,Size3,$
Sum,Peak,Volume,px,py,rx,ry,pa
good1=where(rx/ry lt 8,count1)
print,count1
if (count1 gt 0) then begin
;radius,luminosity,excite temperature 
  r12=d*1000.0*(sqrt(rx[good1]*ry[good1]*3600.0*3600.0))/206265.0
  L12=((d*1000.0)^2)*((!pi/(180.0*3600.0))^2)*(rx[good1]*ry[good1]*3600.0*3600.0)*sqrt((4.0*alog(2.0))/!pi)*(2.35*Size3[good1]/1000.0)*(Peak[good1]/eff)
  tex=5.532/alog(1.0+5.532/(Peak[good1]/eff+0.819))
;the relative position of the ellipse in unit of arcmin
c12_1=double((px[good1]-36.7661666671)*60.*double(cos(py[good1]*!DTOR)))
c12_2=double((py[good1]-61.8735000001)*60.)
  openw,lun,file1+'.cat1',/get_lun
  printf,lun,"!--------------------------------------------------------------------------------"
  printf,lun,"!Index     Peak1    Peak2     Peak3    Cen1   Cen2   Cen3   Size1    Size2   Size3    Sum   Peak   Volume", $
  "!Shap   px   py  rx   ry    pa    T_ex    radius   Luminosity  C1  C2 "
  printf,lun,"!--------------------------------------------------------------------------------"
  for i=0,count1-1 do begin
       printf,lun,pid[good1[i]],peak1[good1[i]],peak2[good1[i]],peak3[good1[i]],cen1[good1[i]],cen2[good1[i]],cen3[good1[i]],$
       size1[good1[i]],size2[good1[i]],size3[good1[i]],sum[good1[i]],peak[good1[i]],volume[good1[i]],$
      px[good1[i]],py[good1[i]],rx[good1[i]],ry[good1[i]],pa[good1[i]],tex[i],$
       r12[i],L12[i],c12_1[i],c12_2[i],F='(I4, A, A, A, A, A, A, A, A, A, A, A, e17.7, 2x, f9.5, f9.5, f11.8, f11.8, f9.4,  f9.3, f9.3, f9.3, f8.3, f8.3)'
   endfor
   free_lun,lun
endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;13CO clump
;;;;;;;;;;;;;;;;;;;;;;;;;;
readcol,file2+'.cat',F='I,D,D,D,D,D,D,D,D,D,D,D,D,X,X,X,D,D,D,D,D',pid_13,p1_13,p2_13,p3_13,c1_13,c2_13,c3_13,s1_13,s2_13,s3_13,$
sum_13,p_13,v_13,px_13,py_13,rx_13,ry_13,pa_13
good2=where((rx_13/ry_13 lt 10) and (p_13 lt 40),count2)
print,count2
if (count2 gt 0) then begin 
  r13=d*1000.0*(sqrt(rx_13[good2]*ry_13[good2]*3600.0*3600.0))/206265.0
  L13=((d*1000.0)^2)*((!pi/(180.0*3600.0))^2)*(rx_13[good2]*ry_13[good2]*3600.0*3600.0)*sqrt((4.0*alog(2.0))/!pi)*(2.35*S3_13[good2]/1000.0)*(P_13[good2]/eff)
  t=dblarr(count2)
  Tau13=dblarr(count2)
  Num13=dblarr(count2)
  M13=dblarr(count2)
  Mv13=dblarr(count2)
;the relative position of the ellipse in unit of arcmin
c13_1=double((px_13[good2]-36.7661666671)*60.*double(cos(py_13[good2]*!DTOR)))
c13_2=double((py_13[good2]-61.8735000001)*60.)
  openw,lun,file2+'.cat1',/get_lun
  printf,lun,"!--------------------------------------------------------------------------------"
  printf,lun,"!Index     Peak1    Peak2     Peak3    Cen1   Cen2   Cen3   Size1   Size2", $      
  "!Size3     Sum     Peak     Volume   Shap   px   py  rx   ry    pa  T_ex   radius", $   
  "!Luminosity     Tau   N_colume    M_LTE     M_vir  C1(arcmin)   C2(arcmin)"
  printf,lun,"!--------------------------------------------------------------------------------"
;find the nearest 12CO clump  
  for i=0,count2-1 do begin
;i=13  
   di=sqrt((px_13[good2[i]]*3600.-px[good1]*3600.)^2+(py_13[good2[i]]*3600.-(py[good1]*3600.))^2)
   vi=sqrt((c3_13[good2[i]]-cen3[good1])^2+(p3_13[good2[i]]-peak3[good1])^2)/1000.
di1=sort(di)
vi1=sort(vi[di1[0:6]])
ti1=sort(tex[di1[vi1]])
t[i]=mean(tex[di1[vi1[ti1[5:6]]]]) 
if (t[i] lt 20) then t[i]=20
 Tau13[i]=(-1.0)*alog(1.0-((p_13[good2[i]]/eff)/(5.29*((1./(exp(5.29/t[i])-1.0))-0.164))))
     Num13[i]=(2.42e14*t[i]*Tau13[i]*2.35*s3_13[good2[i]]/1000.0)/(1.0-exp(-5.29/t[i]))
     M13[i]=5.0e5*2.8*1.67353e-27*!dpi*r13[i]*r13[i]*3.0856776e18*3.0856776e18*Num13[i]/1.989e30
     Mv13[i]=2.10e2*r13[i]*(2.35*s3_13[good2[i]]/1000.0)^2 
     printf,lun,pid_13[good2[i]],p1_13[good2[i]],p2_13[good2[i]],p3_13[good2[i]],c1_13[good2[i]],$
     c2_13[good2[i]],c3_13[good2[i]],s1_13[good2[i]],s2_13[good2[i]],s3_13[good2[i]],sum_13[good2[i]],$
     p_13[good2[i]],v_13[good2[i]],px_13[good2[i]],py_13[good2[i]],rx_13[good2[i]],ry_13[good2[i]],$
     pa_13[good2[i]],t[i],r13[i],L13[i],Tau13[i],Num13[i],M13[i],Mv13[i],$
     c13_1[i],c13_2[i],F='(I4, A, A, A, A, A, A, A, A, A, A, A, e17.7, 2x, f9.5, f9.5, f11.8, f11.8, f9.4, f7.3, f11.3, f8.3,f9.3,e18.7,f9.3,f9.3,f9.3,f9.3)'
  endfor
 free_lun,lun
endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;C18O clump;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
readcol,file3+'.cat',F='I,D,D,D,D,D,D,D,D,D,D,D,D,X,X,X,D,D,D,D,D',pid_18,p1_18,p2_18,p3_18,c1_18,c2_18,c3_18,s1_18,s2_18,s3_18,$
sum_18,p_18,v_18,px_18,py_18,rx_18,ry_18,pa_18
good3=where((rx_18/ry_18 lt 10) and (p_18 lt 5.2),count3)
if (count3 gt 0) then begin 
  r18=d*1000d*(sqrt(rx_18[good3]*ry_18[good3]*3600d*3600d))/206265d
  L18=((d*1000d)^2)*((!pi/(180d*3600d))^2)*(rx_18[good3]*ry_18[good3]*3600d*3600d)*sqrt((4d*alog(2d))/!pi)*(2.35d*S3_18[good3]/1000d)*(P_18[good3]/eff)
  t=dblarr(count3)
  Tau18=dblarr(count3)
  Num18=dblarr(count3)
  M18=dblarr(count3)
  Mv18=dblarr(count3)
;the relative position of the ellipse in unit of arcmin
c18_1=double((px_18[good3]-36.7661666671)*60.*double(cos(py_18[good3]*!DTOR)))
c18_2=double((py_18[good3]-61.8735000001)*60.)
  openw,lun,file3+'.cat1',/get_lun
  printf,lun,"!--------------------------------------------------------------------------------"
  printf,lun,"!Index     Peak1    Peak2     Peak3    Cen1   Cen2   Cen3   Size1   Size2", $      
  "!Size3     Sum     Peak     Volume   Shap   px   py  rx   ry    pa  T_ex   radius", $   
  "!Luminosity     Tau   N_colume    M_LTE     M_vir  C1(arcmin)   C2(arcmin)"
  printf,lun,"!--------------------------------------------------------------------------------"
;find the nearest 12CO clump  
  for i=0,count3-1 do begin
     di=sqrt((px_18[good3[i]]*3600.-px[good1]*3600.d)^2+(py_18[good3[i]]*3600.-(py[good1]*3600.d))^2)
     vi=sqrt((c3_18[good3[i]]-cen3[good1])^2+(p3_18[good3[i]]-peak3[good1])^2)/1000.
    di1=sort(di)
    vi1=sort(vi[di1[0:6]])
    ti1=sort(tex[di1[vi1]])
;t[i]=mean(tex[di1[vi1[0:3]]])   
t[i]=mean(tex[di1[vi1[ti1[5:6]]]])
if t[i] lt 20 then t[i]=20     
     Tau18[i]=(-1.0)*alog(1.0-((p_18[good3[i]]/eff)/(5.27*((1.0/(exp(5.27/t[i])-1.0))-0.166))))
     Num18[i]=(2.24e14*t[i]*Tau18[i]*2.35*s3_18[good3[i]]/1000.0)/(1.0-exp(-5.27/t[i]))
     M18[i]=7.0e6*2.8*1.67353e-27*!dpi*r18[i]*r18[i]*3.0856776e18*3.0856776e18*Num18[i]/1.989e30
     Mv18[i]=2.10e2*r18[i]*(2.35d*s3_18[good3[i]]/1000d)^2 
     printf,lun,pid_18[good3[i]],p1_18[good3[i]],p2_18[good3[i]],p3_18[good3[i]],c1_18[good3[i]],$
     c2_18[good3[i]],c3_18[good3[i]],s1_18[good3[i]],s2_18[good3[i]],s3_18[good3[i]],sum_18[good3[i]],$
     p_18[good3[i]],v_18[good3[i]],px_18[good3[i]],py_18[good3[i]],rx_18[good3[i]],ry_18[good3[i]],$
     pa_18[good3[i]],t[i],r18[i],L18[i],Tau18[i],Num18[i],M18[i],Mv18[i],$
     c18_1[i],c18_2[i],F='(I4, A, A, A, A, A, A, A, A, A, A, A, e17.7, 2x, f9.5, f9.5, f11.8, f11.8, f9.4, f8.3, f10.3, f8.3,f9.3,e18.3,f9.3,f9.3,f9.3,f9.3)'
  endfor
  free_lun,lun
endif
end

