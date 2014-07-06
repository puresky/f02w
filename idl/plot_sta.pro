;pro plotsta_g
path='/data3/w3_2011/reduced/'
cd,path
file1='allu/w3_12gc_cata'
file2='alll/w3_13gc_cata'
file3='alll2/w3_18gc_cata'
readcol,file1+'.cat1',F='I,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D',PID,Peak1,Peak2,Peak3,Cen1,Cen2,Cen3,Size1,Size2,Size3,$
Sum,Peak,Volume,px,py,rx,ry,pa,tex12,r12,L12,skipline=5
readcol,file2+'.cat1',F='I,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D',pid_13,p1_13,p2_13,p3_13,c1_13,c2_13,c3_13,s1_13,s2_13,s3_13,$
sum_13,p_13,v_13,px_13,py_13,rx_13,ry_13,pa_13,tex13,r13,L13,Tau13,Num13,M13,Mv13,skipline=5
readcol,file3+'.cat1',F='I,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D,D',pid_18,p1_18,p2_18,p3_18,c1_18,c2_18,c3_18,s1_18,s2_18,s3_18,$
sum_18,p_18,v_18,px_18,py_18,rx_18,ry_18,pa_18,tex18,r18,L18,Tau18,Num18,M18,Mv18,skipline=5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;radius_12   ----  linewidth_12   
set_plot,'ps'
device,filename='/data3/w3_2011/ps/r12_fwhm12.eps',/encapsulated
device,/portrait
cor=correlate(alog10(r12),alog10((2.35d*Size3)/1000d))
sixlin,alog10(r12[*]),alog10((2.35d*Size3)/1000d),a,siga,b,sigb
plotsym,0
plot,alog10(r12),alog10((2.35d*Size3)/1000d),psym=8,xtitle='log(Radius) [pc]',ytitle='log(Line width) [km s!U-1!N]',xrange=[-1.2,0.4],yrange=[-1,1],xstyle=1,ystyle=1
print,string(a[0],format='(f5.2)')
X =  -(findgen(10.)/(10d))+0.1
oplot,X, X * b[0] +a[0]
fit='Y='+string(b[0],format='(f5.2)')+'X+'+string(a[0],format='(f5.2)')+' (c.c='+string(cor,format='(f5.2)')+')'
legend,[fit],box=0,charsize=1.8,charthick=2,/top
device,/close_file
;;;;;;;;;linewidth_12  -----  luminosity_12 
set_plot,'ps'
device,filename='/data3/w3_2011/ps/fwhm12_l12.eps',/encapsulated
device,/portrait
cor=correlate(alog10((2.35d*Size3)/1000d),alog10(L12))
sixlin,alog10((2.35d*Size3)/1000d),alog10(L12[*]),a,siga,b,sigb
;print,ROBUST_LINEFIT(alog10(L12[*]),alog10((2.35d*Size3)/1000d), YFIT, SIG, COEF_SIG)
;print,COEF_SIG
plotsym,0
plot,alog10(2.35d*Size3/1000d),alog10(L12),psym=8,xtitle='log(Line Width) [km s!U-1!N]',ytitle='log(Luminosity) [K km s!U-1!N]'
X =  -(findgen(10.)/(10d))+0.7
oplot,X, X * b[0] +a[0]
fit='Y='+string(b[0],format='(f5.2)')+'X'+string(a[0],format='(f5.2)')+' (c.c='+string(cor,format='(f5.2)')+')'
legend,[fit],box=0,charsize=1.8,charthick=2,/top
device,/close_file
;;;;;;radius_12  ----- luminosity_12
set_plot,'ps'
device,filename='/data3/w3_2011/ps/r12_l12.eps',/encapsulated
device,/portrait
cor=correlate(alog10(r12),alog10(L12))
sixlin,alog10(r12),alog10(L12),a,siga,b,sigb
print,string(a[0],format='(f5.2)')
plotsym,0
plot,alog10(r12),alog10(L12),psym=8,xtitle='log(Radius) [pc]',ytitle='log(Luminosity) [K km s!U-1!N]',xrange=[-1.3,0.5],xstyle=1
X =  -(findgen(13.)/(10d))+0.2
oplot,X, X * b[0] +a[0]
fit='Y='+string(b[0],format='(f5.2)')+'X+'+string(a[0],format='(f5.2)')+' (c.c='+string(cor,format='(f5.2)')+')'
legend,[fit],box=0,charsize=1.8,charthick=2,/top
device,/close_file
;;;;;;;
;;;tex12
;;;;;;;;;;
set_plot,'ps'
device,filename='/data3/w3_2011/ps/tex12.eps',/encapsulated
device,/portrait
plothist,tex12,bin=3,/fill,/fline,/boxplot,forient=45;,yrange=[0,12],ystyle=1;,thick=2,charthick=2,xthick=2,ythick=2,xtitle='rms',ytitle='Number',charsize=1.4
device,/close_file
;;;;;;;;;;;;;
;;;;line width 12CO;;;
;;;;;;;;;;;;;;;;;;;;;;
set_plot,'ps'
device,filename='/data3/w3_2011/ps/lw12.eps',/encapsulated
device,/portrait
plothist,2.35*size3/1000.,bin=0.2,/fill,/fline,/boxplot,forient=45;,yrange=[0,12],ystyle=1;,thick=2,charthick=2,xthick=2,ythick=2,xtitle='rms',ytitle='Number',charsize=1.4
device,/close_file
;;;;;;;;;;;;;;;;
;;;;;;;;;;;;
;;;radius 12CO
set_plot,'ps'
device,filename='/data3/w3_2011/ps/r12.eps',/encapsulated
device,/portrait
plothist,r12,bin=0.2,/fill,/fline,/boxplot,forient=45,xrange=[0,5],xstyle=1;,yrange=[0,12],ystyle=1;,thick=2,charthick=2,xthick=2,ythick=2,xtitle='rms',ytitle='Number',charsize=1.4
device,/close_file
;;;;;;;;;;;;;;;;;;
;;;;radius_13   ----  linewidth_13   
set_plot,'ps'
device,filename='/data3/w3_2011/ps/r13_fwhm13.eps',/encapsulated
device,/portrait
cor=correlate(alog10(r13),alog10((2.35d*s3_13)/1000d))
sixlin,alog10(r13[*]),alog10((2.35d*s3_13)/1000d),a,siga,b,sigb
plotsym,0
plot,alog10(r13),alog10((2.35d*s3_13)/1000d),psym=8,xtitle='log(Radius) [pc]',ytitle='log(Line width) [km s!U-1!N]',xrange=[-1.2,0.4],yrange=[-1,1],xstyle=1,ystyle=1
print,string(a[0],format='(f5.2)')
X =  -(findgen(10.)/(10d))+0.1
oplot,X, X * b[0] +a[0]
fit='Y='+string(b[0],format='(f5.2)')+'X+'+string(a[0],format='(f5.2)')+' (c.c='+string(cor,format='(f5.2)')+')'
legend,[fit],box=0,charsize=1.8,charthick=2,/top
device,/close_file
;;;;;;;;;linewidth_13  -----  luminosity_13 
set_plot,'ps'
device,filename='/data3/w3_2011/ps/fwhm13_l13.eps',/encapsulated
device,/portrait
cor=correlate(alog10((2.35d*s3_13)/1000d),alog10(L13))
sixlin,alog10((2.35d*s3_13)/1000d),alog10(L13[*]),a,siga,b,sigb
;print,ROBUST_LINEFIT(alog10(L12[*]),alog10((2.35d*Size3)/1000d), YFIT, SIG, COEF_SIG)
;print,COEF_SIG
plotsym,0
plot,alog10(2.35d*s3_13/1000d),alog10(L13),psym=8,xtitle='log(Line Width) [km s!U-1!N]',ytitle='log(Luminosity) [K km s!U-1!N]'
X =  -(findgen(10.)/(10d))+0.7
oplot,X, X * b[0] +a[0]
fit='Y='+string(b[0],format='(f5.2)')+'X'+string(a[0],format='(f5.2)')+' (c.c='+string(cor,format='(f5.2)')+')'
legend,[fit],box=0,charsize=1.8,charthick=2,/top
device,/close_file
;;;;;;radius_13  ----- luminosity_13
set_plot,'ps'
device,filename='/data3/w3_2011/ps/r13_l13.eps',/encapsulated
device,/portrait
cor=correlate(alog10(r13),alog10(L13))
sixlin,alog10(r13),alog10(L13),a,siga,b,sigb
print,string(a[0],format='(f5.2)')
plotsym,0
plot,alog10(r13),alog10(L13),psym=8,xtitle='log(Radius) [pc]',ytitle='log(Luminosity) [K km s!U-1!N]'
X =  -(findgen(12.)/(10d))+0.1
oplot,X, X * b[0] +a[0]
fit='Y='+string(b[0],format='(f5.2)')+'X+'+string(a[0],format='(f5.2)')+' (c.c='+string(cor,format='(f5.2)')+')'
legend,[fit],box=0,charsize=1.8,charthick=2,/top
device,/close_file
;;;;;;;
;;;;;;LTE mass_13  ----- Viral mass_13
set_plot,'ps'
device,filename='/data3/w3_2011/ps/m13_mv13.eps',/encapsulated
device,/portrait
cor=correlate(alog10(M13),alog10(Mv13))
sixlin,alog10(M13),alog10(Mv13),a,siga,b,sigb
print,string(a[0],format='(f5.2)')
plotsym,0
plot,alog10(M13),alog10(Mv13),psym=8,xtitle='log(LTE mass) [M'+sunsymbol()+']',ytitle='log(Virial mass) [M'+sunsymbol()+']'
X =  (findgen(30)/(10d))+0.5
oplot,X, X * b[0] +a[0]
fit='Y='+string(b[0],format='(f5.2)')+'X +'+string(a[0],format='(f5.2)')+' (c.c='+string(cor,format='(f5.2)')+')'
legend,[fit],box=0,charsize=1.8,charthick=2,/top
device,/close_file
;;;;Tau13
set_plot,'ps'
device,filename='/data3/w3_2011/ps/tau13.eps',/encapsulated
device,/portrait
plothist,Tau13,bin=0.2,/fill,/fline,/boxplot,forient=45;,xrange=[0.05,0.35],xstyle=1,yrange=[0,17000],ystyle=1,thick=2,charthick=2,xthick=2,ythick=2,xtitle='rms',ytitle='Number',charsize=1.4
device,/close_file
;;;;N13
set_plot,'ps'
device,filename='/data3/w3_2011/ps/colum13.eps',/encapsulated
device,/portrait
plothist,alog10(Num13),bin=0.2,/fill,/fline,/boxplot,forient=45;,xrange=[0.05,0.35],xstyle=1,yrange=[0,17000],ystyle=1,thick=2,charthick=2,xthick=2,ythick=2,xtitle='rms',ytitle='Number',charsize=1.4
device,/close_file
;;;;line width 12CO;;;
;;;;;;;;;;;;;;;;;;;;;;
set_plot,'ps'
device,filename='/data3/w3_2011/ps/lw13.eps',/encapsulated
device,/portrait
plothist,2.35*s3_13/1000.,bin=0.2,/fill,/fline,/boxplot,forient=45,xrange=[0,5],xstyle=1;,yrange=[0,12],ystyle=1;,thick=2,charthick=2,xthick=2,ythick=2,xtitle='rms',ytitle='Number',charsize=1.4
device,/close_file
;;;;;;;;;;;;;;
set_plot,'ps'
device,filename='/data3/w3_2011/ps/r13.eps',/encapsulated
device,/portrait
plothist,r13,bin=0.2,/fill,/fline,/boxplot,forient=45;,yrange=[0,12],ystyle=1;,thick=2,charthick=2,xthick=2,ythick=2,xtitle='rms',ytitle='Number',charsize=1.4
device,/close_file
;;;;;;;;
;;;;M13
set_plot,'ps'
device,filename='/data3/w3_2011/ps/m13.eps',/encapsulated
device,/portrait
plothistlog,alog10(M13),xhis,yhis,bin=0.2,/fill,/fline,/boxplot,forient=45,xrange=[0.2,3.6],xstyle=1,yrange=[0,1.7],ystyle=1;,thick=2,charthick=2,xthick=2,ythick=2,xtitle='rms',ytitle='Number',charsize=1.4
o=where(xhis ge 1.5)
r=linfit(xhis[o],yhis[o],yfit=b)
oplot,xhis[o],b
device,/close_file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;
;;;;radius_18   ----  linewidth_18   
set_plot,'ps'
device,filename='/data3/w3_2011/ps/r18_fwhm18.eps',/encapsulated
device,/portrait
cor=correlate(alog10(r18),alog10(2.35*(s3_18)/1000d))
sixlin,alog10(r18[*]),alog10((2.35d*s3_18)/1000d),a,siga,b,sigb
plotsym,0
plot,alog10(r18),alog10((2.35d*s3_18)/1000d),psym=8,xtitle='log(Radius) [pc]',ytitle='log(Line width) [km s!U-1!N]',xrange=[-1.2,0.4],yrange=[-1,1],xstyle=1,ystyle=1
print,string(a[0],format='(f5.2)')
X =  -(findgen(10.)/(10d))+0.1
;oplot,X, X * b[0] +a[0]
;fit='Y='+string(b[0],format='(f5.2)')+'X+'+string(a[0],format='(f5.2)')+' (c.c='+string(cor,format='(f5.2)')+')'
;legend,[fit],box=0,charsize=1.8,charthick=2,/top
device,/close_file
;;;;;;;;;linewidth_18  -----  luminosity_18 
set_plot,'ps'
device,filename='/data3/w3_2011/ps/fwhm18_l18.eps',/encapsulated
device,/portrait
cor=correlate(alog10((2.35d*s3_18)/1000d),alog10(L18))
sixlin,alog10((2.35d*s3_18)/1000d),alog10(L18[*]),a,siga,b,sigb
plotsym,0
plot,alog10(2.35d*s3_18/1000d),alog10(L18),psym=8,xtitle='log(Line Width) [km s!U-1!N]',ytitle='log(Luminosity) [K km s!U-1!N]'
X =  -(findgen(18.)/(10d))+1.2
oplot,X, X * b[0] +a[0]
fit='Y='+string(b[0],format='(f5.2)')+'X'+string(a[0],format='(f5.2)')+' (c.c='+string(cor,format='(f5.2)')+')'
legend,[fit],box=0,charsize=1.8,charthick=2,/top
device,/close_file
;;;;;;radius_18  ----- luminosity_18
set_plot,'ps'
device,filename='/data3/w3_2011/ps/r18_l18.eps',/encapsulated
device,/portrait
cor=correlate(alog10(r18),alog10(L18))
sixlin,alog10(r18),alog10(L18),a,siga,b,sigb
print,string(a[0],format='(f5.2)')
plotsym,0
plot,alog10(r18),alog10(L18),psym=8,xtitle='log(Radius) [pc]',ytitle='log(Luminosity) [K km s!U-1!N]'
X =  -(findgen(13.)/(10d))+0.2
oplot,X, X * b[0] +a[0]
fit='Y='+string(b[0],format='(f5.2)')+'X+'+string(a[0],format='(f5.2)')+' (c.c='+string(cor,format='(f5.2)')+')'
legend,[fit],box=0,charsize=1.8,charthick=2,/top
device,/close_file
;;;;;;;
;;;;;;LTE mass_18  ----- Viral mass_18
set_plot,'ps'
device,filename='/data3/w3_2011/ps/m18_mv18.eps',/encapsulated
device,/portrait
cor=correlate(alog10(M18),alog10(Mv18))
sixlin,alog10(M18),alog10(Mv18),a,siga,b,sigb
print,string(a[0],format='(f5.2)')
plotsym,0
plot,alog10(M18),alog10(Mv18),psym=8,xtitle='log(LTE mass) [M'+sunsymbol()+']',ytitle='log(Virial mass) [M'+sunsymbol()+']'
X =  (findgen(30)/(10d))+1.15
oplot,X, X * b[0] +a[0]
fit='Y='+string(b[0],format='(f5.2)')+'X '+string(a[0],format='(f5.2)')+' (c.c='+string(cor,format='(f5.2)')+')'
legend,[fit],box=0,charsize=1.8,charthick=2,/top
device,/close_file
;;;;Tau18
set_plot,'ps'
device,filename='/data3/w3_2011/ps/tau18.eps',/encapsulated
device,/portrait
plothist,Tau18,bin=0.1,/fill,/fline,/boxplot,forient=45;,xrange=[0.05,0.35],xstyle=1,yrange=[0,17000],ystyle=1,thick=2,charthick=2,xthick=2,ythick=2,xtitle='rms',ytitle='Number',charsize=1.4
device,/close_file
;;;;N18
set_plot,'ps'
device,filename='/data3/w3_2011/ps/colum18.eps',/encapsulated
device,/portrait
plothist,alog10(Num18),bin=0.2,/fill,/fline,/boxplot,forient=45,yrange=[0,12],ystyle=1;,thick=2,charthick=2,xthick=2,ythick=2,xtitle='rms',ytitle='Number',charsize=1.4
device,/close_file

