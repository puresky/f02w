;+
;  :Description:
;    Basic analysis for an sky region of interest:
;    1) Probability Density Function Profiles;
;    2) Sky Maps;
;    3) Objects' Masses;
;  :Syntax: 
;    @basic_analysis
;    Input :
;      3d (p-p-v) FITS files of CO three-line spectra data, 
;    Output:
;      ps files, fits files,
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
;    V0     2014-09-20         
;    V0.1   2014-09-20 
;    V1.0 
;
;-
;
;Comment Tags:
; http://www.exelisvis.com/docs/IDLdoc_Comment_Tags.html


set_plot, 'ps' &    device, xsize=21.0, ysize=29.7, /portrait, /encapsulated, /color           ; A4 sheet
P_former = !P & X_former = !X & Y_former =!Y
!P.charsize=1.6 & !P.charthick=3 & !P.thick=3
!X.thick=3 & !Y.thick=3
!X.margin=[8,8] &  !Y.margin=[4,4] 
!Y.omargin = [1,0]
forward_function mean
.compile pdf_plot
 
RegionName = 'NGC 2264'
distance = 760 ; pc
RegionDistance = distance

Tmb_12CO_rms = 0.440401  ; 0.72 K
Tmb_13CO_rms = 0.237389  ; 0.46
Tmb_C18O_rms = 0.242055  ; 0.46
print, '3 Tmb_12CO_rms = ', 3*Tmb_12CO_rms
print, '3 Tmb_13CO_rms = ', 3*Tmb_13CO_rms
print, '3 Tmb_C18O_rms = ', 3*Tmb_C18O_rms
dv_12CO = 0.160          ; km/s
dv_13CO = 0.168
dv_C18O = 0.168
print, Format='("Channel Width: 12CO ",F0,"  13CO ",F0,"  C18O ",F0)', dv_12CO, dv_13CO, dv_C18O

;;;;Reducing Data
;tpeak,"ngc226412cofinal.fits", outfile="Tpeak_12CO.fits",v_range = [-35,75], velocity_file='Vpeak_12CO.fits'
;tpeak,"ngc226413cofinal.fits", outfile="Tpeak_13CO.fits",v_range = [-20,60], velocity_file='Vpeak_13CO.fits'
;tpeak,"ngc2264c18ofinal.fits", outfile="Tpeak_C18O.fits",v_range = [-10,20], velocity_file='Vpeak_C18O.fits'

;;;;Analysing Data
;Read in Data:
    fits_read, "tpeak_12CO.fits", Tpeak_12CO, Tpeak12Hdr
    fits_read, "tpeak_13CO.fits", Tpeak_13CO, Tpeak13Hdr
    fits_read, "tpeak_C18O.fits", Tpeak_C18O, Tpeak18Hdr
    fits_read, "Tex.fits", Tex, TexHdr
    fits_read, "Tfwhm_12CO.fits", Vfwhm_12CO, Vfwhm12Hdr
    fits_read, "Tfwhm_13CO.fits", Vfwhm_13CO, Vfwhm13Hdr
    fits_read, "Tfwhm_C18O.fits", Vfwhm_C18O, Vfwhm18Hdr
    fits_read, "Vcenter_12CO.fits", Vc_12CO, VcData12Hdr
    fits_read, "Vcenter_13CO.fits", Vc_13CO, VcData13Hdr
    fits_read, "Vcenter_C18O.fits", Vc_C18O, VcData18Hdr
    fits_read, "tau_13CO.fits", tau_13CO, tau13Hdr
    fits_read, "tau_C18O.fits", tau_C18O, tau18Hdr

;Data Mask:
    mask_data = Tpeak_12CO
    mask_data[where(Tpeak_12CO lt 42.7905, count, complement=c_indices,ncomplement=c_count)]=1
    mask_data[c_indices]=0
    help, mask_data
    if !D.window ge 0 then Wshow &  tvscl, mask_data

;Date basic information:
    print, 'T peak above 3 sigma:'
    help, where(Tpeak_12CO ge 3*Tmb_12CO_rms and mask_data, count)
    help, where(Tpeak_13CO ge 3*Tmb_13CO_rms and mask_data, count)
    help, where(Tpeak_C18O ge 3*Tmb_C18O_rms and mask_data, count)
    print, 'FWHM-V width above channel width:'
    help, where(Vfwhm_12CO ge dv_12CO and mask_data, count)
    help, where(Vfwhm_13CO ge dv_13CO and mask_data, count)
    help, where(Vfwhm_C18O ge dv_C18O and mask_data, count)
    print, 'FWHM-V center confined in region:'
    help, where(Vc_12CO gt -30 and Vc_12CO lt 75 and mask_data, count)
    help, where(Vc_13CO gt -30 and Vc_13CO lt 75 and mask_data, count)
    help, where(Vc_C18O gt -30 and Vc_C18O lt 75 and mask_data, count)
    print, 'T peak, Optical thin lager than Optical thick:'
    help, where(Tpeak_13CO gt Tpeak_12CO and mask_data, count)
    help, where(Tpeak_C18O gt Tpeak_12CO and mask_data, count)
;    print, 'tau finite'



;print, 'Tpeak 12CO map'
;    fits_read, 'tpeak_12CO.fits', data, hdr
;    device, filename='Tpeak_12CO.eps',/encapsulated
;        cgimage,data,/keep_aspect, position = pos
;    device, /close_file