;;;;;;;;
set_plot,'ps'
device,filename='/data3/w3_2011/ps/r18.eps',/encapsulated
device,/portrait
plothist,r18,bin=0.2,/fill,/fline,/boxplot,forient=45,yrange=[0,12],ystyle=1;,thick=2,charthick=2,xthick=2,ythick=2,xtitle='rms',ytitle='Number',charsize=1.4
device,/close_file
;;;;;;;;;;;;;
set_plot,'ps'
device,filename='/data3/w3_2011/ps/lw18.eps',/encapsulated
device,/portrait
plothist,2.35*s3_18/1000.,bin=0.2,/fill,/fline,/boxplot,forient=45,xrange=[0,5],xstyle=1,yrange=[0,12],ystyle=1;,thick=2,charthick=2,xthick=2,ythick=2,xtitle='rms',ytitle='Number',charsize=1.4
device,/close_file
;;;;;;;;
;;;;;;;;
;;;;M18
set_plot,'ps'
device,filename='/data3/w3_2011/ps/m18.eps',/encapsulated
device,/portrait
plothistlog,alog10(M18),xhis,yhis,bin=0.2,/fill,/fline,/boxplot,forient=45,xrange=[0.3,3.6],xstyle=1,yrange=[0,1.5],ystyle=1;,thick=2,charthick=2,xthick=2,ythick=2,xtitle='rms',ytitle='Number',charsize=1.4
o=where(xhis ge 2.1)
r=linfit(xhis[o],yhis[o],yfit=b)
oplot,xhis[o],b
device,/close_file
;;;;;;;;;;;;;
print,mean(2.35*size3/1000.),mean(2.35*s3_13/1000.),mean(2.35*s3_18/1000.)
end