;print,"Tpeak 12CO Histogram"
;    fits_read,"tpeak_12CO.fits",data,hdr
;    validdata=data[where(data lt 42.7905, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    noiselevel = 3 * Tmb_12CO_rms
;    signaldata = validdata(where(validdata ge noiselevel))
;    help, signaldata
;    image_statistics, signaldata, data_sum=data_sum, maximum=data_max, mean=data_mean, minimum=data_min
;    print,'Above 3 sigma statistics:	sum	max	min 	mean', data_sum, data_max, data_min, data_mean
;
;    !P.multi = [1,1,2] & !Y.OMARGIN=[1,0]
;        device,filename='tpeak_12CO_his.eps',/encapsulated
;        device,xsize=21.0,ysize=29.7,/portrait
;        logdata=alog(signaldata/data_mean)
;        binsize=0.1 & xrange =[-2,3] & yrange =[3e-4,3]
;        Nsamples=n_elements(logdata)
;        yhist = cgHistogram(logdata, binsize=binsize, min=alog(noiselevel/data_mean), locations=xhist, /frequency)/binsize
;        xhist = xhist + 0.5*binsize
;        peak = max(yhist,max_subscript)
;        yfit = GaussFit(xhist[0:11], yhist[0:11], coeff, NTERMS=3, chisq=chisquare)
;        print, 'peak =', peak, '    peak_subscript =', max_subscript
;        print, 'A, mu, sigma:', coeff & print, 'chi square =',chisquare
;        cgPlot, [xhist[0]-binsize,xhist,max(xhist)+binsize], [0,yhist,0] $
;              , psym=10, xstyle=9, ystyle=9 $
;              , xtitle=textoidl('ln(T_{peak}/<T_{peak}>)'), ytitle='P(s)' $
;              , /ylog, xrange=xrange, yrange=yrange, ytickformat='logticks_exp'
;        cgColorFill, [xrange[0]*[1,1],alog(noiselevel/data_mean)*[1,1]],[yrange,reverse(yrange)], color='grey'
;        cgOplot, xhist, yfit, color='green'
;        cgPlots, [1,1]*alog(noiselevel/data_mean),yrange,linestyle=2
;        cgAxis,xaxis=0,xstyle=1
;        cgAxis,xaxis=1,xstyle=1, xrange=exp(xrange)*data_mean, /xlog
;        cgText, mean(!X.Window), 0.48, /normal, alignment=0.5 $
;              , textoidl('T_{peak} [K]')
;        cgAxis,yaxis=0,ystyle=1, ytickformat='logticks_exp', yrange=yrange
;        cgAxis,yaxis=1,ystyle=1, ytickformat='logticks_exp', yrange=yrange*Nsamples*binsize, ytitle=textoidl('Number of Pixels per bin')
;        cgText, mean(!X.window), 0.52, /normal, alignment=0.5   , charsize=2 $
;              , 'T!Ipeak !N!E12!NCO PDF of NGC 2264'
;        cgText, [[0.25],[0.75]]#!X.Window, [[0.15],[0.85]]#!Y.Window, /normal, textoidl('\sigma = ')+string(coeff[2], format='(f0.2)')
;    device,/close_file

;print,'Velocity of Tpeak 12CO Histogram'
;    fits_read,'tpeak.fits',Tpeak,TpHdr
;    fits_read,'Vpeak_12CO.fits',Vpeak,VpHdr
;    Vpeak_valid=Vpeak[where(Tpeak gt 3*Tmb_12CO_rms and Tpeak lt 42.7905)]
;    help,Vpeak_valid
;    image_statistics, Vpeak_valid, data_sum=sum, maximum=max, mean=mean, minimum=min &    print,sum,max,min,mean
;    fits_read,'Vcenter_12CO.fits',Vgauss,VgHdr
;    fits_read,'Tfwhm_12CO.fits',FWHM,FwhmHdr
;    Vgauss_valid=Vgauss[where(Vgauss gt -35 and Vgauss lt 75 and FWHM gt 0.158 and FWHM lt 110 and Tpeak lt 42.7905)]
;    help,Vgauss_valid
;    image_statistics, Vgauss_valid, data_sum=sum, maximum=max, mean=mean, minimum=min &    print,sum,max,min,mean
;    fits_read,'ngc226412cofinal_m1.fits',Vmoment,VmHdr
;    Vmoment_1_valid=Vmoment[where(Vmoment gt -35 and Vmoment lt 75 and Tpeak lt 42.7905)]
;    help,Vmoment_1_valid
;    image_statistics, Vmoment_1_valid, data_sum=sum, maximum=max, mean=mean, minimum=min &    print,sum,max,min,mean
;print,'Line Width 12CO Histogram'
;    fits_read,'tpeak.fits',Tpeak,TpHdr
;    fits_read,'Tfwhm_12CO.fits',FWHM,FwhmHdr
;    FWHM_valid=FWHM[where(Vgauss gt -35 and Vgauss lt 75 and FWHM gt 0.158 and FWHM lt 110 and Tpeak lt 42.7905)]
;    help,FWHM_valid
;    image_statistics, FWHM_valid, data_sum=sum, maximum=max, mean=mean, minimum=min &    print,sum,max,min,mean
;    fits_read,'ngc226412cofinal_m2.fits',Vmoment,VmHdr
;    Vmoment_2_valid=Vmoment[where(Tpeak gt 3*Tmb_12CO_rms and Tpeak lt 42.7905 and finite(Vmoment))]
;    help,Vmoment_2_valid
;    image_statistics, Vmoment_2_valid, data_sum=sum, maximum=max, mean=mean, minimum=min &    print,sum,max,min,mean
; 
;    pson & !P.multi = [0,1,2] & !Y.OMARGIN=[1,0]
;        device,filename='velocity_his.eps',/encapsulated
;        device,xsize=21.0,ysize=29.7,/portrait
;        binsize=0.4 & xrange=[-45,85] & yrange=[10,5e4]
;        cgPlot, xhist, yhist,/nodata,xstyle=1,ystyle=9$
;              , charsize=1.4,title='V !E12!NCO PDF of NGC 2264',xtitle='V (km/s)', ytitle=textoidl('Number of Pixels per bin') $
;              , /ylog,xrange=xrange,yrange=yrange
;        plothist,Vpeak_valid,xhist,yhist,bin=binsize, color='green', /overplot;,/noplot
;        Nsamples=n_elements(Vpeak_valid)/1.0
;        yhist = yhist/Nsamples/binsize
;;        yfit = gaussfit(alog(xhist),yhist*xhist,coeff,chisq=chisquare,nterms=3)/xhist
;;        print, 'A, mu, sigma:', coeff & print, 'A*sqrt(2*!pi)*sigma =', coeff[0]*sqrt(2*!pi)*coeff[2] & print, 'chi square=',chisquare
;        !P.multi[0] = 2
;        !X.margin=[8,8] &  !Y.margin=[4,4]
;;        cgColorFill, [-5,-5,noiselevel,noiselevel],[yrange,reverse(yrange)], color='grey'
;        peak = max(yhist,max_subscript)
;        print, 'peak =', peak, '   peak_subscript =', max_subscript 
;;        plothist, Vpeak_valid, bin=binsize, peak=peak, charsize=1.4,charthick=2,xthick=2,ythick=2 $
;;                , color='green', /overplot
;        plothist, Vgauss_valid, bin=binsize, xhist,yhist,color='magenta',/overplot;,/noplot
;        Nsamples=n_elements(Vgauss_valid)/1.0
;        peak=max(yhist,max_subscript)/Nsamples/binsize
;        print, 'peak =', peak, '   peak_subscript =', max_subscript 
;;        plothist, Vgauss_valid, bin=binsize,peak=peak, color='ivory',/overplot
;        plothist, Vmoment_1_valid,bin=binsize, xhist,yhist,color='blue',/overplot;,/noplot
;        Nsamples=n_elements(Vmoment_1_valid)/1.0
;        peak=max(yhist,max_subscript)/Nsamples/binsize
;        print, 'peak =', peak, '   peak_subscript =', max_subscript 
;;        plothist, Vmoment_1_valid,bin=binsize,peak=peak, color='blue',/overplot
;;        cgOplot,xhist,yfit,color='green'
;        cgLegend, Title=['Peak','Gauss Fit', 'Moment 1'], charsize=1.0 $
;;                , PSym=[-15,-15,-15], SymSize=1 $
;                , Location=[60,3e4],/Data, Alignment=4 $
;                , Color=['green','magenta','blue'], /Box
;        cgAxis,xaxis=0,xstyle=1,charsize=1.4, xrange=xrange
;        cgAxis,xaxis=1,xstyle=1,charsize=0.01
;        cgAxis,yaxis=0,ystyle=1,charsize=1.4, yrange=yrange
;        cgAxis,yaxis=1,ystyle=1,charsize=1.4, yrange=yrange;*Nsamples*binsize
;;        cgplots,[1,1]*noiselevel, [1e-5,1],linestyle=2
;;        cgtext,noiselevel,2e5,'W!ICO!N(3 sigma)',charsize=1
;;        cgText, 40, 1e-1, 'N = 120000', color='navy', charsize=1.5
;;        cgText, 40, 3e-2, cggreek('sigma')+' ='+string(noiselevel/3.0,Format='(F10.2)'), color='navy', charsize=1.5
;        binsize=0.2 &         xrange =[-3,15] & yrange =[1,1e5]
;        !P.multi[0] = 1
;        cgPlot, xhist, yhist, /nodata, xstyle=1, ystyle=8 $
;              , charsize=1.4, title=textoidl('\Delta V ^{12}CO PDF of NGC 2264'),xtitle='Log(V/[km/s])',ytitle='Number of Pixels per bin' $
;              , /ylog,xrange=xrange,yrange=yrange
;        plothist,Vmoment_2_valid,xhist,yhist,bin=binsize,color='blue', /overplot;,/noplot
;        Nsamples=n_elements(Vmoment_2_valid)/1.0
;        yhist= yhist/Nsamples/binsize
;        peak = max(yhist,max_subscript)
;        print, 'peak =', peak, '    peak_subscript =', max_subscript
;;        yfit = GaussFit(xhist[0:18], yhist[0:18], coeff, NTERMS=3, chisq=chisquare)
;;        print, 'A, mu, sigma:', coeff & print, 'chi square =',chisquare
;       ; !x.margin=[8,8] & !y.margin=[4,4]
;;        cgColorFill, [xrange[0],xrange[0],alog10(noiselevel),alog10(noiselevel)],[yrange,reverse(yrange)], color='grey'
;        plothist, FWHM_valid, xhist, yhist, bin=binsize, charsize=1.4,charthick=2,xthick=2,ythick=2 $
;                , /overplot, color='magenta'
;        print, 'peak =', max(yhist,max_subscript)/binsize/n_elements(FWHM_valid),'    peak_subscript =', max_subscript
;;        cgOplot, xhist, yfit,color='green'
;;        cgplots,[1,1]*alog10(noiselevel),yrange,linestyle=2
;        cgAxis,xaxis=0,xstyle=1,charsize=1.4
;        cgAxis,xaxis=1,xstyle=1,charsize=0.01
;        cgAxis,yaxis=0,ystyle=1,charsize=1.4, yrange=yrange
;        cgAxis,yaxis=1,ystyle=1,charsize=1.4, yrange=yrange;*120000d*binsize, ytitle=textoidl('Number of Pixels per log bin')
;
;        cgLegend, Title=['Gauss Fit', 'Moment 2'], charsize=1.0 $
;;                , PSym=[-15,-15], SymSize=1, LineStyle=[0,2] $
;                , Color=['magenta','blue'], /Center_Sym $
;                , VSpace=2.0, /Box, Alignment=4, Location=[12,5e4], /Data 
;;        cgtext,noiselevel,2e5,'3 sigma',charsize=1
;        device,/close_file
;    psoff & !P.multi=0 & !Y.OMARGIN=[0,0]

;print,"Tpeak 13CO Histogram"
;    fits_read,"tpeak_13CO.fits",data,hdr
;    validdata=data[where(data lt 16.74136, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    noiselevel = 3 * Tmb_13CO_rms
;    signaldata = validdata(where(validdata ge noiselevel))
;    help, signaldata
;    image_statistics, signaldata, data_sum=data_sum, maximum=data_max, mean=data_mean, minimum=data_min
;    print,'Above 3 sigma statistics:	sum	max	min 	mean', data_sum, data_max, data_min, data_mean
;    !P.multi = [1,1,2] & !Y.OMARGIN=[1,0] 
;    device,filename='tpeak_13CO_his.eps',/encapsulated
;;        device,xsize=21.0,ysize=29.7,/portrait            ; A4 sheet
;        logdata=alog(signaldata/data_mean)
;        binsize=0.1 &         xrange =[-2,3.5] & yrange =[3e-5,10]
;        Nsamples=n_elements(logdata)
;        yhist = cgHistogram(logdata, binsize=binsize, min=alog(noiselevel/data_mean), locations=xhist, /frequency)/binsize
;        xhist = xhist + 0.5*binsize
;        peak = max(yhist,max_subscript)
;        yfit = GaussFit(xhist, yhist, coeff, NTERMS=3, chisq=chisquare)
;        print, 'peak =', peak, '    peak_subscript =', max_subscript
;        print, 'A, mu, sigma:', coeff & print, 'chi square =',chisquare
;        cgPlot, [xhist[0]-binsize, xhist, max(xhist)+binsize], [0,yhist,0] $
;              , psym=10, xstyle=9, ystyle=9 $
;              , xtitle=textoidl('ln(T_{peak}/<T_{peak}>)'), ytitle='P(s)' $
;              , /ylog,xrange=xrange,yrange=yrange, ytickformat='logticks_exp'
;        cgColorFill, [xrange[0],xrange[0],alog(noiselevel/data_mean)*[1,1]],[yrange,reverse(yrange)], color='grey'
;        cgOplot, xhist, yfit,color='green'
;        cgplots,[1,1]*alog(noiselevel/data_mean),yrange,linestyle=2
;        cgAxis,xaxis=0,xstyle=1
;        cgAxis,xaxis=1,xstyle=1, xrange=exp(xrange)*data_mean, /xlog
;        cgText, mean(!X.Window), 0.48, /normal, alignment=0.5 $
;              , textoidl('T_{peak} [K]')
;        cgAxis,yaxis=0,ystyle=1, ytickformat='logticks_exp', yrange=yrange
;        cgAxis,yaxis=1,ystyle=1, ytickformat='logticks_exp', yrange=yrange*Nsamples*binsize, ytitle=textoidl('Number of Pixels per bin')
;        cgText, mean(!X.Window), 0.52, /normal,alignment=0.5, charsize=2 $
;              , 'T!Ipeak !N!E13!NCO PDF of NGC 2264'
;        cgText,  [[0.25],[0.75]]#!X.Window, [[0.15],[0.85]]#!Y.Window, /normal, textoidl('\sigma = ')+string(coeff[2], format='(f0.2)')
;    device,/close_file 

;print,"Tpeak C18O Histogram"
;    fits_read,"tpeak_C18O.fits",data,hdr
;    validdata=data[where(data lt 10.1618, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    noiselevel = 3 * Tmb_C18O_rms
;    signaldata = validdata(where(validdata ge noiselevel))
;    help, signaldata
;    image_statistics, signaldata, data_sum=data_sum, maximum=data_max, mean=data_mean, minimum=data_min
;    print,'Above 3 sigma statitics:    sum    max    min    mean', data_sum, data_max, data_min, data_mean
;    !P.multi = [1,1,2] ;& !Y.OMARGIN=[1,0] & !x.margin=[8,8] & !y.margin=[4,4]
;    device,filename='tpeak_C18O_his.eps',/encapsulated
;;        device,xsize=21.0,ysize=29.7,/portrait            ; A4 sheet
;        logdata=alog(signaldata/data_mean)  
;        binsize=0.1 &         xrange =[-1.5,2.5] & yrange =[3e-5,10]
;        Nsamples=n_elements(logdata)
;        yhist = cgHistogram(logdata, binsize=binsize, min=alog(noiselevel/data_mean), locations=xhist, /frequency)/binsize
;        xhist = xhist + 0.5*binsize
;        peak = max(yhist,max_subscript)
;;        yfit = GaussFit(xhist[0:10], yhist[0:10], coeff, NTERMS=3, chisq=chisquare)
;        yfit = GaussFit(xhist, yhist, coeff, NTERMS=3, chisq=chisquare)
;        print, 'peak =', peak, '    peak_subscript =', max_subscript
;        print, 'A, mu, sigma:', coeff & print, 'chi square =',chisquare
;        cgPlot, [xhist[0]-binsize, xhist, max(xhist)+binsize], [0, yhist, 0] $
;              , psym=10, xstyle=9, ystyle=9 $
;              , xtitle=textoidl('ln(T_{peak}/<T_{peak}>)'),ytitle='P(s)' $
;              , /ylog,xrange=xrange,yrange=yrange, ytickformat='logticks_exp'
;        cgColorFill, [xrange[0],xrange[0],alog(noiselevel/data_mean)*[1,1]],[yrange,reverse(yrange)], color='grey'
;        cgOplot, xhist, yfit,color='green'
;        cgplots,[1,1]*alog(noiselevel/data_mean),yrange,linestyle=2
;        cgAxis, xaxis=0,xstyle=1,charsize=1.4
;        cgAxis, xaxis=1,xstyle=1,charsize=1.4, xrange=exp(xrange)*data_mean,xlog=1
;        cgText, mean(!X.Window), 0.48, /normal, alignment=0.5 $
;              , 'T!Ipeak !N[K]'
;        cgAxis, yaxis=0,ystyle=1,charsize=1.4, ytickformat='logticks_exp', yrange=yrange
;        cgAxis, yaxis=1,ystyle=1,charsize=1.4, ytickformat='logticks_exp', yrange=yrange*Nsamples*binsize, ytitle=textoidl('Number of Pixels per bin')
;        cgText, mean(!X.Window), 0.52, /normal, alignment=0.5, charsize=2 $
;              , 'T!Ipeak!N C!E18!NO PDF of NGC 2264'
;;        cgText, xrange[1]-1.5, yrange[1]/10.0, textoidl('\sigma = 0.37')
;        cgText, [[0.25],[0.75]]#!X.Window, [[0.15],[0.85]]#!Y.Window, /normal, textoidl('\sigma = ')+string(coeff[2], format='(f0.2)')
;    device,/close_file





;print,'12CO rms Histogram'
;    rdfloat,'ngc226412cofinal.bas_rms.dat',line12CO,ra12CO,dec12CO,rms12CO
;    print,max(rms12CO),min(rms12CO),mean(rms12CO)
;    print,mean(rms12CO(where(ra12CO gt -1000 and ra12CO lt 1000 and dec12CO gt -1000 and dec12CO lt 6000))) 
;    device,filename='rms_12CO_his.eps',/encapsulated
;        plothist,rms12CO,bin=0.02,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='!E12!NCO rms PDF',xtitle='T!Irms !N(K)',ytitle='Number'$
;               ,/ylog,xrange=[0,3],yrange=[0.5,2e5]
;        cgplots,[0.44,0.44],[0.5,2e4],linestyle=2
;        cgtext,0.440401,3e4,'0.46',charsize=1
;        cgplots,[0.72,0.72],[0.5,2e4],linestyle=2
;        cgtext,0.720845,3e4,'0.72',charsize=1
;    device,/close_file
;
;print, '13CO rms Histogram'
;    rdfloat,'ngc226413cofinal.bas_rms.dat',line13CO,ra13CO,dec13CO,rms13CO
;    print,max(rms13CO),min(rms13CO),mean(rms13CO)
;    print,mean(rms13CO(where(ra13CO gt -1000 and ra13CO lt 1000 and dec13CO gt -1000 and dec13CO lt 6000)))
;    device,filename='rms_13CO_his.eps',/encapsulated
;        plothist,rms13CO,bin=0.02,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='!E13!NCO rms PDF',xtitle='T!Irms !N(K)',ytitle='Number'$
;               ,/ylog,xrange=[0,3],yrange=[0.5,2e5]
;        cgplots,[0.24,0.24],[0.5,2e4],linestyle=2
;        cgtext,0.237389,3e4,'0.24',charsize=1
;        cgplots,[0.46,0.46],[0.5,2e4],linestyle=2
;        cgtext,0.457899,3e4,'0.46',charsize=1
;    device,/close_file
;
;print, 'C18O rms Histogram'
;    rdfloat,'ngc2264c18ofinal.bas_rms.dat',line_C18O,ra_C18O,dec_C18O,rms_C18O
;    print,max(rms_C18O),min(rms_C18O),mean(rms_C18O)
;    print,mean(rms_C18O(where(ra_C18O gt -1000 and ra_C18O lt 1000 and dec_C18O gt -1000 and dec_C18O lt 6000)))
;    device,filename='rms_C18O_his.eps',/encapsulated
;        plothist,rms_C18O,bin=0.02,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='C!E18!NO rms PDF',xtitle='T!Irms !N(K)',ytitle='Number'$
;               ,/ylog,xrange=[0,3],yrange=[0.5,2e5]
;        cgplots,[0.24,0.24],[0.5,2e4],linestyle=2
;        cgtext,0.242055,3e4,'0.24',charsize=1
;        cgplots,[0.46,0.46],[0.5,2e4],linestyle=2
;        cgtext,0.459661,3e4,'0.46',charsize=1
;    device,/close_file


;tex,infile="Tpeak_12CO.fits",outfile="Tex.fits"

;print,"Tex Histogram: Tex_his.eps"
;    fits_read,"Tex.fits",data,hdr
;    validdata=data[where(data lt 46.3205, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    T0 = 5.53213817d   ;12CO(1-0) 
;    Tex_3rms = T0*(alog(1+T0/(3*Tmb_12CO_rms+0.819)))^(-1)  ; 4.4002
;    print, 'noise line derived from Tpeak: Tex(3rms) = ',Tex_3rms
;    noiselevel = Tex_3rms
;    signaldata=validdata[where(validdata ge noiselevel)]
;    help, signaldata
;    image_statistics, signaldata, data_sum=sum, maximum=data_max, mean=data_mean, minimum=data_min
;    print, 'Above 3 sigma statistics: sum     max     min     mean', data_sum, data_max, data_min, data_mean
;    !P.multi = [1,1,2] ;& !Y.OMARGIN=[1,0] & !x.margin=[8,8] & !y.margin=[4,4]
;    device,filename='Tex_his.eps',/encapsulated
;        logdata=alog(signaldata/data_mean)
;        binsize=0.05 &         xrange =[-1.5,2.5] & yrange =[1e-4,10]
;        Nsamples=n_elements(logdata)
;        yhist = cgHistogram(logdata, binsize=binsize, min=alog(noiselevel/data_mean),locations=xhist, /frequency)/binsize
;        xhist = xhist + 0.5*binsize
;        peak = max(yhist,max_subscript)
;        yfit = GaussFit(xhist[0:10], yhist[0:10], coeff, NTERMS=3, chisq=chisquare)
;;        yfit = GaussFit(xhist, yhist, coeff, NTERMS=3, chisq=chisquare)
;        print, 'peak =', peak, '    peak_subscript =', max_subscript
;        print, 'A, mu, sigma:', coeff & print, 'chi square =',chisquare
;        cgPlot, [xhist[0]-binsize, xhist, max(xhist)+binsize], [0, yhist, 0] $
;              , psym=10, xstyle=9, ystyle=9 $
;              , xtitle=textoidl('ln(T_{ex}/<T_{ex}>)'),ytitle='P(s)' $
;              , /ylog,xrange=xrange,yrange=yrange, ytickformat='logticks_exp'
;        cgColorFill, [xrange[0],xrange[0],alog(noiselevel/data_mean)*[1,1]],[yrange,reverse(yrange)], color='grey'
;        cgOplot, xhist, yfit,color='green'
;        cgPlots,[1,1]*alog(noiselevel/data_mean),yrange,linestyle=2
;        cgAxis,xaxis=0,xstyle=1,charsize=1.4
;        cgAxis,xaxis=1,xstyle=1,charsize=1.4, xrange=exp(xrange)*data_mean,xlog=1
;        cgText, mean(!X.Window), 0.48, /normal, alignment=0.5 $
;              , textoidl('T_{ex} [K]')
;        cgAxis,yaxis=0,ystyle=1, ytickformat='logticks_exp', yrange=yrange
;        cgAxis,yaxis=1,ystyle=1, ytickformat='logticks_exp', yrange=yrange*Nsamples*binsize, ytitle=textoidl('Number of Pixels per bin')
;        cgText, mean(!X.Window), 0.52, /normal, alignment=0.5, charsize=2 $
;             , textoidl('T_{ex} PDF of NGC 2264')
;        cgText, [[0.25],[0.75]]#!X.Window, [[0.15],[0.85]]#!Y.Window, /normal, textoidl('\sigma = ')+string(coeff[2],format='(f0.2)')
;    device,/close_file

;cubemoment, 'ngc226412cofinal.fits', [-10,40]
;cubemoment, 'ngc226413cofinal.fits', [-10,35]
;cubemoment, 'ngc2264c18ofinal.fits', [1,12]

;file_move,'ngc226412cofinal_m0.fits','Wco_12CO.fits'

;print,"Integrated Intensities Histogram: Int_12CO_his.eps"
;    fits_read,'12co_-10_40_int.fits',data,hdr
;    validdata=data[where(data lt 2146, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    noiselevel = 3 * Tmb_12CO_rms * sqrt(50*0.159)
;    signaldata = validdata[where(validdata ge noiselevel)]
;    help, signaldata
;    image_statistics, signaldata, data_sum=data_sum, maximum=data_max, mean=data_mean, minimum=data_min
;    print, 'Noise level: 3 sigma,', noiselevel 
;    print, 'Above 3 sigma statistics:  sum       max       min       mean'
;    print, '                   ', data_sum, data_max, data_min, data_mean
;    !P.multi = [1,1,2]; & !Y.OMARGIN=[1,0]          ; !x.margin=[8,8] & !y.margin=[4,4]
;    device,filename='Int_12CO_-10_40_his.eps',/encapsulated
;        pdf_plot,  validdata, noiselevel, /log $
;            , binsize=0.1 , xrange =[-3,4.0] , yrange =[1e-4,10] $
;            , title='!E12!NCO Integrated Intensities PDF of NGC 2264' $
;            , x_log_title=textoidl('ln(W_{CO}/<W_{CO})>)') $
;            , y_probability_title='P(s)' $
;            , x_natural_title='Integrated Intensities [K km s!E-1!N]' $
;            , y_count_title=textoidl('Number of Pixels per bin') $
;            , /fitting ;, fit_range=[]
;    device,/close_file
;
;print,"Integrated Intensities Histogram: Int_13CO_his.eps"
;    fits_read,'13co_-10_35_int.fits',data,hdr
;    validdata=data[where(data lt 756, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    noiselevel = 3*Tmb_13CO_rms*sqrt(45*0.167)
;    print, 'noise level: 3 sigma,', noiselevel
;    print, 'above noise: ', size(where(validdata gt noiselevel))
;    !P.multi = [1,1,2] & !Y.OMARGIN=[1,0]          ; !x.margin=[8,8] & !y.margin=[4,4]
;    device,filename='Int_13CO_-10_35_his.eps',/encapsulated
;        pdf_plot, validdata, noiselevel, /log $ 
;            , binsize=0.1 , xrange =[-3,4.0] , yrange =[1e-4,10] $
;            , title='!E13!NCO Integrated Intensities PDF of NGC 2264' $
;            , x_log_title=textoidl('ln(W_{CO}/<W_{CO}>)') $;,ytitle='P(s)' $
;            , x_natural_title='Integrated Intensities [K km s!E-1!N]' $;, ytitle='P(s)' $
;            , /fitting
;    device,/close_file
 

;            binsize=0.5 , xrange=[-25,65], yrange=[5e-6,1]
;        Nsamples=n_elements(validdata)
;        yhist = HISTOGRAM( validdata , BINSIZE=binsize, LOCATIONS=xhist, MIN=floor(min(validdata)) ) 
;        yhist = float(yhist)/Nsamples/binsize
;        peak = max(yhist,max_subscript)
;        print, 'peak =', peak, '   peak_subscript =', max_subscript
;        !P.multi[0] = 2
;        !X.margin=[8,8] &  !Y.margin=[4,4]
;        cgPlot, xhist,yhist,/nodata,xstyle=1,ystyle=9$
;              , charsize=1.4, charthick=2, xthick=2, ythick=2 $
;              , /ylog,xrange=xrange,yrange=yrange
;        cgColorFill, [xrange[0],xrange[0],noiselevel,noiselevel],[yrange,reverse(yrange)], color='grey'
;        plothist, validdata, bin=binsize, peak=peak, charsize=1.4,charthick=2,xthick=2,ythick=2 $
;                ,/overplot
;        
;        yhist = HISTOGRAM( validdata , BINSIZE=binsize, LOCATIONS=xhist, MIN=0 ) 
;        yhist = float(yhist)/Nsamples/binsize
;        xhist = xhist + binsize/2d
;;        yfit = gaussfit(alog(xhist[0:30]),(yhist*xhist)[0:30],coeff,chisq=chisquare,nterms=3)/xhist
;        yfit = gaussfit(alog(xhist),yhist*xhist,coeff,chisq=chisquare,nterms=3)/xhist
;
;        print, 'A, mu, sigma:', coeff & print, 'chi square=',chisquare
;        cgOplot,xhist,yfit,color='green'
;        cgAxis,xaxis=0,xstyle=1,charsize=1.4, xrange=xrange
;        cgAxis,xaxis=1,xstyle=1,charsize=0.01
;        cgAxis,yaxis=0,ystyle=1,charsize=1.4, yrange=yrange
;        cgAxis,yaxis=1,ystyle=1,charsize=1.4, yrange=yrange*Nsamples*binsize, ytitle=textoidl('Number of Pixels per bin')
;        cgplots,[1,1]*noiselevel, yrange, linestyle=2
;        logvaliddata=alog(validdata)
;        Nsamples=n_elements(logvaliddata)
;        plothist,logvaliddata,xhist,yhist,bin=binsize, /nan ,/noplot
;        yhist= float(yhist)/Nsamples/binsize
;        peak = max(yhist,max_subscript)
;;        yfit = GaussFit(xhist[0:10], yhist[0:10], coeff, NTERMS=3, chisq=chisquare)
;        yfit = GaussFit(xhist, yhist, coeff, NTERMS=3, chisq=chisquare)
;        print, 'peak =', peak, '    peak_subscript =', max_subscript
;        print, 'A, mu, sigma:', coeff & print, 'chi square =',chisquare
;        cgPlot, xhist, yhist, /nodata, xstyle=9, ystyle=9 $
;              , /ylog,xrange=xrange,yrange=yrange
;        cgColorFill, [xrange[0],xrange[0],alog(noiselevel),alog(noiselevel)],[yrange,reverse(yrange)], color='grey'
;        plothist, logvaliddata, bin=binsize, peak=peak, charsize=1.4,charthick=2,xthick=2,ythick=2 $
;                , /overplot, ystyle=1,yrange=yrange,/nan
;        cgOplot, xhist, yfit,color='green'
;        cgplots,[1,1]*alog(noiselevel),yrange,linestyle=2
;        cgAxis,xaxis=0,xstyle=1,charsize=1.4
;        cgAxis,xaxis=1,xstyle=1,charsize=1.4, xrange=exp(xrange),xlog=1, xtitle='Integrated Intensities (K km s!E-1!N)'
;        cgAxis,yaxis=0,ystyle=1,charsize=1.4, yrange=yrange
;        cgAxis,yaxis=1,ystyle=1,charsize=1.4, yrange=yrange*Nsamples*binsize, ytitle=textoidl('Number of Pixels per bin')
;
;print,"Integrated Intensities Histogram: Int_C18O_his.eps"
;    fits_read,'c18o_1_12_int.fits',data,hdr
;    validdata=data[where(data lt 113, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    noiselevel = 3 * Tmb_C18O_rms*sqrt(11*0.167)
;    print, 'noise level: 3 sigma,', noiselevel
;    print, 'above noise: ', size(where(validdata gt noiselevel))
;    !P.multi = [1,1,2] & !Y.OMARGIN=[1,0]          ; !x.margin=[8,8] & !y.margin=[4,4]
;    device,filename='Int_C18O_1_12_his.eps',/encapsulated
;        pdf_plot, validdata, noiselevel, /log $
;                , binsize=0.1, xrange =[-3,4.0], yrange =[1e-4,10] $
;                , title='C!E18!NO Integrated Intensities PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(W_{CO}/<W_{CO}>)') $ ;,ytitle='P(s)' $
;                , x_natural_title='Integrated Intensities [K km s!E-1!N]' $
;                , /fitting
;    device, /close_file
;        binsize=0.5 & xrange=[-10,15] & yrange=[5e-6,1]
;        Nsamples=n_elements(validdata)
;        yhist = HISTOGRAM( validdata , BINSIZE=binsize, LOCATIONS=xhist, MIN=floor(min(validdata)) ) 
;        yhist = float(yhist)/Nsamples/binsize
;        peak = max(yhist,max_subscript)
;        print, 'peak =', peak, '   peak_subscript =', max_subscript
;        yfit = gaussfit(xhist,yhist,coeff,chisq=chisquare,nterms=3)
;        !P.multi[0] = 2
;        !X.margin=[8,8] &  !Y.margin=[4,4]
;        cgPlot, xhist,yhist,/nodata,xstyle=1,ystyle=9$
;              , charsize=1.4, charthick=2, xthick=2, ythick=2 $
;              , title=,xtitle='Integrated Intensities (K km s!E-1!N)',ytitle='P(s)' $
;              , /ylog,xrange=xrange,yrange=yrange
;        cgColorFill, [xrange[0],xrange[0],noiselevel,noiselevel],[yrange,reverse(yrange)], color='grey'
;        cgOplot,xhist,yfit,color='blue' 
;        plothist, validdata, bin=binsize, peak=peak, charsize=1.4,charthick=2,xthick=2,ythick=2 $
;                ,/overplot
;        
;        yhist = HISTOGRAM( validdata , BINSIZE=binsize, LOCATIONS=xhist, MIN=0 ) 
;        yhist = float(yhist)/Nsamples/binsize
;        xhist = xhist + binsize/2d
;;        yfit = gaussfit(alog(xhist[0:30]),(yhist*xhist)[0:30],coeff,chisq=chisquare,nterms=3)/xhist
;        yfit = gaussfit(alog(xhist),yhist*xhist,coeff,chisq=chisquare,nterms=3)/xhist
;        print, 'A, mu, sigma:', coeff & print, 'chi square=',chisquare
;        cgOplot,xhist,yfit,color='green'
;        cgAxis,xaxis=0,xstyle=1,charsize=1.4, xrange=xrange
;        cgAxis,xaxis=1,xstyle=1,charsize=0.01
;        cgAxis,yaxis=0,ystyle=1,charsize=1.4, yrange=yrange
;        cgAxis,yaxis=1,ystyle=1,charsize=1.4, yrange=yrange*Nsamples*binsize, ytitle=textoidl('Number of Pixels per bin')
;        cgplots,[1,1]*noiselevel, yrange, linestyle=2
;        cgLegend, Title=['Log-normal', 'Normal'], charsize=1.0 $
;;                , PSym=[-15,-15], SymSize=1, LineStyle=[0,2] $
;                , Color=['green','blue'], /Center_Sym $
;                , VSpace=2.0, /Box, Alignment=4, Location=[9,0.5], /Data 
;        logvaliddata=alog(validdata)
;        Nsamples=n_elements(logvaliddata)
;        plothist,logvaliddata,xhist,yhist,bin=binsize, /nan ,/noplot
;        yhist= float(yhist)/Nsamples/binsize
;        peak = max(yhist,max_subscript)
;;        yfit = GaussFit(xhist[0:10], yhist[0:10], coeff, NTERMS=3, chisq=chisquare)
;        yfit = GaussFit(xhist, yhist, coeff, NTERMS=3, chisq=chisquare)
;        print, 'peak =', peak, '    peak_subscript =', max_subscript
;        print, 'A, mu, sigma:', coeff & print, 'chi square =',chisquare
;        cgPlot, xhist, yhist, /nodata, xstyle=9, ystyle=9 $
;              , /ylog,xrange=xrange,yrange=yrange
;        cgColorFill, [xrange[0],xrange[0],alog(noiselevel),alog(noiselevel)],[yrange,reverse(yrange)], color='grey'
;        plothist, logvaliddata, bin=binsize, peak=peak, charsize=1.4,charthick=2,xthick=2,ythick=2 $
;                , /overplot, ystyle=1,yrange=yrange,/nan
;        cgOplot, xhist, yfit,color='green'
;        cgplots,[1,1]*alog(noiselevel),yrange,linestyle=2
;        cgAxis,xaxis=0,xstyle=1,charsize=1.4
;        cgAxis,yaxis=0,ystyle=1,charsize=1.4, yrange=yrange
;        cgAxis,yaxis=1,ystyle=1,charsize=1.4, yrange=yrange*Nsamples*binsize, ytitle=textoidl('Number of Pixels per bin')


;fwhm, 'ngc226412cofinal.fits', outfile='fwhm_12CO.fits', v_center_file = 'Vcenter_12CO.fits', v_range = [-35,75],quality_file='Quality_fwhm_12CO.fits';, estimates=[1,5,1,0,0,0]
;fwhm, 'ngc226413cofinal.fits', outfile='fwhm_13CO.fits', v_center_file = 'Vcenter_13CO.fits', v_range = [-20,60]
;fwhm, 'ngc2264c18ofinal.fits', outfile='fwhm_C18O.fits', v_center_file = 'Vcenter_C18O.fits', v_range = [-10,20]

;print, 'FWHM Histogram: 12CO'
;    fits_read, "Tfwhm_12CO.fits", data, hdr
;    print,max(data),min(data),mean(data)
;    fits_read,"tpeak_12CO.fits", Tpeak, Tpeakhdr
;    fits_read,'Vcenter_12CO.fits',Vdata,Vhdr
;    print, Format='("Confined by 3*RMS, Velocity Range, and Above 0")'
;    help, where(Tpeak gt 3*Tmb_12CO_rms and mask_data, count)
;    help, where(Vdata gt -30 and Vdata lt 75, count)
;    help, where(data ge 0 and mask_data, count)
;    validdata=data[where(data ge 0 and Vdata gt -30 and Vdata lt 75 and Tpeak gt 3*Tmb_12CO_rms and mask_data, complement=c_indices)]
;    help,validdata
;    error_data=mask_data & error_data[c_indices]=0 & tvscl, error_data
;    print,max(validdata),min(validdata),mean(validdata)
;    threshold = dv_12CO
;    print, 'Above Threshold: ', size(where(validdata gt threshold)) ; 4.4002
;    !P.Multi=[1,1,2] & device,filename='Tfwhm_12CO_his.eps',/encapsulated
;        pdf_plot, validdata, threshold, /log $
;                , binsize=0.1, xrange=[-4,4], yrange=[5e-5,1e1] $
;                , title='!E12!NCO Line Width PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(\DeltaV/<\DeltaV>)') $  
;                , x_natural_title=textoidl('\DeltaV')+' [km s!E-1!N]' $
;                , /fitting, fit_range=[0,12]
;    device, /close_file
;print, 'Vcenter Histogram: 12CO'
;    validdata=vdata[where(vdata gt -30 and vdata lt 70)]
;    print,max(vdata),min(vdata),mean(vdata)
;    print,max(validdata),min(validdata),mean(validdata)
;    help,validdata
;    device,filename='Vcenter_12CO_his.eps',/encapsulated
;        plothist,validdata,bin=0.5,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2 $
;               ,title='!E12!NCO V PDF of NGC 2264', xtitle='V (km s!E-1!N)', ytitle='Number' $
;               ,/ylog,xrange=[-35,75],yrange=[0.5e2,0.5e5]
;    device,/close_file
;
;
print, 'FWHM Histogram: 13CO'
;    fits_read, "Tfwhm_13CO.fits", data, hdr
;    print,max(data),min(data),mean(data)
;    fits_read, "tpeak_13CO.fits", Tpeak, TpeakHdr
;    fits_read, "Vcenter_13CO.fits", VcData, VcHdr
;    print, Format='("Confined by 3*RMS, Velocity Range, and Above 0")'
;    help, where(Tpeak gt 3*Tmb_13CO_rms and mask_data, count)
;    help, where(VcData gt -30 and VcData lt 75, count)
;    help, where(data ge 0 and mask_data, count)
;    validdata=data[where(data ge 0 and VcData gt -30 and VcData lt 75 and Tpeak gt 3*Tmb_13CO_rms and mask_data, count, complement=c_indices)]
;    help, validdata
;    error_data=mask_data & error_data[c_indices]=0 & tvscl, error_data
;    print,max(validdata),min(validdata),mean(validdata)
;    threshold = dv_13CO
;    !P.Multi=[1,1,2] & device,filename='Tfwhm_13CO_his.eps',/encapsulated
;        pdf_plot, validdata, threshold, /log $
;                , binsize=0.1, xrange=[-4,4], yrange=[5e-5,1e1]  $
;                , title='!E13!NCO Line Width PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(\DeltaV/<\DeltaV>)') $
;                , x_natural_title=textoidl('\Delta V')+' [km s!E-1!N]' $
;                , /fitting, fit_range=[0,12]
;    device,/close_file
;print, 'Vcenter Histogram: 13CO'
;    validdata=vdata[where(vdata gt -30 and vdata lt 70)]
;    print,max(vdata),min(vdata),mean(vdata)
;    print,max(validdata),min(validdata),mean(validdata)
;    help,validdata
;    device,filename='Vcenter_13CO_his.eps',/encapsulated
;        plothist,validdata,bin=0.5,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2 $
;               ,title='!E13!NCO V PDF of NGC 2264', xtitle='V (km s!E-1!N)', ytitle='Number' $
;               ,/ylog,xrange=[-25,65],yrange=[0.5e2,0.5e5]
;    device,/close_file
;
;
print, 'FWHM Histogram: C18O'
;mask_data[0:110,*]=0
;mask_data[210:339,*]=0
;mask_data[*,0:50]=0
;mask_data[*,320:419]=0

;    fits_read,"Tfwhm_C18O.fits",data,hdr
;    print,max(data),min(data),mean(data)
;    fits_read, "tpeak_C18O.fits", Tpeak, TpeakHdr
;    fits_read, "Vcenter_C18O.fits", VcData, VcHdr
;    print, Format='("Confined by 3*RMS, Velocity Range, and Above 0")'
;    help, where(Tpeak gt 3*Tmb_C18O_rms and mask_data, count)
;    help, where(VcData gt -30 and VcData lt 70, count)
;    help, where(data ge 0 and mask_data, count)
;    validdata=data[where(data ge 0 and VcData gt -30 and VcData lt 70 and Tpeak gt 3*Tmb_C18O_rms and mask_data, count, complement=c_indices)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    error_data=mask_data & error_data[c_indices]=0 & tvscl, error_data
;    threshold = dv_C18O
;    !P.Multi=[1,1,2] & device,filename='Tfwhm_C18O_his.eps',/encapsulated
;        pdf_plot, validdata, threshold, /log $
;                , binsize=0.1, xrange=[-4,4],yrange=[5e-5,1e1] $
;                , title='C!E18!NO Line Width PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(\DeltaV/<\DeltaV>)') $
;                , x_natural_title=textoidl('\Delta V')+' [km s!E-1!N]'$
;                , /fitting, fit_range=[0,12]
;    device,/close_file
;print, 'Vcenter Histogram: C18O'
;    validdata=vdata[where(vdata gt -30 and vdata lt 70)]
;    print,max(vdata),min(vdata),mean(vdata)
;    print,max(validdata),min(validdata),mean(validdata)
;    help,validdata
;    device,filename='Vcenter_C18O_his.eps',/encapsulated
;        plothist,validdata,bin=0.5,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2 $
;               ,title='C!E18!NO V PDF of NGC 2264', xtitle='V (km s!E-1!N)', ytitle='Number' $
;               ,/ylog,xrange=[-15,35],yrange=[0.5e2,0.5e5]
;    device,/close_file

;tau,'Tpeak_13CO.fits',tex_file='Tex.fits',outfile='tau_13CO.fits'
;tau,'Tpeak_C18O.fits',tex_file='Tex.fits',outfile='tau_C18O.fits'
;tau,
print,"tau 13CO Histogram"
;    fits_read,"tau_13CO.fits",data,hdr
;    print, Format = '("Confined by 3*RMS, and  tau is finite & no less than 0.")'
;    help, where(Tpeak_12CO ge 3*Tmb_12CO_rms and mask_data, count)
;    help, where(Tpeak_13CO ge 3*Tmb_13CO_rms and mask_data, count)
;    help, where(Tpeak_13CO gt Tpeak_12CO and mask_data, count)
;    help, where(finite(data) and mask_data, count)
;    help, where(data ge 0 and mask_data, count)
;    validdata=data[where(data ge 0 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_13CO ge 3*Tmb_13CO_rms and mask_data, count, complement=c_indices)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    noiselevel = 0
;    print,'above noise: ', size(where(validdata gt noiselevel))
;    !P.multi = [1,1,2] & !Y.OMARGIN=[1,0]          ; !x.margin=[8,8] & !y.margin=[4,4]
;    device,filename='tau_13CO_his.eps',/encapsulated
;        pdf_plot, validdata, noiselevel, /log $
;                , binsize=0.1, xrange=[-4,4], yrange=[1e-4,10] $
;                , title='!7s!X!N C!E13!NO PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(\tau/<\tau>)') $
;                , x_natural_title='!7s!X' $
;                , /fitting;,fit_range
;    device,/close_file


print,"tau C18O Histogram"
;    fits_read,"tau_C18O.fits",data,hdr
;    print, Format = '("Confined by 3*RMS, and tau is finite & no less than 0.")'
;    help, where(Tpeak_12CO ge 3*Tmb_12CO_rms and mask_data, count)
;    help, where(Tpeak_C18O ge 3*Tmb_C18O_rms and mask_data, count)
;    help, where(Tpeak_C18O gt Tpeak_12CO and mask_data, count)
;    help, where(finite(data) and mask_data, count)
;    help, where(data ge 0 and mask_data, count)
;    validdata=data[where(data ge 0 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_C18O ge 3*Tmb_C18O_rms and mask_data, count, complement=c_indices)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    noiselevel = 0
;    print,'above noise: ', size(where(validdata gt noiselevel))
;    !P.multi = [1,1,2] & !Y.OMARGIN=[1,0]          ; !x.margin=[8,8] & !y.margin=[4,4]
;    device,filename='tau_C18O_his.eps',/encapsulated
;        pdf_plot, validdata, noiselevel, /log $
;                , binsize=0.1, xrange=[-4,4], yrange=[1e-5,10] $
;                , title='!7s!X C!E18!NO PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(\tau/<\tau>)') $
;                , x_natural_title='!7s!X'  $
;                , /fitting;
;    device,/close_file

;n_co, "13CO", 'Wco', "Wco_13CO_-10_35.fits", outfile='Nco_Wco_13CO.fits'
;n_co, "C18O", 'Wco', "Wco_C18O_1_12.fits",   outfile='Nco_Wco_C18O.fits'
;n_co,'13CO', 'Tpeak', 'tpeak_13CO.fits', tex_file="Tex.fits", fwhm_file='fwhm_13CO.fits', outfile='Nco_Tpeak_13CO.fits'
;n_co,'C18O', 'Tpeak', 'tpeak_C18O.fits', tex_file="Tex.fits", fwhm_file='fwhm_C18O.fits', outfile='Nco_Tpeak_C18O.fits'
;n_co, '13CO', 'tau', 'tau_13CO.fits', tex_file="Tex.fits", fwhm_file='fwhm_13CO.fits', outfile='Nco_tau_13CO.fits'
;n_co, 'C18O', 'tau', 'tau_C18O.fits', tex_file="Tex.fits", fwhm_file='fwhm_C18O.fits', outfile='Nco_tau_C18O.fits'
print,"Nco Histogram: Nco_13CO_his.eps"
;    fits_read,"Nco_13co_-10_35_int.fits",data,hdr
;    fits_read, '13co_-10_35_int.fits', WcoData,WcoHdr
;    print, Format = '("Confined by 3*RMS, of Tpeak_12CO and Wco_13CO.")'
;    help, where(finite(data) and mask_data, count)
;    help, where(WcoData ge 3 * Tmb_13CO_rms*sqrt(45*0.167) and mask_data, count)
;    validdata=data[where(WcoData ge 3 * Tmb_13CO_rms*sqrt(45*0.167) and Tpeak_12CO ge 3*Tmb_12CO_rms and mask_data, count, complement=c_indices)]  ; 1.6956942e+18
;    help, validdata
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    !P.multi = [1,1,2] & device,filename='Nco_13CO_his.eps'
;        pdf_plot, validdata, 0, /log $
;                , bin=0.1, xrange=[-3,6], yrange=[1e-4,10] $
;                , title='N(!E13!NCO) PDF of NGC 2264' $
;                , x_log_title=textoidl("ln(N_{CO}/<N_{CO}>)") $
;                , x_natural_title='CO Conlumn Densities (cm!E-2!N)' $
;                , /fitting
;    device,/close_file

print,"Nco Histogram: Nco_C18O_his.eps"
;    fits_read, "Nco_c18o_1_12_int.fits",data,hdr
;    fits_read, 'c18o_1_12_int.fits', WcoData,WcoHdr
;    print, Format = '("Confined by 3*RMS, of Tpeak_12CO and Wco_C18O.")'
;    help, where(finite(data) and mask_data, count)
;    help, where(WcoData ge 3 * Tmb_C18O_rms*sqrt(11*0.167) and mask_data, count)
;    validdata=data[where(WcoData ge 3 * Tmb_C18O_rms*sqrt(11*0.167) and Tpeak_12CO ge 3*Tmb_12CO_rms and mask_data, count, complement=c_indices)]  ; 2.3637384e+17
;    help,validdata
;    !P.multi = [1,1,2] & device,filename='Nco_C18O_his.eps'
;        pdf_plot, validdata, 0, /log $
;                , bin = 0.1, xrange=[-3,6], yrange=[1e-4,10] $
;                , title='N(C!E18!NO) PDF of NGC 2264' $
;                , x_log_title=textoidl("ln(N_{CO}/<N_{CO}>)") $
;                , x_natural_title='CO Conlumn Densities (cm!E-2!N)' $
;                , /fitting
;    device,/close_file

print,"Nco Histogram: Nco_13CO_Tpeak_his.eps"
;    fits_read,"Nco_Tpeak_13CO.fits",data,hdr
;    print, Format='("Confined by 3*RMS, Velocity Range, and Vfwhm above channel width")'
;    validdata=data[where(mask_data and Vc_13CO gt -30 and Vc_13CO lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_13CO ge 3*Tmb_13CO_rms and Vfwhm_13CO ge dv_13CO, count)]
;    help,validdata
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    !P.multi = [1,1,2] & device,filename='Nco_13CO_Tpeak_his.eps'
;        pdf_plot, validdata, 0, /log $
;                , bin = 0.1, xrange=[-5,6],yrange=[1e-4,10] $
;                , title='N(!E13!NCO) PDF of NGC 2264, T!Ipeak!N' $
;                , x_log_title=textoidl("ln(N_{CO}/<N_{CO}>)") $
;                , x_natural_title='CO Conlumn Densities (cm!E-2!N)' $
;                , /fitting
;    device,/close_file
 
print,"Nco Histogram: Nco_13CO_tau_his.eps"
;    fits_read,"Nco_tau_13CO.fits",data,hdr
;    print, Format='("Confined by 3*RMS, Velocity Range, Velocity Width, and tau above 0")'
;    validdata=data[where(mask_data and Vfwhm_13CO ge dv_13CO and Vc_13CO gt -30 and Vc_13CO lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_13CO ge 3*Tmb_13CO_rms and tau_13CO ge 0, count)]
;    help,validdata
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    !P.multi = [1,1,2] & device,filename='Nco_13CO_tau_his.eps'
;        pdf_plot, validdata, 0, /log $
;               , bin = 0.1, xrange=[-5,6],yrange=[1e-4,10] $
;               , title='N(!E13!NCO) PDF of NGC 2264, !7s!X' $
;               , x_log_title=textoidl("ln(N_{CO})/<N_{CO}>") $
;               , x_natural_title='CO Conlumn Densities (cm!E-2!N)' $
;               , /fitting
;    device,/close_file

;This is only for C18O to mask, which only traces high density regions.
;mask_data[0:110,*]=0
;mask_data[210:339,*]=0
;mask_data[*,0:50]=0
;mask_data[*,320:419]=0

print,"Nco Histogram: Nco_C18O_Tpeak_his.eps"
;    fits_read,"Nco_Tpeak_C18O.fits",data,hdr
;    print, Format='("Confined by 3*RMS, Velocity Range, and Vfwhm above channel width")'
;    validdata=data[where(mask_data and Vc_C18O gt -30 and Vc_C18O lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_C18O ge 3*Tmb_C18O_rms and Vfwhm_C18O ge dv_C18O, count)]
;    help,validdata
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    !P.multi = [1,1,2] & device,filename='Nco_C18O_Tpeak_his.eps'
;        pdf_plot, validdata, 0, /log $
;                , bin = 0.1, xrange=[-5,6],yrange=[5e-4,10] $
;                , title='N(C!E18!NO) PDF of NGC 2264, T!Ipeak!N' $
;                , x_log_title=textoidl("ln(N_{CO}/<N_{CO}>)") $
;                , x_natural_title='CO Conlumn Densities (cm!E-2!N)' $
;                , /fitting
;    device,/close_file
  

print,"Nco Histogram: Nco_C18O_tau_his.eps"
;    fits_read,"Nco_tau_C18O.fits",data,hdr
;    print, Format='("Confined by 3*RMS, Velocity Range, Velocity Width, and tau above 0")'
;    validdata=data[where(mask_data and Vfwhm_C18O ge dv_C18O and Vc_C18O gt -30 and Vc_C18O lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_C18O ge 3*Tmb_C18O_rms and tau_C18O ge 0, count)]
;    help, validdata
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    !P.multi = [1,1,2] & device,filename='Nco_C18O_tau_his.eps'
;        pdf_plot, validdata, 0, /log $
;               , bin = 0.1, xrange=[-5,6],yrange=[5e-4,10] $
;               , title='N(C!E18!NO) PDF of NGC 2264,!7s!X' $
;               , x_log_title=textoidl("ln(N_{CO})/<N_{CO}>") $
;               , x_natural_title='CO Conlumn Densities (cm!E-2!N)' $
;               , /fitting
;    device,/close_file



; .compile n_h2
;n_h2, '12CO', '12co_-10_40_int.fits', outfile='N_H2_Wco_12CO.fits'
;n_h2, '13CO', 'Nco_13co_-10_35_int.fits', outfile='N_H2_Nco_13CO.fits'
;n_h2, 'C18O', 'Nco_c18o_1_12_int.fits', outfile='N_H2_Nco_c18o_1_12_int.fits'
;n_h2, '13CO', 'Nco_Tpeak_13CO.fits', outfile='N_H2_Nco_Tpeak_13CO.fits'
;n_h2, 'C18O', 'Nco_Tpeak_C18O.fits', outfile='N_H2_Nco_Tpeak_C18O.fits'
;n_h2, '13CO', 'Nco_tau_13CO.fits', outfile='N_H2_Nco_tau_13CO.fits'
;n_h2, 'C18O', 'Nco_tau_C18O.fits', outfile='N_H2_Nco_tau_C18O.fits'

print,"N_H2 Histogram: N_H2_12CO_his.eps"
;    fits_read,"N_H2_12co_-10_40_int.fits",data,hdr
;    validdata=data[where(mask_data, count)]      ;4.326871e+22
;    help,validdata
;    image_statistics, validdata, data_sum=data_sum, maximum=data_max, mean=data_mean, minimum=data_min
;    print, 'raw data statistics:   sum   max   min   mean',data_sum,data_max,data_min,data_mean
;;    noiselevel =  3 * Tmb_12CO_rms * sqrt(50*0.159) * 1.8e20    ;6.69931e20
;    noiselevel = 8.55081e+20
;;    print, 'above noise: ', size(where(validdata ge noiselevel))
;    signaldata=validdata(where(validdata ge noiselevel))
;    help, signaldata
;    image_statistics, signaldata, data_sum=data_sum, maximum=data_max, mean=data_mean, minimum=data_min
;    print, 'above 3 sigma statistics: sum   max   min   mean',data_sum,data_max,data_min,data_mean
;    print,'Mass (Msun) from 12CO x-factor:   raw data       valid data           above 3 sigma'
;    print, mass(data,distance), mass(validdata,distance), mass(signaldata,distance)
;    !P.multi = [1,1,2] & device,filename='N_H2_12CO_his.eps',/encapsulated
;        pdf_plot, validdata, noiselevel, /log $
;                , bin=0.1, xrange=[-3,4], yrange=[5e-5,5e0] $
;                , title='N(H!I2!N) from !E12!NCO PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(N_{H_2})/<N_{H_2}>') $
;                , x_natural_title='H!I2!N Conlumn Densities (cm!E-2!N)' $
;                , /fitting
;    device,/close_file


;        logdata=alog(signaldata/data_mean)
;        binsize=0.1 & xrange =[-3,4] & yrange =[5e-5,5e0]
;        Nsamples=n_elements(logdata)
;        yhist = cgHistogram(logdata,binsize=binsize,min=alog(noiselevel/data_mean),locations=xhist,/frequency)/binsize
;        xhist = xhist + 0.5*binsize
;;        yfit = GaussFit(xhist[0:10], yhist[0:10], coeff, NTERMS=3, chisq=chisquare)
;        yfit = GaussFit(xhist, yhist, coeff, NTERMS=3, chisq=chisquare)
;        print, 'peak =', peak, '    peak_subscript =', max_subscript
;        print, 'A, mu, sigma:', coeff & print, 'chi square =',chisquare
;        cgPlot, [xhist[0]-binsize,xhist,max(xhist)+binsize], [0,yhist,0] $
;              , psym=10, xstyle=9, ystyle=9 $
;              , xtitle=textoidl('ln(N_{H_2} / <N_{H_2}>)'),ytitle='P(s)' $
;              , /ylog,xrange=xrange,yrange=yrange,ytickformat='logticks_exp'
;        cgColorFill, [xrange[0]*[1,1],alog(noiselevel/data_mean)*[1,1]],[yrange,reverse(yrange)], color='grey'
;        cgPlots,[1,1]*alog(noiselevel/data_mean),yrange,linestyle=2
;        cgOplot, xhist, yfit,color='green'
;        cgAxis,xaxis=0,xstyle=1
;        cgAxis,xaxis=1,xstyle=1, xrange=exp(xrange)*data_mean,xlog=1;, /save
;        cgText, mean(!X.Window), 0.48, /normal, alignment=0.5 $
;              , textoidl('H_2 Column Densities (cm^{-2})')
;        cgAxis,yaxis=0,ystyle=1, ytickformat='logticks_exp', yrange=yrange
;        cgAxis,yaxis=1,ystyle=1, ytickformat='logticks_exp', yrange=yrange*Nsamples*binsize, ytitle=textoidl('Number of Pixels per bin')
;        cgText, mean(!X.Window), 0.52, /normal, alignment=0.5, charsize=2 $
;              , 'N(H!I2!N) from !E12!NCO PDF of NGC 2264' 
    

print,"N_H2 Histogram: N_H2_13CO_his.eps"
;    fits_read,"N_H2_13co_-10_35_int.fits",data,hdr
;;    noiselevel =  3 * Tmb_12CO_rms * sqrt(50*0.159) * 1.8e20    ;6.69931e20
;    noiselevel = 1.49e20 * 3 * Tmb_13CO_rms * sqrt(45*dv_13CO)/(1-exp(-5.289/8.30)) 
;    validdata=data[where(mask_data, count)]   ;4.326871e+26
;    signaldata=validdata(where(validdata ge noiselevel))
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    print,'Mass (Msun) from 13CO:   raw data       valid data           above 3 sigma'
;    print, mass(data,distance), mass(validdata,distance), mass(signaldata,distance)
;    !P.multi = [1,1,2] & device,filename='N_H2_13CO_his.eps',/encapsulated
;        pdf_plot, validdata, noiselevel, /log $
;                , bin=0.1, xrange=[-3,4], yrange=[5e-5,5e0] $
;                , title='N(H!I2!N) from !E13!NCO PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(N_{H_2})/<N_{H_2}>') $
;                , x_natural_title='H!I2!N Conlumn Densities (cm!E-2!N)' $
;                , /fitting
;    device,/close_file

print,"N_H2 Histogram: N_H2_C18O_his.eps"
;;    fits_read,"N_H2_c18o_0_10_int.fits",data,hdr
;;    validdata=data[where(data lt 4.326871e+26, count)]
;;    help,validdata
;;    print,max(validdata),min(validdata),mean(validdata)
;;        device,filename='N_H2_C18O_0_10_his.eps',/encapsulated
;;        device,/portrait
;;        plothist,validdata,bin=1e24,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;;               ,title='N(H!I2!N) from C!E18!NO PDF of NGC 2264',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;;               ,/ylog,xrange=[-3e25,1.4e26],yrange=[0.5,1e6]
;;        device,/close_file
;    fits_read,"N_H2_c18o_1_12_int.fits",data,hdr
;    noiselevel = 1.568e21 * 3 * Tmb_C18O_rms * sqrt(11*dv_C18O)/(1-exp(-5.27/8.30)) 
;    validdata=data[where(mask_data, count)]    ;4.326871e+23
;    signaldata=validdata(where(validdata ge noiselevel))
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    print,'Mass (Msun) from C18O:   raw data       valid data           above 3 sigma'
;    print, mass(data,distance), mass(validdata,distance), mass(signaldata,distance)
;    !P.multi = [1,1,2] & device,filename='N_H2_C18O_his.eps',/encapsulated
;        pdf_plot, validdata, noiselevel, /log $
;               , bin=0.1, xrange=[-3,4], yrange=[5e-5,5e0] $
;               , title='N(H!I2!N) from C!E18!NO PDF of NGC 2264' $
;               , x_log_title=textoidl('ln(N_{H_2})/<N_{H_2}>') $
;               , x_natural_title='H!I2!N Conlumn Densities (cm!E-2!N)' $
;               , /fitting
;    device,/close_file

;    print, Format = '("Confined by 3*RMS, of Tpeak_12CO and Wco_13CO.")'
;    help, where(finite(data) and mask_data, count)
;    help, where(WcoData ge 3 * Tmb_13CO_rms*sqrt(45*0.167) and mask_data, count)
;    validdata=data[where(WcoData ge 3 * Tmb_13CO_rms*sqrt(45*0.167) and Tpeak_12CO ge 3*Tmb_12CO_rms and mask_data, count, complement=c_indices)]  ; 1.6956942e+18
;    print, Format = '("Confined by 3*RMS, of Tpeak_12CO and Wco_C18O.")'
;    help, where(finite(data) and mask_data, count)
;    help, where(WcoData ge 3 * Tmb_C18O_rms*sqrt(11*0.167) and mask_data, count)
;    validdata=data[where(WcoData ge 3 * Tmb_C18O_rms*sqrt(11*0.167) and Tpeak_12CO ge 3*Tmb_12CO_rms and mask_data, count, complement=c_indices)]  ; 2.3637384e+17
;

print,"N_H2 Histogram: N_H2_13CO_Tpeak_his.eps"
    fits_read,"N_H2_Nco_Tpeak_13CO.fits",data,hdr
    print, Format='("Confined by 3*RMS, Velocity Range, and Vfwhm above channel width")'
    validdata=data[where(mask_data and Vc_13CO gt -30 and Vc_13CO lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_13CO ge 3*Tmb_13CO_rms and Vfwhm_13CO ge dv_13CO, count)]
    help,validdata
    print,'Mass: ', mass(validdata,distance), ' Msun from 13CO column density'
    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
    print,sum,max,min,mean
    !P.multi = [1,1,2] & device,filename='N_H2_13CO_Tpeak_his.eps',/encapsulated
        pdf_plot, validdata, 0, /log $
               , bin=0.1, xrange=[-5,6], yrange=[5e-5,5e0] $
               , title='N(H!I2!N) from !E13!NCO PDF of NGC 2264, T!Ipeak!N' $
               , x_log_title=textoidl("ln(N_{H_2})/<N_{H_2}>") $
               , x_natural_title='H!I2!N Conlumn Densities (cm!E-2!N)' $
               , /fitting, fit_range=[0,24]
    device,/close_file

print,"N_H2 Histogram: N_H2_13CO_tau_his.eps"
    fits_read,"N_H2_Nco_tau_13CO.fits",data,hdr
    print, Format='("Confined by 3*RMS, Velocity Range, Velocity Width, and tau above 0")'
    validdata=data[where(mask_data and Vfwhm_13CO ge dv_13CO and Vc_13CO gt -30 and Vc_13CO lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_13CO ge 3*Tmb_13CO_rms and tau_13CO ge 0, count)]
    help,validdata
    print,'Mass: ', mass(validdata,distance), ' Msun from 13CO column density'
    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
    print,sum,max,min,mean
    !P.multi = [1,1,2] & device,filename='N_H2_13CO_tau_his.eps',/encapsulated
        pdf_plot, validdata, 0, /log $
                , bin=0.1, xrange=[-5,6], yrange=[5e-5,5e0] $
                , title='N(H!I2!N) from !E13!NCO PDF of NGC 2264, !7s!X' $
                , x_log_title=textoidl("ln(N_{H_2})/<N_{H_2}>") $
                , x_natural_title='H!I2!N Conlumn Densities (cm!E-2!N)' $
                , /fitting, fit_range=[0,24]
    device,/close_file

;This is only for C18O to mask, which only traces high density regions.
mask_data[0:110,*]=0
mask_data[210:339,*]=0
mask_data[*,0:50]=0
mask_data[*,320:419]=0

print,"N_H2 Histogram: N_H2_C18O_Tpeak_his.eps"
    fits_read,"N_H2_Nco_Tpeak_C18O.fits",data,hdr
    print, Format='("Confined by 3*RMS, Velocity Range, and Vfwhm above channel width")'
    validdata=data[where(mask_data and Vc_C18O gt -30 and Vc_C18O lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_C18O ge 3*Tmb_C18O_rms and Vfwhm_C18O ge dv_C18O, count)]
    help,validdata
    print,'Mass: ', mass(validdata,distance), ' Msun from C18O column density'
    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
    print,sum,max,min,mean
    !P.multi = [1,1,2] & device,filename='N_H2_C18O_Tpeak_his.eps',/encapsulated
        pdf_plot, validdata, 0, /log $
                , bin=0.1, xrange=[-5,6], yrange=[5e-4,1e1] $
                , title='N(H!I2!N) from C!E18!NO PDF of NGC 2264, T!Ipeak!N' $
                , x_log_title=textoidl("ln(N_{H_2})/<N_{H_2}>") $
                , x_natural_title='H!I2!N Conlumn Densities (cm!E-2!N)' $
                , /fitting, fit_range=[0,24]
    device,/close_file


print,"N_H2 Histogram: N_H2_C18O_tau_his.eps"
    fits_read,"N_H2_Nco_tau_C18O.fits",data,hdr
    print, Format='("Confined by 3*RMS, Velocity Range, Velocity Width, and tau above 0")'
    validdata=data[where(mask_data and Vfwhm_C18O ge dv_C18O and Vc_C18O gt -30 and Vc_C18O lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_C18O ge 3*Tmb_C18O_rms and tau_C18O ge 0, count)]
    help, validdata
    print,'Mass: ', mass(validdata,distance), ' Msun from C18O column density'
    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
    print,sum,max,min,mean
    !P.multi = [1,1,2] & device,filename='N_H2_C18O_tau_his.eps',/encapsulated
        pdf_plot, validdata, 0, /log $
                 , bin=0.1, xrange=[-5,6], yrange=[5e-4,1e1] $
                 , title='N(H!I2!N) from C!E18!NO PDF of NGC 2264,!7s!X' $
                 , x_log_title=textoidl("ln(N_{H_2})/<N_{H_2}>") $
                 , x_natural_title='H!I2!N Conlumn Densities (cm!E-2!N)' $
                 , /fitting, fit_range=[0,12]
    device,/close_file



;print, 'Compare 12CO and 13CO:'
;    fits_read, 'tpeak.fits', img_c, hdr_c
;    fits_read, 'tpeak_13CO.fits', img, hdr
;    pson
;        device, filename='Compare_Tpeak.eps', /encapsulated
;        device, /portrait
;            cgimage,img,/keep_aspect, position = pos
;            imcontour,img_c,hdr_c,nlevels=7,/Noerase,/TYPE,position = pos
;        device, /close_file
;    psoff

;print, 'Abundance Ratio:'
;;    fits_read, 'Nco_13co_-10_35_int.fits', N_13CO, N_13CO_hdr
;;    fits_read, 'Nco_c18o_1_12_int.fits', N_C18O, N_C18O_hdr
;;    data=N_13CO/N_C18O
;;    hdr =N_13CO_hdr
;;    fits_write,'AbundanceRatio_13_18.fits', data, hdr
;;    fits_read, 'Nco_Tpeak_13CO.fits', N_13CO, N_13CO_hdr
;;    fits_read, 'Nco_Tpeak_C18O.fits', N_C18O, N_C18O_hdr
;;    data=N_13CO/N_C18O
;;    hdr =N_13CO_hdr
;;    fits_write,'AbundanceRatio_13_18_Tpeak.fits', data, hdr
;;    fits_read, 'Nco_tau_13CO.fits', N_13CO, N_13CO_hdr
;;    fits_read, 'Nco_tau_C18O.fits', N_C18O, N_C18O_hdr
;;    data=N_13CO/N_C18O
;;    hdr =N_13CO_hdr
;;    fits_write,'AbundanceRatio_13_18_tau.fits', data, hdr

;    fits_read, 'AbundanceRatio_13_18.fits', data, hdr
;    validdata=data[where(tex lt 46.3205, count)]
;    help, validdata
;    print,'     Sum           Maximum     Minimum      Mean'
;    image_statistics, validdata, count=count, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    validdata=validdata[where(validdata gt -100 and validdata lt 100)]
;    help, validdata
;    pson
;        device,filename='AbundanceRatio_13_18_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=1,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='Abundence Ratio !E13!NCO/C!E18!NO PDF of NGC 2264',xtitle='Abundance Ratio',ytitle='Number'$
;               ,/ylog,xrange=[-1e2,1e2],yrange=[0.5,1e6]
;        cgplots,[1,1],[0.1,1e5],linestyle=2
;        cgtext,1.4002,2e5,'ratio=1',charsize=1     
;        device,/close_file
;    psoff
;    fits_read, 'AbundanceRatio_13_18_Tpeak.fits', data, hdr
;    validdata=data[where(tex lt 46.3205 and vdata13 gt -30 and vdata13 lt 75 and vdata18 gt -30 and vdata18 lt 75 , count)]
;    help, validdata
;    print,'     Sum           Maximum     Minimum      Mean'
;    image_statistics, validdata, count=count, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    validdata=validdata[where(validdata gt -100 and validdata lt 100)]
;    help, validdata
;    pson
;        device,filename='AbundanceRatio_13_18_Tpeak_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=1,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='Abundence Ratio !E13!NCO/C!E18!NO PDF of NGC 2264',xtitle='Abundance Ratio',ytitle='Number'$
;               ,/ylog,xrange=[-1e2,1e2],yrange=[0.5,1e6]
;        cgplots,[1,1],[0.1,1e5],linestyle=2
;        cgtext,1.4002,2e5,'ratio=1',charsize=1     
;        device,/close_file
;    psoff
;    fits_read, 'AbundanceRatio_13_18_tau.fits', data, hdr

;    validdata=data[where(tex lt 46.3205 and vdata13 gt -30 and vdata13 lt 75 and vdata18 gt -30 and vdata18 lt 75 and finite(taudata13) and finite(taudata18), count)]
;    help, validdata
;    print,'     Sum           Maximum     Minimum      Mean'
;    image_statistics, validdata, count=count, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    validdata=validdata[where(validdata gt -100 and validdata lt 100)]
;    help, validdata
;    pson
;        device,filename='AbundanceRatio_13_18_tau_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=2,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='Abundence Ratio !E13!NCO/C!E18!NO PDF of NGC 2264',xtitle='Abundance Ratio',ytitle='Number'$
;               ,/ylog,xrange=[-1e3,1e3],yrange=[0.5,1e6]
;        cgplots,[1,1],[0.1,1e5],linestyle=2
;        cgtext,1.4002,2e5,'ratio=1',charsize=1     
;        device,/close_file
;    psoff

print, "Draw maps:"
; map center
; data & header
; data center
;tv, data
;plot coordinates

print, "Order Index:"
    device, filename='Ord_N_H2.eps'
    cgPlot,            [   3.90e21, 2.75487e21, 7.04140e21] $
          ,            [-0.0132049, 0.01488121, 0.02569919] $
          , err_xlow = [   8.55e20, 6.19166e20, 3.29325e21] $
          , err_xhigh= [   4.31e22, 6.71975e22, 1.25580e23] $
          , /xlog, xrange=[1e19,1e25] $
          , title = textoidl('Order Index of N_{H_2}'), xtitle = textoidl('N_{H_2}'), ytitle = 'Order Index', psym=7
    device, /close_file


;cubemoment, 'ngc226412cofinal.fits', [-1,2], direction='B'
;cubemoment, 'ngc226412cofinal.fits', [-1,2], direction='L'
;cubemoment, 'ngc226413cofinal.fits', [-1,2], direction='B'
;cubemoment, 'ngc226413cofinal.fits', [-1,2], direction='L'
;cubemoment, 'ngc2264c18ofinal.fits', [-1,2], direction='B'
;cubemoment, 'ngc2264c18ofinal.fits', [-1,2], direction='L'

!P = P_former & !X = X_former & !Y = Y_former
set_plot, 'x'
