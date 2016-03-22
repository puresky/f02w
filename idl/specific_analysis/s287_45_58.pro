;Tpeak_12CO_fits="Tpeak_12CO_10_19.fits"

;;;;Analysing Data
SubRegion="_45_58"
Vwidth=13
distance=RegionDistance[2]

;Read in Data:
    fits_read, "Tpeak_12CO"  +SubRegion+".fits", Tpeak_12CO, Tpeak12Hdr
    fits_read, "Tpeak_13CO"  +SubRegion+".fits", Tpeak_13CO, Tpeak13Hdr
    fits_read, "Tpeak_C18O"  +SubRegion+".fits", Tpeak_C18O, Tpeak18Hdr
    fits_read, "Tex"         +SubRegion+".fits", Tex,        TexHdr
;    fits_read, "Tfwhm_12CO"  +SubRegion+".fits", Vfwhm_12CO, Vfwhm12Hdr
;    fits_read, "Tfwhm_13CO"  +SubRegion+".fits", Vfwhm_13CO, Vfwhm13Hdr
;    fits_read, "Tfwhm_C18O"  +SubRegion+".fits", Vfwhm_C18O, Vfwhm18Hdr
;    fits_read, "Vcenter_12CO"+SubRegion+".fits", Vc_12CO,    VcData12Hdr
;    fits_read, "Vcenter_13CO"+SubRegion+".fits", Vc_13CO,    VcData13Hdr
;    fits_read, "Vcenter_C18O"+SubRegion+".fits", Vc_C18O,    VcData18Hdr
;    fits_read, "tau_13CO"    +SubRegion+".fits", tau_13CO,   tau13Hdr
;    fits_read, "tau_C18O"    +SubRegion+".fits", tau_C18O,   tau18Hdr

;Data Mask:
    mask_data = Tpeak_12CO
    mask_data[where(Tpeak_12CO lt 42, count, complement=c_indices,ncomplement=c_count)]=1
    mask_data[c_indices]=0
;    fits_read, "mask.fits",mask_data, maskHdr
    help, mask_data
    if !D.window ge 0 then Wshow &  tvscl, mask_data
;    fits_write, 'mask.fits',mask_data,TexHdr
;This is only for C18O to mask, which only traces high density regions.
;maybe needn't any more
;mask_data_center=mask_data
;mask_data_center[0:110,*]=0
;mask_data_center[210:339,*]=0
;mask_data_center[*,0:50]=0
;mask_data_center[*,320:419]=0
;mask_data_center[*,380:419]=0


;Date basic information:
    print, 'T peak above 3 sigma:'
    help, where(Tpeak_12CO ge 3*Tmb_12CO_rms and mask_data, count)
    help, where(Tpeak_13CO ge 3*Tmb_13CO_rms and mask_data, count)
    help, where(Tpeak_C18O ge 3*Tmb_C18O_rms and mask_data, count)
;    print, 'FWHM-V width above channel width:'
;    help, where(Vfwhm_12CO ge dv_12CO and mask_data, count)
;    help, where(Vfwhm_13CO ge dv_13CO and mask_data, count)
;    help, where(Vfwhm_C18O ge dv_C18O and mask_data, count)
;    print, 'FWHM-V center confined in region:'
;    help, where(Vc_12CO gt -30 and Vc_12CO lt 75 and mask_data, count)
;    help, where(Vc_13CO gt -30 and Vc_13CO lt 75 and mask_data, count)
;    help, where(Vc_C18O gt -30 and Vc_C18O lt 75 and mask_data, count)
;    print, 'T peak, Optical thin lager than Optical thick:'
;    help, where(Tpeak_13CO gt Tpeak_12CO and mask_data, count)
;    help, where(Tpeak_C18O gt Tpeak_12CO and mask_data, count)
;    print, 'tau finite'



print, 'Tpeak 12CO map'
;    fits_read, 'Tpeak_12CO.fits', data, hdr
;    device, filename='Tpeak_12CO.eps',/encapsulated
;        cgimage,data,/keep_aspect, position = pos
;    device, /close_file

print,"Tpeak 12CO Histogram"
;    fits_read,"Tpeak_12CO.fits",data,hdr
;    validdata=data[where(data lt 42.7905, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    noiselevel = 3 * Tmb_12CO_rms
;    signaldata = validdata(where(validdata ge noiselevel))
;    help, signaldata
;    image_statistics, signaldata, data_sum=data_sum, maximum=data_max, mean=data_mean, minimum=data_min
;    print,'Above 3 sigma statistics:	sum	max	min 	mean', data_sum, data_max, data_min, data_mean
;    !P.multi = [1,1,2] & device,filename='tpeak_12CO_his.eps'
;        pdf_plot, validdata, min(validdata)>noiselevel, /log $
;                , bin = 0.1, xrange=[-3,3.0],yrange=[1e-4,10] $
;                , title='T!Ipeak !N!E12!NCO PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(T_{peak}/<T_{peak}>)') $
;                , x_natural_title=textoidl('T_{peak} [K]') $
;                , /fitting, fit_range=[0,14],statistics=Ord_Tpeak_12CO
;    device,/close_file
 
print,'Velocity of Tpeak 12CO Histogram'
;    fits_read,'Tpeak_12CO.fits',Tpeak,TpHdr
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
print,'Line Width 12CO Histogram'
;    fits_read,'Tpeak_12CO.fits',Tpeak,TpHdr
;    fits_read,'Tfwhm_12CO.fits',FWHM,FwhmHdr
;    FWHM_valid=FWHM[where(Vgauss gt -35 and Vgauss lt 75 and FWHM gt 0.158 and FWHM lt 110 and Tpeak lt 42.7905)]
;    help,FWHM_valid
;    image_statistics, FWHM_valid, data_sum=sum, maximum=max, mean=mean, minimum=min &    print,sum,max,min,mean
;    fits_read,'ngc226412cofinal_m2.fits',Vmoment,VmHdr
;    Vmoment_2_valid=Vmoment[where(Tpeak gt 3*Tmb_12CO_rms and Tpeak lt 42.7905 and finite(Vmoment))]
;    help,Vmoment_2_valid
;    image_statistics, Vmoment_2_valid, data_sum=sum, maximum=max, mean=mean, minimum=min &    print,sum,max,min,mean
 
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

print,"Tpeak 13CO Histogram"
;    fits_read,"Tpeak_13CO.fits",data,hdr
;    validdata=data[where(data lt 16.74136, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    noiselevel = 3 * Tmb_13CO_rms
;    signaldata = validdata(where(validdata ge noiselevel))
;    help, signaldata
;    image_statistics, signaldata, data_sum=data_sum, maximum=data_max, mean=data_mean, minimum=data_min
;    print,'Above 3 sigma statistics:	sum	max	min 	mean', data_sum, data_max, data_min, data_mean
;    !P.multi = [1,1,2] & device,filename='tpeak_13CO_his.eps'
;        pdf_plot, validdata, min(validdata)>noiselevel, /log $
;                , bin = 0.1, xrange=[-3,3.0],yrange=[1e-4,10] $
;                , title='T!Ipeak !N!E13!NCO PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(T_{peak}/<T_{peak}>)') $
;                , x_natural_title=textoidl('T_{peak} [K]') $
;                , /fitting, fit_range=[0,13],statistics=Ord_Tpeak_13CO
;    device,/close_file

print,"Tpeak C18O Histogram"
;    fits_read,"Tpeak_C18O.fits",data,hdr
;    validdata=data[where(data lt 10.1618, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    noiselevel = 3 * Tmb_C18O_rms
;    signaldata = validdata(where(validdata ge noiselevel))
;    help, signaldata
;    image_statistics, signaldata, data_sum=data_sum, maximum=data_max, mean=data_mean, minimum=data_min
;    print,'Above 3 sigma statitics:    sum    max    min    mean', data_sum, data_max, data_min, data_mean
;    !P.multi = [1,1,2] & device,filename='tpeak_C18O_his.eps'
;       pdf_plot, validdata, min(validdata)>noiselevel, /log $
;                , bin = 0.1, xrange=[-3,3.0],yrange=[1e-4,10] $
;                , title='T!Ipeak !NC!E18!NO PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(T_{peak}/<T_{peak}>)') $
;                , x_natural_title=textoidl('T_{peak} [K]') $
;                , /fitting, fit_range=[0,11],statistics=Ord_Tpeak_C18O
;    device,/close_file
;;        logdata=alog(signaldata/data_mean)  
;;        Nsamples=n_elements(logdata)
;;        yhist = cgHistogram(logdata, binsize=binsize, min=alog(noiselevel/data_mean), locations=xhist, /frequency)/binsize
;;        xhist = xhist + 0.5*binsize
;;        peak = max(yhist,max_subscript)
;;;        yfit = GaussFit(xhist[0:10], yhist[0:10], coeff, NTERMS=3, chisq=chisquare)
;;        yfit = GaussFit(xhist, yhist, coeff, NTERMS=3, chisq=chisquare)
;;        print, 'peak =', peak, '    peak_subscript =', max_subscript
;;        print, 'A, mu, sigma:', coeff & print, 'chi square =',chisquare
;;        cgPlot, [xhist[0]-binsize, xhist, max(xhist)+binsize], [0, yhist, 0] $
;;              , psym=10, xstyle=9, ystyle=9 $
;;              , xtitle=textoidl('ln(T_{peak}/<T_{peak}>)'),ytitle='P(s)' $
;;              , /ylog,xrange=xrange,yrange=yrange, ytickformat='logticks_exp'
;;        cgColorFill, [xrange[0],xrange[0],alog(noiselevel/data_mean)*[1,1]],[yrange,reverse(yrange)], color='grey'
;;        cgOplot, xhist, yfit,color='green'
;;        cgplots,[1,1]*alog(noiselevel/data_mean),yrange,linestyle=2
;;        cgAxis, xaxis=0,xstyle=1,charsize=1.4
;;        cgAxis, xaxis=1,xstyle=1,charsize=1.4, xrange=exp(xrange)*data_mean,xlog=1
;;        cgText, mean(!X.Window), 0.48, /normal, alignment=0.5 $
;;              , 'T!Ipeak !N[K]'
;;        cgAxis, yaxis=0,ystyle=1,charsize=1.4, ytickformat='logticks_exp', yrange=yrange
;;        cgAxis, yaxis=1,ystyle=1,charsize=1.4, ytickformat='logticks_exp', yrange=yrange*Nsamples*binsize, ytitle=textoidl('Number of Pixels per bin')
;;        cgText, mean(!X.Window), 0.52, /normal, alignment=0.5, charsize=2 $
;;              , 'T!Ipeak!N C!E18!NO PDF of NGC 2264'
;;;        cgText, xrange[1]-1.5, yrange[1]/10.0, textoidl('\sigma = 0.37')
;;        cgText, [[0.25],[0.75]]#!X.Window, [[0.15],[0.85]]#!Y.Window, /normal, textoidl('\sigma = ')+string(coeff[2], format='(f0.2)')

print, "Order Index:"
;!P.multi = [0,1,2] & !Y.OMARGIN=[1,0]
;print, "Ord_Tpeak.eps"
;    if ~keyword_set(Ord_Tpeak_12CO) then Ord_Tpeak_12CO=[ 1.3224924, 42.790180, 7.0935912, -0.87374255, 0.50404475, 1.0000000, 0.49595525, 1.8739680, 65914.000]
;    if ~keyword_set(Ord_Tpeak_13CO) then Ord_Tpeak_13CO=[0.71230227, 16.741358, 2.6837254, -0.65622557, 0.32534619, 1.0000000, 0.67465381, 1.6567560, 32041.000]
;    if ~keyword_set(Ord_Tpeak_C18O) then Ord_Tpeak_C18O=[0.72617012, 4.0233297, 1.1916291,0.0055724050,0.022026789, 1.0000000, 0.97797321,0.99514847, 7238.0000]
;    device, filename='Ord_Tpeak.eps'
;        cgPlot, 0,  /nodata, /xlog, xrange=[1e-1,5e2], yrange=[-1.5,0.5] $
;              , title = textoidl('Order Index of Peak Intensity'), xtitle = textoidl('T [K]'), ytitle = 'Order Index'
;        cgOPlot, Ord_Tpeak_12CO[2], Ord_Tpeak_12CO[3], err_xlow =Ord_Tpeak_12CO[2]-Ord_Tpeak_12CO[0], err_xhigh=Ord_Tpeak_12CO[1]-Ord_Tpeak_12CO[2], psym=7, color='blue'
;        cgOPlot, Ord_Tpeak_13CO[2], Ord_Tpeak_13CO[3], err_xlow =Ord_Tpeak_13CO[2]-Ord_Tpeak_13CO[0], err_xhigh=Ord_Tpeak_13CO[1]-Ord_Tpeak_13CO[2], psym=7, color='green'
;        cgOPlot, Ord_Tpeak_C18O[2], Ord_Tpeak_C18O[3], err_xlow =Ord_Tpeak_C18O[2]-Ord_Tpeak_C18O[0], err_xhigh=Ord_Tpeak_C18O[1]-Ord_Tpeak_C18O[2], psym=7, color='red'
;        cgPlots, [Ord_Tpeak_12CO[2], Ord_Tpeak_13CO[2], Ord_Tpeak_C18O[2]], [Ord_Tpeak_12CO[3], Ord_Tpeak_13CO[3], Ord_Tpeak_C18O[3]], psym=7
;        cgLegend, Title=textoidl(['^{12}CO','^{13}CO','C^{18}O']),color=['blue','green','red'],Location=[5e1,0.25],/Data,/Addcmd, charsize=1.5, length=0.05
; 
;        cgPlot, 0,  /nodata, /xlog, xrange=[1e-1,5e2], yrange=[-1.5,0.5] $
;              , title = textoidl('Order Index of Peak Intensity'), xtitle = textoidl('T [K]'), ytitle = 'Order Index'
;        cgOPlot, Ord_Tpeak_12CO[2], Ord_Tpeak_12CO[4], err_xlow =Ord_Tpeak_12CO[2]-Ord_Tpeak_12CO[0], err_xhigh=Ord_Tpeak_12CO[1]-Ord_Tpeak_12CO[2], psym=7, color='blue'
;        cgOPlot, Ord_Tpeak_13CO[2], Ord_Tpeak_13CO[4], err_xlow =Ord_Tpeak_13CO[2]-Ord_Tpeak_13CO[0], err_xhigh=Ord_Tpeak_13CO[1]-Ord_Tpeak_13CO[2], psym=7, color='green'
;        cgOPlot, Ord_Tpeak_C18O[2], Ord_Tpeak_C18O[4], err_xlow =Ord_Tpeak_C18O[2]-Ord_Tpeak_C18O[0], err_xhigh=Ord_Tpeak_C18O[1]-Ord_Tpeak_C18O[2], psym=7, color='red'
;        cgPlots, [Ord_Tpeak_12CO[2], Ord_Tpeak_13CO[2], Ord_Tpeak_C18O[2]], [Ord_Tpeak_12CO[4], Ord_Tpeak_13CO[4], Ord_Tpeak_C18O[4]], psym=7
;        cgLegend, Title=textoidl(['^{12}CO','^{13}CO','C^{18}O']),color=['blue','green','red'],Location=[5e1,0.25],/Data,/Addcmd, charsize=1.5, length=0.05
;    device, /close_file





print,'12CO rms Histogram'
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
print, '13CO rms Histogram'
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
print, 'C18O rms Histogram'
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



print,"Tex Histogram: Tex_his.eps"
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
;    validdata=data[where(mask_data and finite(data) and Tpeak_12CO ge 3*Tmb_12CO_rms, count)]
;    print, 'Above 3 sigma statistics: sum     max     min     mean', data_sum, data_max, data_min, data_mean
;    !P.multi = [1,1,2] & device,filename='Tex_his.eps'
;        pdf_plot, validdata, min(validdata), /log $
;                , bin = 0.05, xrange=[-1.5,2.5],yrange=[1e-4,10] $
;                , title= textoidl('T_{ex} PDF of NGC 2264')  $
;                , x_log_title=textoidl('ln(T_{ex}/<T_{ex}>)') $
;                , x_natural_title=textoidl('T_{ex} [K]') $
;                , /fitting, fit_range=[0,31],statistics=Ord_Tex_12CO
;    device,/close_file
;;        binsize=0.05 &         xrange =[-1.5,2.5] & yrange =[1e-4,10]
;;        Nsamples=n_elements(logdata)
;;        yhist = cgHistogram(logdata, binsize=binsize, min=alog(noiselevel/data_mean),locations=xhist, /frequency)/binsize
;;        xhist = xhist + 0.5*binsize
;;        peak = max(yhist,max_subscript)
;;        yfit = GaussFit(xhist[0:10], yhist[0:10], coeff, NTERMS=3, chisq=chisquare)
;;;        yfit = GaussFit(xhist, yhist, coeff, NTERMS=3, chisq=chisquare)
;;        print, 'peak =', peak, '    peak_subscript =', max_subscript
;;        print, 'A, mu, sigma:', coeff & print, 'chi square =',chisquare
;;        cgPlot, [xhist[0]-binsize, xhist, max(xhist)+binsize], [0, yhist, 0] $
;;              , psym=10, xstyle=9, ystyle=9 $
;;              , xtitle=textoidl('ln(T_{ex}/<T_{ex}>)'),ytitle='P(s)' $
;;              , /ylog,xrange=xrange,yrange=yrange, ytickformat='logticks_exp'
;;        cgColorFill, [xrange[0],xrange[0],alog(noiselevel/data_mean)*[1,1]],[yrange,reverse(yrange)], color='grey'
;;        cgOplot, xhist, yfit,color='green'
;;        cgPlots,[1,1]*alog(noiselevel/data_mean),yrange,linestyle=2
;;        cgAxis,xaxis=0,xstyle=1,charsize=1.4
;;        cgAxis,xaxis=1,xstyle=1,charsize=1.4, xrange=exp(xrange)*data_mean,xlog=1
;;        cgText, mean(!X.Window), 0.48, /normal, alignment=0.5 $
;;              , textoidl('T_{ex} [K]')
;;        cgAxis,yaxis=0,ystyle=1, ytickformat='logticks_exp', yrange=yrange
;;        cgAxis,yaxis=1,ystyle=1, ytickformat='logticks_exp', yrange=yrange*Nsamples*binsize, ytitle=textoidl('Number of Pixels per bin')
;;        cgText, mean(!X.Window), 0.52, /normal, alignment=0.5, charsize=2 $
;;        cgText, [[0.25],[0.75]]#!X.Window, [[0.15],[0.85]]#!Y.Window, /normal, textoidl('\sigma = ')+string(coeff[2],format='(f0.2)')

print,"Integrated Intensities Histogram: Int_12CO_his.eps"
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
;            , /fitting, fit_range=[0,20], statistics=Ord_Wco_12CO
;    device,/close_file

print,"Integrated Intensities Histogram: Int_13CO_his.eps"
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
;            , /fitting, fit_range=[0,20], statistics=Ord_Wco_13CO
;    device,/close_file
 
print,"Integrated Intensities Histogram: Int_C18O_his.eps"
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
;                , /fitting, fit_range=[0,20], statistics=Ord_Wco_C18O
;    device, /close_file

print, "Ord_Wco.eps"
;!P.multi = [0,1,2] & !Y.OMARGIN=[1,0]
;    if ~keyword_set(Ord_Wco_12CO) then Ord_Wco_12CO=[ 3.7252448, 239.58263, 20.372179, -0.16509623,  0.19046788, 1.0000000, 0.80953212, 1.1656576, 73587.000]
;    if ~keyword_set(Ord_Wco_13CO) then Ord_Wco_13CO=[ 1.9523793, 61.412312, 5.5308766,0.0062692921, 0.026962361, 1.0000000, 0.97303764,0.99540589, 46556.000]
;    if ~keyword_set(Ord_Wco_C18O) then Ord_Wco_C18O=[0.98422050, 11.089736, 1.7612257,0.0011007177,0.0014352728, 1.0000000, 0.99856473,0.99899259, 23504.000]
;    device, filename='Ord_Wco.eps'
;        cgPlot, 0,  /nodata, /xlog, xrange=[1e-1,1e3], yrange=[-0.4,0.2] $
;              , title = textoidl('Order Index of Integrated Intensity'), xtitle = textoidl('Wco [K km s^{-1}]'), ytitle = 'Order Index'
;        cgOPlot, Ord_Wco_12CO[2], Ord_Wco_12CO[3], err_xlow =Ord_Wco_12CO[2]-Ord_Wco_12CO[0], err_xhigh=Ord_Wco_12CO[1]-Ord_Wco_12CO[2], psym=7, color='blue'
;        cgOPlot, Ord_Wco_13CO[2], Ord_Wco_13CO[3], err_xlow =Ord_Wco_13CO[2]-Ord_Wco_13CO[0], err_xhigh=Ord_Wco_13CO[1]-Ord_Wco_13CO[2], psym=7, color='green'
;        cgOPlot, Ord_Wco_C18O[2], Ord_Wco_C18O[3], err_xlow =Ord_Wco_C18O[2]-Ord_Wco_C18O[0], err_xhigh=Ord_Wco_C18O[1]-Ord_Wco_C18O[2], psym=7, color='red'
;        cgPlots, [Ord_Wco_12CO[2], Ord_Wco_13CO[2], Ord_Wco_C18O[2]], [Ord_Wco_12CO[3], Ord_Wco_13CO[3], Ord_Wco_C18O[3]], psym=7
;        cgLegend, Title=textoidl(['^{12}CO','^{13}CO','C^{18}O']),color=['blue','green','red'],Location=[1e2,0.15],/Data,/Addcmd, charsize=1.5, length=0.05
;        cgPlot, 0,  /nodata, /xlog, xrange=[1e-1,1e3], yrange=[-0.4,0.2] $
;              , title = textoidl('Order Index of Integrated Intensity'), xtitle = textoidl('Wco [K km s^{-1}]'), ytitle = 'Order Index'
;        cgOPlot, Ord_Wco_12CO[2], Ord_Wco_12CO[4], err_xlow =Ord_Wco_12CO[2]-Ord_Wco_12CO[0], err_xhigh=Ord_Wco_12CO[1]-Ord_Wco_12CO[2], psym=7, color='blue'
;        cgOPlot, Ord_Wco_13CO[2], Ord_Wco_13CO[4], err_xlow =Ord_Wco_13CO[2]-Ord_Wco_13CO[0], err_xhigh=Ord_Wco_13CO[1]-Ord_Wco_13CO[2], psym=7, color='green'
;        cgOPlot, Ord_Wco_C18O[2], Ord_Wco_C18O[4], err_xlow =Ord_Wco_C18O[2]-Ord_Wco_C18O[0], err_xhigh=Ord_Wco_C18O[1]-Ord_Wco_C18O[2], psym=7, color='red'
;        cgPlots, [Ord_Wco_12CO[2], Ord_Wco_14CO[2], Ord_Wco_C18O[2]], [Ord_Wco_12CO[4], Ord_Wco_13CO[4], Ord_Wco_C18O[4]], psym=7
;        cgLegend, Title=textoidl(['^{12}CO','^{13}CO','C^{18}O']),color=['blue','green','red'],Location=[1e2,0.15],/Data,/Addcmd, charsize=1.5, length=0.05
;    device, /close_file

       
print, 'FWHM Histogram: 12CO'
;    fits_read, "Tfwhm_12CO.fits", data, hdr
;    print,max(data),min(data),mean(data)
;    fits_read,"Tpeak_12CO.fits", Tpeak, Tpeakhdr
;    fits_read,'Vcenter_12CO.fits',Vdata,Vhdr
;    print, Format='("Confined by 3*RMS, Velocity Range, and Above 0")'
;    help, where(Tpeak gt 3*Tmb_12CO_rms and mask_data, count)
;    help, where(Vdata gt -30 and Vdata lt 75, count)
;    help, where(data ge 0 and mask_data, count)
;    validdata=data[where(data ge 2*dv_12CO and Vdata gt -30 and Vdata lt 75 and Tpeak gt 3*Tmb_12CO_rms and mask_data, complement=c_indices)]
;    help,validdata
;    error_data=mask_data & error_data[c_indices]=0 & tvscl, error_data
;    print,max(validdata),min(validdata),mean(validdata)
;    threshold = dv_12CO*3
;    print, 'Above Threshold: ', size(where(validdata gt threshold)) ; 4.4002
;    !P.Multi=[1,1,2] & device,filename='Tfwhm_12CO_his.eps',/encapsulated
;        pdf_plot, validdata, threshold, /log $
;                , binsize=0.1, xrange=[-3,3], yrange=[1e-4,1e1] $
;                , title='!E12!NCO Line Width PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(\DeltaV/<\DeltaV>)') $  
;                , x_natural_title=textoidl('\DeltaV')+' [km s!E-1!N]' $
;                , /fitting, fit_range=[0,14], statistics=Ord_LineWidth_12CO
;    device, /close_file
print, 'Vcenter Histogram: 12CO'
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
;    fits_read, "Tpeak_13CO.fits", Tpeak, TpeakHdr
;    fits_read, "Vcenter_13CO.fits", VcData, VcHdr
;    print, Format='("Confined by 3*RMS, Velocity Range, and Above 0")'
;    help, where(Tpeak gt 3*Tmb_13CO_rms and mask_data, count)
;    help, where(VcData gt -30 and VcData lt 75, count)
;    help, where(data ge 0 and mask_data, count)
;    validdata=data[where(data ge 2*dv_13CO and VcData gt -30 and VcData lt 75 and Tpeak gt 3*Tmb_13CO_rms and mask_data, count, complement=c_indices)]
;    help, validdata
;    error_data=mask_data & error_data[c_indices]=0 & tvscl, error_data
;    print,max(validdata),min(validdata),mean(validdata)
;    threshold = dv_13CO*3
;    !P.Multi=[1,1,2] & device,filename='Tfwhm_13CO_his.eps',/encapsulated
;        pdf_plot, validdata, threshold, /log $
;                , binsize=0.1, xrange=[-3,3], yrange=[1e-4,1e1]  $
;                , title='!E13!NCO Line Width PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(\DeltaV/<\DeltaV>)') $
;                , x_natural_title=textoidl('\Delta V')+' [km s!E-1!N]' $
;                , /fitting, fit_range=[0,18], statistics=Ord_LineWidth_13CO
;    device,/close_file
print, 'Vcenter Histogram: 13CO'
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
;    fits_read,"Tfwhm_C18O.fits",data,hdr
;    print,max(data),min(data),mean(data)
;    fits_read, "Tpeak_C18O.fits", Tpeak, TpeakHdr
;    fits_read, "Vcenter_C18O.fits", VcData, VcHdr
;    print, Format='("Confined by 3*RMS, Velocity Range, and Above 0")'
;    help, where(Tpeak gt 3*Tmb_C18O_rms and mask_data, count)
;    help, where(VcData gt -30 and VcData lt 70, count)
;    help, where(data ge 0 and mask_data, count)
;    validdata=data[where(data ge 2*dv_C18O and VcData gt -30 and VcData lt 70 and Tpeak gt 3*Tmb_C18O_rms and mask_data, count, complement=c_indices)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    error_data=mask_data & error_data[c_indices]=0 & tvscl, error_data
;    threshold = dv_C18O*3
;    !P.Multi=[1,1,2] & device,filename='Tfwhm_C18O_his.eps',/encapsulated
;        pdf_plot, validdata, threshold, /log $
;                , binsize=0.1, xrange=[-3,3],yrange=[1e-4,1e1] $
;                , title='C!E18!NO Line Width PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(\DeltaV/<\DeltaV>)') $
;                , x_natural_title=textoidl('\Delta V')+' [km s!E-1!N]'$
;                , /fitting, fit_range=[0,12], statistics=Ord_LineWidth_C18O
;    device,/close_file
print, 'Vcenter Histogram: C18O'
;    validdata=vdata[where(vdata gt -30 and vdata lt 70)]
;    print,max(vdata),min(vdata),mean(vdata)
;    print,max(validdata),min(validdata),mean(validdata)
;    help,validdata
;    device,filename='Vcenter_C18O_his.eps',/encapsulated
;        plothist,validdata,bin=0.5,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2 $
;               ,title='C!E18!NO V PDF of NGC 2264', xtitle='V (km s!E-1!N)', ytitle='Number' $
;               ,/ylog,xrange=[-15,35],yrange=[0.5e2,0.5e5]
;    device,/close_file

print, "Ord_LineWidth.eps"
;!P.multi = [0,1,2] & !Y.OMARGIN=[1,0]
;    if ~keyword_set(Ord_LineWidth_12CO) then Ord_LineWidth_12CO=[ 0.48061946, 12.238918, 2.6454179,  0.33867325,  0.57708395, 1.0000000, 0.42291605, 0.65335035, 61992.000]
;    if ~keyword_set(Ord_LineWidth_13CO) then Ord_LineWidth_13CO=[ 0.50418258, 11.463876, 1.8228208,-0.028222372, 0.072113644, 1.0000000, 0.92788636,  1.0221052, 25800.000]
;    if ~keyword_set(Ord_LineWidth_C18O) then Ord_LineWidth_C18O=[ 0.50428367, 11.524139, 1.2053404, 0.054262020,  0.15248276, 1.0000000, 0.84751724, 0.94636196, 2921.0000]
;    device, filename='Ord_LineWidth.eps'
;        cgPlot, 0,  /nodata, /xlog, xrange=[1e-1,1e2], yrange=[-0.4,0.6] $
;              , title = textoidl('Order Index of Line Width'), xtitle = textoidl('Line Width [km s^{-1}]'), ytitle = 'Order Index'
;        cgOPlot, Ord_LineWidth_12CO[2], Ord_LineWidth_12CO[3], err_xlow =Ord_LineWidth_12CO[2]-Ord_LineWidth_12CO[0], err_xhigh=Ord_LineWidth_12CO[1]-Ord_LineWidth_12CO[2], psym=7, color='blue'
;        cgOPlot, Ord_LineWidth_13CO[2], Ord_LineWidth_13CO[3], err_xlow =Ord_LineWidth_13CO[2]-Ord_LineWidth_13CO[0], err_xhigh=Ord_LineWidth_13CO[1]-Ord_LineWidth_13CO[2], psym=7, color='green'
;        cgOPlot, Ord_LineWidth_C18O[2], Ord_LineWidth_C18O[3], err_xlow =Ord_LineWidth_C18O[2]-Ord_LineWidth_C18O[0], err_xhigh=Ord_LineWidth_C18O[1]-Ord_LineWidth_C18O[2], psym=7, color='red'
;        cgPlots, [Ord_LineWidth_12CO[2], Ord_LineWidth_13CO[2], Ord_LineWidth_C18O[2]], [Ord_LineWidth_12CO[3], Ord_LineWidth_13CO[3], Ord_LineWidth_C18O[3]], psym=7
;        cgLegend, Title=textoidl(['^{12}CO','^{13}CO','C^{18}O']),color=['blue','green','red'],Location=[2e1,0.35],/Data,/Addcmd, charsize=1.5, length=0.05
;    device, /close_file

print,"tau 13CO Histogram"
;    fits_read,"tau_13CO.fits",data,hdr
;    print, Format = '("Confined by 3*RMS, and  tau is finite & no less than 0.")'
;    help, where(Tpeak_12CO ge 3*Tmb_12CO_rms and mask_data, count)
;    help, where(Tpeak_13CO ge 3*Tmb_13CO_rms and mask_data, count)
;    help, where(Tpeak_13CO gt Tpeak_12CO and mask_data, count)
;    help, where(finite(data) and mask_data, count)
;    help, where(data ge 0 and mask_data, count)
;    validdata=data[where(finite(data) and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_13CO ge 3*Tmb_13CO_rms and mask_data, count, complement=c_indices)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    print,'above noise: ', size(where(validdata gt noiselevel))
;    !P.multi = [1,1,2] & !Y.OMARGIN=[1,0]          ; !x.margin=[8,8] & !y.margin=[4,4]
;    device,filename='tau_13CO_his.eps',/encapsulated
;        pdf_plot, validdata, min(validdata), /log $
;                , binsize=0.1, xrange=[-4,4], yrange=[1e-4,10] $
;                , title='!7s!X!N C!E13!NO PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(\tau/<\tau>)') $
;                , x_natural_title='!7s!X' $
;                , /fitting,fit_range=[0,24],statistics=Ord_tau_13CO
;    device,/close_file

print,"tau C18O Histogram"
;    fits_read,"tau_C18O.fits",data,hdr
;    print, Format = '("Confined by 3*RMS, and tau is finite & no less than 0.")'
;    help, where(Tpeak_12CO ge 3*Tmb_12CO_rms and mask_data, count)
;    help, where(Tpeak_C18O ge 3*Tmb_C18O_rms and mask_data, count)
;    help, where(Tpeak_C18O gt Tpeak_12CO and mask_data, count)
;    help, where(finite(data) and mask_data, count)
;    help, where(data ge 0 and mask_data, count)
;    validdata=data[where(finite(data) and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_C18O ge 3*Tmb_C18O_rms and mask_data, count, complement=c_indices)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;    print,'above noise: ', size(where(validdata gt noiselevel))
;    !P.multi = [1,1,2] & !Y.OMARGIN=[1,0]          ; !x.margin=[8,8] & !y.margin=[4,4]
;    device,filename='tau_C18O_his.eps',/encapsulated
;        pdf_plot, validdata, min(validdata), /log $
;                , binsize=0.1, xrange=[-4,4], yrange=[1e-4,10] $
;                , title='!7s!X C!E18!NO PDF of NGC 2264' $
;                , x_log_title=textoidl('ln(\tau/<\tau>)') $
;                , x_natural_title='!7s!X'  $
;                , /fitting, fit_range=[0,14],statistics=Ord_tau_C18O;
;    device,/close_file

print,"Ord_tau.eps"
;!P.multi = [0,1,2] & !Y.OMARGIN=[1,0]
;    if ~keyword_set(Ord_tau_13CO) then Ord_tau_13CO=[0.057865050, 5.3566065, 0.35368386, -0.0095768378, 0.044128056, 1.0000000, 0.95587194, 1.0002989, 29153.000]
;    if ~keyword_set(Ord_tau_C18O) then Ord_tau_C18O=[0.020618739, 5.4498844, 0.22399822,    0.41241149,  0.62330100, 1.0000000, 0.37669900,0.59180080, 5025.0000]
;     device, filename='Ord_tau.eps'
;        cgPlot, 0,  /nodata, /xlog, xrange=[1e-2,1e1], yrange=[-0.5,1.0] $
;              , title = textoidl('Order Index of \tau'), xtitle = textoidl('\tau'), ytitle = 'Order Index'
;        cgOPlot, Ord_tau_13CO[2], Ord_tau_13CO[3], err_xlow =Ord_tau_13CO[2]-Ord_tau_13CO[0], err_xhigh=Ord_tau_13CO[1]-Ord_tau_13CO[2], psym=7, color='green'
;        cgOPlot, Ord_tau_C18O[2], Ord_tau_C18O[3], err_xlow =Ord_tau_C18O[2]-Ord_tau_C18O[0], err_xhigh=Ord_tau_C18O[1]-Ord_tau_C18O[2], psym=7, color='red'
;        cgPlots, [Ord_tau_13CO[2], Ord_tau_C18O[2]], [Ord_tau_13CO[3], Ord_tau_C18O[3]], psym=7
;        cgLegend, Title=textoidl(['^{13}CO','C^{18}O']),color=['green','red'],Location=[2e+0,0.75],/Data,/Addcmd, charsize=1.5, length=0.05
;    device, /close_file

print,"Nco Histogram: Nco_13CO_his.eps"
    fits_read, "S287_Nco_Wco_13CO"+SubRegion+".fits", data,hdr
    fits_read, 'S287_Wco_13CO'    +SubRegion+'.fits', WcoData,WcoHdr
    print, Format = '("Confined by 3*RMS, of Tpeak_12CO and Wco_13CO.")'
    help, where(finite(data) and mask_data, count)
    help, where(WcoData ge 3 * Tmb_13CO_rms*sqrt(Vwidth*0.167) and mask_data, count)
    validdata=data[where(WcoData ge 3 * Tmb_13CO_rms*sqrt(Vwidth*0.167) and Tpeak_12CO ge 3*Tmb_12CO_rms and mask_data, count, complement=c_indices)]  ; 1.6956942e+18
    help, validdata
    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
    print,sum,max,min,mean
    !P.multi = [1,1,2] & device,filename='S287_Nco_Wco_13CO'+SubRegion+'_his.eps'
        pdf_plot, validdata, min(validdata)>0.1, /log $
                , bin=0.1, xrange=[-2,3], yrange=[1e-3,10] $
                , title='N(!E13!NCO) PDF of NGC 2264' $
                , x_log_title=textoidl("ln(N_{CO}/<N_{CO}>)") $
                , x_natural_title='CO Conlumn Densities (cm!E-2!N)' $
                , /fitting, fit_range=[0,26],statistics=Ord_Nco_13CO, /Order
    device,/close_file



print,"Nco Histogram: Nco_13CO_Tpeak_his.eps"
;    fits_read,"Nco_Tpeak_13CO.fits",data,hdr
;    print, Format='("Confined by 3*RMS, Velocity Range, and Vfwhm above channel width")'
;    validdata=data[where(mask_data and Vc_13CO gt -30 and Vc_13CO lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_13CO ge 3*Tmb_13CO_rms and Vfwhm_13CO ge 3*dv_13CO, count)]
;    help,validdata
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    !P.multi = [1,1,2] & device,filename='Nco_13CO_Tpeak_his.eps'
;        pdf_plot, validdata, min(validdata), /log $
;                , bin = 0.1, xrange=[-5,6],yrange=[1e-4,10] $
;                , title='N(!E13!NCO) PDF of NGC 2264, T!Ipeak!N' $
;                , x_log_title=textoidl("ln(N_{CO}/<N_{CO}>)") $
;                , x_natural_title='CO Conlumn Densities (cm!E-2!N)' $
;                , /fitting, fit_range=[0,45],statistics=Ord_Nco_13COp, /Order
;    device,/close_file
 
print,"Nco Histogram: Nco_13CO_tau_his.eps"
;    fits_read,"Nco_tau_13CO.fits",data,hdr
;    print, Format='("Confined by 3*RMS, Velocity Range, Velocity Width, and tau above 0")'
;    validdata=data[where(mask_data and Vfwhm_13CO ge 3*dv_13CO and Vc_13CO gt -30 and Vc_13CO lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_13CO ge 3*Tmb_13CO_rms and tau_13CO ge 0, count)]
;    help,validdata
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    !P.multi = [1,1,2] & device,filename='Nco_13CO_tau_his.eps'
;        pdf_plot, validdata, min(validdata), /log $
;               , bin = 0.1, xrange=[-5,6],yrange=[1e-4,10] $
;               , title='N(!E13!NCO) PDF of NGC 2264, !7s!X' $
;               , x_log_title=textoidl("ln(N_{CO}/<N_{CO}>)") $
;               , x_natural_title='CO Conlumn Densities (cm!E-2!N)' $
;               , /fitting, fit_range=[0,41],statistics=Ord_Nco_13COt, /Order
;    device,/close_file

print,"Nco Histogram: Nco_C18O_his.eps"
    fits_read, "S287_Nco_Wco_C18O"+SubRegion+".fits", data,hdr
    fits_read, 'S287_Wco_C18O'    +SubRegion+'.fits', WcoData,WcoHdr
    print, Format = '("Confined by 3*RMS, of Tpeak_12CO and Wco_C18O.")'
    help, where(finite(data) and mask_data, count)
    help, where(WcoData ge 3 * Tmb_C18O_rms*sqrt(Vwidth*0.167) and mask_data, count)
    validdata=data[where(WcoData ge 3 * Tmb_C18O_rms*sqrt(Vwidth*0.167) and Tpeak_12CO ge 3*Tmb_12CO_rms and mask_data, count, complement=c_indices)]  ; 2.3637384e+17
;    validdata=data[where(Tpeak_C18O ge Tmb_C18O_rms*3 and Tpeak_12CO ge 3*Tmb_12CO_rms and mask_data, count, complement=c_indices)]  ; 2.3637384e+17
    help,validdata
    !P.multi = [1,1,2] & device,filename='S287_Nco_Wco_C18O'+SubRegion+'_his.eps'
        pdf_plot, validdata, min(validdata)>0.1, /log $
                , bin = 0.1, xrange=[-3,4], yrange=[1e-3,10] $
                , title='N(C!E18!NO) PDF of NGC 2264' $
                , x_log_title=textoidl("ln(N_{CO}/<N_{CO}>)") $
                , x_natural_title='CO Conlumn Densities (cm!E-2!N)' $
                , /fitting, fit_range=[0,12],statistics=Ord_Nco_C18O, /Order
    device,/close_file

print,"Nco Histogram: Nco_C18O_Tpeak_his.eps"
;    fits_read,"Nco_Tpeak_C18O.fits",data,hdr
;    print, Format='("Confined by 3*RMS, Velocity Range, and Vfwhm above channel width")'
;    validdata=data[where(mask_data and Vc_C18O gt -30 and Vc_C18O lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_C18O ge 3*Tmb_C18O_rms and Vfwhm_C18O ge dv_C18O, count)]
;    help,validdata
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    !P.multi = [1,1,2] & device,filename='Nco_C18O_Tpeak_his.eps'
;        pdf_plot, validdata, min(validdata), /log $
;                , bin = 0.1, xrange=[-5,6],yrange=[1e-3,10] $
;                , title='N(C!E18!NO) PDF of NGC 2264, T!Ipeak!N' $
;                , x_log_title=textoidl("ln(N_{CO}/<N_{CO}>)") $
;                , x_natural_title='CO Conlumn Densities (cm!E-2!N)' $
;                , /fitting, fit_range=[0,21],statistics=Ord_Nco_C18Op, /Order
;    device,/close_file
  
print,"Nco Histogram: Nco_C18O_tau_his.eps"
;    fits_read,"Nco_tau_C18O.fits",data,hdr
;    print, Format='("Confined by 3*RMS, Velocity Range, Velocity Width, and tau above 0")'
;    validdata=data[where(mask_data and Vfwhm_C18O ge dv_C18O and Vc_C18O gt -30 and Vc_C18O lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_C18O ge 3*Tmb_C18O_rms and tau_C18O ge 0, count)]
;    help, validdata
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    !P.multi = [1,1,2] & device,filename='Nco_C18O_tau_his.eps'
;        pdf_plot, validdata, min(validdata), /log $
;               , bin = 0.1, xrange=[-5,6],yrange=[1e-3,10] $
;               , title='N(C!E18!NO) PDF of NGC 2264,!7s!X' $
;               , x_log_title=textoidl("ln(N_{CO}/<N_{CO}>)") $
;               , x_natural_title='CO Conlumn Densities (cm!E-2!N)' $
;               , /fitting, fit_range=[0,16],statistics=Ord_Nco_C18Ot, /Order
;    device,/close_file
    
print, "Ord_Nco.eps"
;;                      min          max      average         ord      coverage
;    if ~keyword_set(Ord_Nco_13CO)  then Ord_Nco_13CO = [ 6.83140e14,  1.09140e17,  4.28463e15,  0.19866160,   0.28911916]
;;   6.6684866e+11   1.0914004e+17   5.9527747e+15       1.0000000       1.0000000       1.0000000       0.0000000             NaN       27187.000
;;   7.3751863e+14   1.0914004e+17   5.2364644e+15      0.20936183      0.34986518       1.0000000      0.65013482      0.80174518       34486.000
;
;    if ~keyword_set(Ord_Nco_13COp) then Ord_Nco_13COp= [ 4.37390e13,  1.02712e17,  1.63038e15,  0.31816266,   0.36133862]
;;   1.3866174e+14   1.0271233e+17   5.6784691e+15      0.40915732      0.84165490      0.99999999      0.15834510      0.59048566       25228.000
;;   1.3866174e+14   1.0271233e+17   5.6784691e+15     -0.30808388      0.42627872      0.99999999      0.57372128       1.3099816       25228.000
;
;    if ~keyword_set(Ord_Nco_13COt) then Ord_Nco_13COt= [ 1.16823e14,  1.57572e17,  2.72596e15,  0.30588279,   0.37614745]
;;   1.1595735e+14   1.5757185e+17   7.6321515e+15      0.84049197      0.85959428       1.0000000      0.14040572      0.16387309       28341.000
;;   3.2999653e+14   1.5757185e+17   8.5237942e+15    -0.038363801      0.73569819      0.99999999      0.26430181       1.0395891       25208.000
;
;    if ~keyword_set(Ord_Nco_C18O)  then Ord_Nco_C18O = [ 1.06341e14,  1.79400e16,  8.97057e14, 0.090113252,   0.26080324]
;;   4.2748907e+11   1.7940021e+16   1.6265692e+15       1.0000000       1.0000000       1.0000000       0.0000000             NaN       4342.0000
;;   3.4205167e+14   1.7940021e+16   1.1916164e+15     0.090430034      0.11014053       1.0000000      0.88985947      0.91936198       13400.000
;
;    if ~keyword_set(Ord_Nco_C18Op) then Ord_Nco_C18Op= [ 4.05716e13,  1.90482e16,  5.70970e14,  0.20566850,   0.26908294]           
;;   4.3376531e+13   1.9048195e+16   1.1809343e+15      0.45106614      0.51439914       1.0000000      0.48560086      0.55807502       4582.0000
;
;    if ~keyword_set(Ord_Nco_C18Ot) then Ord_Nco_C18Ot= [ 1.06860e14,  2.24333e16,  8.16400e14,  0.23357618,   0.29637332]
;;   1.1073495e+14   2.2427825e+16   1.5225262e+15      0.44289829      0.53156728       1.0000000      0.46843272      0.56909617       4552.0000
;
;
;!P.multi = [0,1,2] & !Y.OMARGIN=[1,0]
;    device, filename='Ord_Nco.eps'
;        cgPlot, 0,  /nodata, /xlog, xrange=[1e13,1e19], yrange=[-0.2,0.8] $
;              , title = textoidl('Deviation from LN of N_{CO}'), xtitle = textoidl('N_{CO} [cm^{-2}]'), ytitle = 'Deviation'
;        cgOPlot, Ord_Nco_13CO[2], Ord_Nco_13CO[3], err_xlow =Ord_Nco_13CO[2]-Ord_Nco_13CO[0], err_xhigh=Ord_Nco_13CO[1]-Ord_Nco_13CO[2], psym=7, color='green'
;        cgOPlot, Ord_Nco_C18O[2], Ord_Nco_C18O[3], err_xlow =Ord_Nco_C18O[2]-Ord_Nco_C18O[0], err_xhigh=Ord_Nco_C18O[1]-Ord_Nco_C18O[2], psym=7, color='red'
;        cgPlots, [Ord_Nco_13CO[2], Ord_Nco_C18O[2]], [Ord_Nco_13CO[3], Ord_Nco_C18O[3]], psym=7
;        cgLegend, Title=textoidl(['^{13}CO','C^{18}O']),color=['green','red'],Location=[5e17,0.7],/Data,/Addcmd, charsize=1.5, length=0.05
;
;        cgOPlot, Ord_Nco_13COp[2], Ord_Nco_13COp[3], err_xlow =Ord_Nco_13COp[2]-Ord_Nco_13COp[0], err_xhigh=Ord_Nco_13COp[1]-Ord_Nco_13COp[2], psym=5, color='green'
;        cgOPlot, Ord_Nco_13COt[2], Ord_Nco_13COt[3], err_xlow =Ord_Nco_13COt[2]-Ord_Nco_13COt[0], err_xhigh=Ord_Nco_13COt[1]-Ord_Nco_13COt[2], psym=4, color='green'
;        cgOPlot, Ord_Nco_C18Op[2], Ord_Nco_C18Op[3], err_xlow =Ord_Nco_C18Op[2]-Ord_Nco_C18Op[0], err_xhigh=Ord_Nco_C18Op[1]-Ord_Nco_C18Op[2], psym=5, color='red'
;        cgOPlot, Ord_Nco_C18Ot[2], Ord_Nco_C18Ot[3], err_xlow =Ord_Nco_C18Ot[2]-Ord_Nco_C18Ot[0], err_xhigh=Ord_Nco_C18Ot[1]-Ord_Nco_C18Ot[2], psym=4, color='red'
;        cgPlots, [Ord_Nco_13COp[2], Ord_Nco_C18Op[2]], [Ord_Nco_13COp[3], Ord_Nco_C18Op[3]], psym=5
;        cgPlots, [Ord_Nco_13COt[2], Ord_Nco_C18Ot[2]], [Ord_Nco_13COt[3], Ord_Nco_C18Ot[3]], psym=4
;        cgLegend, Title=textoidl(['1','2','3']),Psym=[7,5,4],Location=[5e13,0.7],/Data, /Center_Sym, Length=0, charsize=1.5
;
;        cgPlot, 0,  /nodata, /xlog, xrange=[1e13,1e19], yrange=[-0.2,1.0] $
;              , title = textoidl('Order Index of N_{CO}'), xtitle = textoidl('N_{CO} [cm^{-2}]'), ytitle = 'Order Index'
;        cgOPlot, Ord_Nco_13CO[2], Ord_Nco_13CO[4], err_xlow =Ord_Nco_13CO[2]-Ord_Nco_13CO[0], err_xhigh=Ord_Nco_13CO[1]-Ord_Nco_13CO[2], psym=7, color='green'
;        cgOPlot, Ord_Nco_C18O[2], Ord_Nco_C18O[4], err_xlow =Ord_Nco_C18O[2]-Ord_Nco_C18O[0], err_xhigh=Ord_Nco_C18O[1]-Ord_Nco_C18O[2], psym=7, color='red'
;        cgPlots, [Ord_Nco_13CO[2], Ord_Nco_C18O[2]], [Ord_Nco_13CO[4], Ord_Nco_C18O[4]], psym=7
;        cgLegend, Title=textoidl(['^{13}CO','C^{18}O']),color=['green','red'],Location=[5e17,0.9],/Data,/Addcmd, charsize=1.5, length=0.05
;
;        cgOPlot, Ord_Nco_13COp[2], Ord_Nco_13COp[4], err_xlow =Ord_Nco_13COp[2]-Ord_Nco_13COp[0], err_xhigh=Ord_Nco_13COp[1]-Ord_Nco_13COp[2], psym=5, color='green'
;        cgOPlot, Ord_Nco_13COt[2], Ord_Nco_13COt[4], err_xlow =Ord_Nco_13COt[2]-Ord_Nco_13COt[0], err_xhigh=Ord_Nco_13COt[1]-Ord_Nco_13COt[2], psym=4, color='green'
;        cgOPlot, Ord_Nco_C18Op[2], Ord_Nco_C18Op[4], err_xlow =Ord_Nco_C18Op[2]-Ord_Nco_C18Op[0], err_xhigh=Ord_Nco_C18Op[1]-Ord_Nco_C18Op[2], psym=5, color='red'
;        cgOPlot, Ord_Nco_C18Ot[2], Ord_Nco_C18Ot[4], err_xlow =Ord_Nco_C18Ot[2]-Ord_Nco_C18Ot[0], err_xhigh=Ord_Nco_C18Ot[1]-Ord_Nco_C18Ot[2], psym=4, color='red'
;        cgPlots, [Ord_Nco_13COp[2], Ord_Nco_C18Op[2]], [Ord_Nco_13COp[4], Ord_Nco_C18Op[4]], psym=5
;        cgPlots, [Ord_Nco_13COt[2], Ord_Nco_C18Ot[2]], [Ord_Nco_13COt[4], Ord_Nco_C18Ot[4]], psym=4
;        cgLegend, Title=textoidl(['1','2','3']),Psym=[7,5,4],Location=[5e13,0.9],/Data, /Center_Sym, Length=0, charsize=1.5
;    device, /close_file


print,"N_H2 Histogram: N_H2_12CO_his.eps"
    fits_read,"S287_N_H2_Wco_12CO"+SubRegion+".fits",data,hdr
    validdata=data[where(mask_data, count)]      ;4.326871e+22
    help,validdata
    image_statistics, validdata, data_sum=data_sum, maximum=data_max, mean=data_mean, minimum=data_min
    print, 'raw data statistics:   sum   max   min   mean',data_sum,data_max,data_min,data_mean
    noiselevel =  3 * Tmb_12CO_rms * sqrt(Vwidth*0.159) * 1.8e20    ;6.69931e20
;    print, 'above noise: ', size(where(validdata ge noiselevel))
    signaldata=validdata(where(validdata ge noiselevel))
    help, signaldata
    image_statistics, signaldata, data_sum=data_sum, maximum=data_max, mean=data_mean, minimum=data_min
    print, 'above 3 sigma statistics: sum   max   min   mean',data_sum,data_max,data_min,data_mean
    print,'Mass (Msun) from 12CO x-factor:   raw data       valid data           above 3 sigma'
    print, mass(data,distance), mass(validdata,distance), mass(signaldata,distance)
    !P.multi = [1,1,2] & device,filename='S287_N_H2_Wco_12CO'+SubRegion+'_his.eps',/encapsulated
        pdf_plot, validdata, noiselevel, /log $
                , bin=0.1, xrange=[-3,4], yrange=[1e-4,1e1] $
                , title='N(H!I2!N) from !E12!NCO PDF of NGC 2264' $
                , x_log_title=textoidl('ln(N_{H_2}/<N_{H_2}>)') $
                , x_natural_title='H!I2!N Conlumn Densities (cm!E-2!N)' $
                , /fitting, fit_range=[0,20],statistics=Ord_N_H2_12CO, /Order
    device,/close_file

   

print,"N_H2 Histogram: N_H2_13CO_his.eps"
    fits_read, "S287_N_H2_Wco_13CO"+SubRegion+".fits", data,hdr
    fits_read, 'S287_Wco_13CO'     +SubRegion+'.fits', WcoData,WcoHdr
;    noiselevel =  3 * Tmb_12CO_rms * sqrt(50*0.159) * 1.8e20    ;6.69931e20
;    validdata=data[where(mask_data, count)]   ;4.326871e+26
;    signaldata=validdata(where(validdata ge noiselevel))

    print, Format = '("Confined by 3*RMS, of Tpeak_12CO and Wco_13CO.")'
    help, where(finite(data) and mask_data, count)
    help, where(WcoData ge 3 * Tmb_13CO_rms*sqrt(Vwidth*0.167) and mask_data, count)
    validdata=data[where(WcoData ge 3 * Tmb_13CO_rms*sqrt(Vwidth*0.167) and Tpeak_12CO ge 3*Tmb_12CO_rms and mask_data, count, complement=c_indices)]  ; 1.6956942e+18
    help,validdata
;    threshold = 1.49e20 * 3 * Tmb_13CO_rms * sqrt(45*dv_13CO)/(1-exp(-5.289/3.75)) > min(validdata)
    threshold = min(validdata)
    signaldata = validdata[where(validdata ge threshold)]
    print,max(validdata),min(validdata),mean(validdata)
    print,'Mass (Msun) from 13CO:   raw data       valid data           above 3 sigma'
    print, mass(data,distance), mass(validdata,distance), mass(signaldata,distance)
    !P.multi = [1,1,2] & device,filename='S287_N_H2_Wco_13CO'+SubRegion+'_his.eps',/encapsulated
        pdf_plot, validdata, threshold, /log $
                , bin=0.1, xrange=[-3,4], yrange=[1e-4,1e1] $
                , title='N(H!I2!N) from !E13!NCO PDF of NGC 2264' $
                , x_log_title=textoidl('ln(N_{H_2}/<N_{H_2}>)') $
                , x_natural_title='H!I2!N Conlumn Densities (cm!E-2!N)' $
                , /fitting, fit_range=[0,26],statistics=Ord_N_H2_13CO, /Order
    device,/close_file

;

print,"N_H2 Histogram: N_H2_13CO_Tpeak_his.eps"
;    fits_read,"N_H2_Nco_Tpeak_13CO.fits",data,hdr
;    print, Format='("Confined by 3*RMS, Velocity Range, and Vfwhm above channel width")'
;;    validdata=data[where(mask_data and Vc_13CO gt -30 and Vc_13CO lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_13CO ge 3*Tmb_13CO_rms and Vfwhm_13CO ge dv_13CO, count)]
;    validdata=data[where(mask_data and Vc_13CO gt -30 and Vc_13CO lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_13CO ge 3*Tmb_13CO_rms and Vfwhm_13CO ge 3*dv_13CO, count)]
;
;    help,validdata
;    print,'Mass: ', mass(validdata,distance), ' Msun from 13CO column density'
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;;    threshold = 1.49e20 * 2 * Tmb_13CO_rms * 5 * dv_13CO/(1-exp(-5.289/3.75)) > min(validdata)
;    threshold = min(validdata)
;    !P.multi = [1,1,2] & device,filename='N_H2_13CO_Tpeak_his.eps',/encapsulated
;        pdf_plot, validdata, threshold, /log $
;               , bin=0.1, xrange=[-5,6], yrange=[1e-4,1e1] $
;               , title='N(H!I2!N) from !E13!NCO PDF of NGC 2264, T!Ipeak!N' $
;               , x_log_title=textoidl("ln(N_{H_2}/<N_{H_2}>)") $
;               , x_natural_title='H!I2!N Conlumn Densities (cm!E-2!N)' $
;               , /fitting, fit_range=[0,43],statistics=Ord_N_H2_13COp, /Order
;    device,/close_file

print,"N_H2 Histogram: N_H2_13CO_tau_his.eps"
;    fits_read,"N_H2_Nco_tau_13CO.fits",data,hdr
;    print, Format='("Confined by 3*RMS, Velocity Range, Velocity Width, and tau above 0")'
;;    validdata=data[where(mask_data and Vfwhm_13CO ge dv_13CO and Vc_13CO gt -30 and Vc_13CO lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_13CO ge 3*Tmb_13CO_rms and tau_13CO ge 0, count)]
;    validdata=data[where(mask_data and Vfwhm_13CO ge 3*dv_13CO and Vc_13CO gt -30 and Vc_13CO lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_13CO ge 3*Tmb_13CO_rms and tau_13CO ge 0, count)]
;    help,validdata
;    print,'Mass: ', mass(validdata,distance), ' Msun from 13CO column density'
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    threshold = 1.49e20 * 30 * 0.1 *dv_13CO/(1-exp(-5.289/3.75)) > min(validdata)
;    threshold = min(validdata)
;    !P.multi = [1,1,2] & device,filename='N_H2_13CO_tau_his.eps',/encapsulated
;        pdf_plot, validdata, threshold, /log $
;                , bin=0.1, xrange=[-5,6], yrange=[1e-4,1e1] $
;                , title='N(H!I2!N) from !E13!NCO PDF of NGC 2264, !7s!X' $
;                , x_log_title=textoidl("ln(N_{H_2}/<N_{H_2}>)") $
;                , x_natural_title='H!I2!N Conlumn Densities (cm!E-2!N)' $
;                , /fitting, fit_range=[0,39],statistics=Ord_N_H2_13COt, /Order
;    device,/close_file

print,"N_H2 Histogram: N_H2_C18O_his.eps"
;    fits_read,"N_H2_c18o_0_10_int.fits",data,hdr
;    validdata=data[where(data lt 4.326871e+26, count)]
;    help,validdata
;    print,max(validdata),min(validdata),mean(validdata)
;        device,filename='N_H2_C18O_0_10_his.eps',/encapsulated
;        device,/portrait
;        plothist,validdata,bin=1e24,/boxplot,charsize=1.4,charthick=2,xthick=2,ythick=2$
;               ,title='N(H!I2!N) from C!E18!NO PDF of NGC 2264',xtitle='Conlumn Densities (cm!E-2!N)',ytitle='Number'$
;               ,/ylog,xrange=[-3e25,1.4e26],yrange=[0.5,1e6]
;        device,/close_file
    fits_read, "S287_N_H2_Wco_C18O"+SubRegion+".fits", data,hdr
    fits_read, 'S287_Wco_C18O'     +SubRegion+'.fits', WcoData,WcoHdr
;    validdata=data[where(mask_data, count)]    ;4.326871e+23
;    signaldata=validdata(where(validdata ge noiselevel))
    print, Format = '("Confined by 3*RMS, of Tpeak_12CO and Wco_C18O.")'
    help, where(finite(data) and mask_data, count)
    help, where(WcoData ge 0.1 * Tmb_C18O_rms*sqrt(Vwidth*0.167) and mask_data, count)
    validdata=data[where(WcoData ge 3 * Tmb_C18O_rms*sqrt(Vwidth*0.167) and Tpeak_12CO ge 3*Tmb_12CO_rms and mask_data, count, complement=c_indices)]  ; 2.3637384e+17
    help,validdata
    threshold = 1.568e21 * 2 * Tmb_C18O_rms * sqrt(Vwidth*dv_C18O)/(1-exp(-5.27/3.75)) > min(validdata)
    signaldata = validdata[where(validdata ge threshold)]
    print,'Mass (Msun) from C18O:   raw data       valid data           above 3 sigma'
    print, mass(data,distance), mass(validdata,distance), mass(signaldata,distance)
    !P.multi = [1,1,2] & device,filename='S287_N_H2_Wco_C18O'+SubRegion+'_his.eps',/encapsulated
        pdf_plot, validdata, threshold, /log $
               , bin=0.1, xrange=[-2,2], yrange=[1e-2,1e1] $
               , title='N(H!I2!N) from C!E18!NO PDF of NGC 2264' $
               , x_log_title=textoidl('ln(N_{H_2}/<N_{H_2}>)') $
               , x_natural_title='H!I2!N Conlumn Densities (cm!E-2!N)' $
               , /fitting, fit_range=[0,13],statistics=Ord_N_H2_C18O, /Order
    device,/close_file

print,"N_H2 Histogram: N_H2_C18O_Tpeak_his.eps"
;    fits_read,"N_H2_Nco_Tpeak_C18O.fits",data,hdr
;    print, Format='("Confined by 3*RMS, Velocity Range, and Vfwhm above channel width")'
;    validdata=data[where(mask_data and Vc_C18O gt -30 and Vc_C18O lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_C18O ge 3*Tmb_C18O_rms and Vfwhm_C18O ge dv_C18O, count)]
;    help,validdata
;    print,'Mass: ', mass(validdata,distance), ' Msun from C18O column density'
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    threshold = 1.568e21 * 1 * Tmb_C18O_rms * 5*dv_C18O/(1-exp(-5.27/3.75))
;    threshold = min(validdata)
;    !P.multi = [1,1,2] & device,filename='N_H2_C18O_Tpeak_his.eps',/encapsulated
;        pdf_plot, validdata, threshold, /log $
;                , bin=0.1, xrange=[-5,6], yrange=[1e-4,1e1] $
;                , title='N(H!I2!N) from C!E18!NO PDF of NGC 2264, T!Ipeak!N' $
;                , x_log_title=textoidl("ln(N_{H_2}/<N_{H_2}>)") $
;                , x_natural_title='H!I2!N Conlumn Densities (cm!E-2!N)' $
;                , /fitting, fit_range=[0,19],statistics=Ord_N_H2_C18Op, /Order
;    device,/close_file

print,"N_H2 Histogram: N_H2_C18O_tau_his.eps"
;    fits_read,"N_H2_Nco_tau_C18O.fits",data,hdr
;    print, Format='("Confined by 3*RMS, Velocity Range, Velocity Width, and tau above 0")'
;    validdata=data[where(mask_data and Vfwhm_C18O ge dv_C18O and Vc_C18O gt -30 and Vc_C18O lt 75 and Tpeak_12CO ge 3*Tmb_12CO_rms and Tpeak_C18O ge 3*Tmb_C18O_rms and tau_C18O ge 0, count)]
;    help, validdata
;    print,'Mass: ', mass(validdata,distance), ' Msun from C18O column density'
;    image_statistics, validdata, data_sum=sum, maximum=max, mean=mean, minimum=min
;    print,sum,max,min,mean
;    threshold = 1.568e21 * 30 * 0.1*dv_C18O/(1-exp(-5.27/3.75)) > min(validdata)
;    threshold = min(validdata)
;    !P.multi = [1,1,2] & device,filename='N_H2_C18O_tau_his.eps',/encapsulated
;        pdf_plot, validdata, threshold, /log $
;                 , bin=0.1, xrange=[-5,6], yrange=[1e-4,1e1] $
;               , title='N(H!I2!N) from C!E18!NO PDF of NGC 2264,!7s!X' $
;                 , x_log_title=textoidl("ln(N_{H_2}/<N_{H_2}>)") $
;                 , x_natural_title='H!I2!N Conlumn Densities (cm!E-2!N)' $
;                 , /fitting, fit_range=[0,17],statistics=Ord_N_H2_C18Ot, /Order
;    device,/close_file

print, "Ord_N_H2.eps"
;!P.multi = [0,1,2] & !Y.OMARGIN=[1,0]
;;                        min          max      average        ord       coverage
;    if ~keyword_set(Ord_N_H2_12CO)  then Ord_N_H2_12CO = [ 8.55091e20,  4.31249e22,  3.89747e21, -0.052663700, 0.052147597]
;    if ~keyword_set(Ord_N_H2_13CO)  then Ord_N_H2_13CO = [ 4.20609e20,  6.71975e22,  2.63805e21,   0.15299534,  0.22441606]
;    if ~keyword_set(Ord_N_H2_13COp) then Ord_N_H2_13COp= [ 7.86071e19,  6.32400e22,  1.11254e21,   0.30128074,  0.32149083]
;    if ~keyword_set(Ord_N_H2_13COt) then Ord_N_H2_13COt= [ 9.93680e19,  9.70170e22,  1.67990e21,   0.28248593,  0.31767466]
;    if ~keyword_set(Ord_N_H2_C18O)  then Ord_N_H2_C18O = [ 1.36742e21,  1.25580e23,  6.42113e21,  0.041722492,  0.11110227]
;    if ~keyword_set(Ord_N_H2_C18Op) then Ord_N_H2_C18Op= [ 4.23301e20,  1.33337e23,  4.01900e21,   0.16616605,  0.20074152]           
;    if ~keyword_set(Ord_N_H2_C18Ot) then Ord_N_H2_C18Ot= [ 1.04794e21,  1.57033e23,  5.78143e21,   0.22003304,  0.29311593]
;
;    device, filename='Ord_N_H2.eps'
;        cgPlot, 0,  /nodata, /xlog, xrange=[1e19,1e25], yrange=[-0.4,0.8] $
;              , title = textoidl('Deviation from LN of N_{H_2}'), xtitle = textoidl('N_{H_2} [cm^{-2}]'), ytitle = 'Deviation'
;        cgOPlot, Ord_N_H2_12CO[2], Ord_N_H2_12CO[3], err_xlow = Ord_N_H2_12CO[2]-Ord_N_H2_12CO[0], err_xhigh= Ord_N_H2_12CO[1]-Ord_N_H2_12CO[2], psym=7, color='blue'
;        cgOPlot, Ord_N_H2_13CO[2], Ord_N_H2_13CO[3], err_xlow = Ord_N_H2_13CO[2]-Ord_N_H2_13CO[0], err_xhigh= Ord_N_H2_13CO[1]-Ord_N_H2_13CO[2], psym=7, color='green'
;        cgOPlot, Ord_N_H2_C18O[2], Ord_N_H2_C18O[3], err_xlow = Ord_N_H2_C18O[2]-Ord_N_H2_C18O[0], err_xhigh= Ord_N_H2_C18O[1]-Ord_N_H2_C18O[2], psym=7, color='red'
;        cgPlots, [Ord_N_H2_12CO[2], Ord_N_H2_13CO[2], Ord_N_H2_C18O[2]], [Ord_N_H2_12CO[3], Ord_N_H2_13CO[3], Ord_N_H2_C18O[3]], psym=7
;        cgLegend, Title=textoidl(['^{12}CO','^{13}CO','C^{18}O']),color=['blue','green','red'],Location=[5e23,0.7],/Data,/Addcmd, charsize=1.5, length=0.05
;
;        cgOPlot, Ord_N_H2_13COp[2], Ord_N_H2_13COp[3], err_xlow =Ord_N_H2_13COp[2]-Ord_N_H2_13COp[0], err_xhigh=Ord_N_H2_13COp[1]-Ord_N_H2_13COp[2], psym=5, color='green'
;        cgOPlot, Ord_N_H2_13COt[2], Ord_N_H2_13COt[3], err_xlow =Ord_N_H2_13COt[2]-Ord_N_H2_13COt[0], err_xhigh=Ord_N_H2_13COt[1]-Ord_N_H2_13COt[2], psym=4, color='green'
;        cgOPlot, Ord_N_H2_C18Op[2], Ord_N_H2_C18Op[3], err_xlow =Ord_N_H2_C18Op[2]-Ord_N_H2_C18Op[0], err_xhigh=Ord_N_H2_C18Op[1]-Ord_N_H2_C18Op[2], psym=5, color='red'
;        cgOPlot, Ord_N_H2_C18Ot[2], Ord_N_H2_C18Ot[3], err_xlow =Ord_N_H2_C18Ot[2]-Ord_N_H2_C18Ot[0], err_xhigh=Ord_N_H2_C18Ot[1]-Ord_N_H2_C18Ot[2], psym=4, color='red'
;        cgPlots, [Ord_N_H2_13COp[2], Ord_N_H2_C18Op[2]], [Ord_N_H2_13COp[3], Ord_N_H2_C18Op[3]], psym=5
;        cgPlots, [Ord_N_H2_13COt[2], Ord_N_H2_C18Ot[2]], [Ord_N_H2_13COt[3], Ord_N_H2_C18Ot[3]], psym=4
;        cgLegend, Title=textoidl(['1','2','3']),Psym=[7,5,4],Location=[5e19,0.7],/Data, /Center_Sym, Length=0, charsize=1.5
;
;        cgPlot, 0,  /nodata, /xlog, xrange=[1e19,1e25], yrange=[-0.4,1.0] $
;              , title = textoidl('Order Index of N_{H_2}'), xtitle = textoidl('N_{H_2} [cm^{-2}]'), ytitle = 'Order Index'
;        cgOPlot, Ord_N_H2_12CO[2],-Ord_N_H2_12CO[4], err_xlow = Ord_N_H2_12CO[2]-Ord_N_H2_12CO[0], err_xhigh= Ord_N_H2_12CO[1]-Ord_N_H2_12CO[2], psym=7, color='blue'
;        cgOPlot, Ord_N_H2_13CO[2], Ord_N_H2_13CO[4], err_xlow = Ord_N_H2_13CO[2]-Ord_N_H2_13CO[0], err_xhigh= Ord_N_H2_13CO[1]-Ord_N_H2_13CO[2], psym=7, color='green'
;        cgOPlot, Ord_N_H2_C18O[2], Ord_N_H2_C18O[4], err_xlow = Ord_N_H2_C18O[2]-Ord_N_H2_C18O[0], err_xhigh= Ord_N_H2_C18O[1]-Ord_N_H2_C18O[2], psym=7, color='red'
;        cgPlots, [Ord_N_H2_12CO[2], Ord_N_H2_13CO[2], Ord_N_H2_C18O[2]], [-Ord_N_H2_12CO[4], Ord_N_H2_13CO[4], Ord_N_H2_C18O[4]], psym=7
;        cgLegend, Title=textoidl(['^{12}CO','^{13}CO','C^{18}O']),color=['blue','green','red'],Location=[5e23,0.8],/Data,/Addcmd, charsize=1.5, length=0.05
;
;        cgOPlot, Ord_N_H2_13COp[2], Ord_N_H2_13COp[4], err_xlow =Ord_N_H2_13COp[2]-Ord_N_H2_13COp[0], err_xhigh=Ord_N_H2_13COp[1]-Ord_N_H2_13COp[2], psym=5, color='green'
;        cgOPlot, Ord_N_H2_13COt[2], Ord_N_H2_13COt[4], err_xlow =Ord_N_H2_13COt[2]-Ord_N_H2_13COt[0], err_xhigh=Ord_N_H2_13COt[1]-Ord_N_H2_13COt[2], psym=4, color='green'
;        cgOPlot, Ord_N_H2_C18Op[2], Ord_N_H2_C18Op[4], err_xlow =Ord_N_H2_C18Op[2]-Ord_N_H2_C18Op[0], err_xhigh=Ord_N_H2_C18Op[1]-Ord_N_H2_C18Op[2], psym=5, color='red'
;        cgOPlot, Ord_N_H2_C18Ot[2], Ord_N_H2_C18Ot[4], err_xlow =Ord_N_H2_C18Ot[2]-Ord_N_H2_C18Ot[0], err_xhigh=Ord_N_H2_C18Ot[1]-Ord_N_H2_C18Ot[2], psym=4, color='red'
;        cgPlots, [Ord_N_H2_13COp[2], Ord_N_H2_C18Op[2]], [Ord_N_H2_13COp[4], Ord_N_H2_C18Op[4]], psym=5
;        cgPlots, [Ord_N_H2_13COt[2], Ord_N_H2_C18Ot[2]], [Ord_N_H2_13COt[4], Ord_N_H2_C18Ot[4]], psym=4
;        cgLegend, Title=textoidl(['1','2','3']),Psym=[7,5,4],Location=[5e19,0.8],/Data, /Center_Sym, Length=0, charsize=1.5
;    device, /close_file




;print, 'Compare 12CO and 13CO:'
;    fits_read, 'Tpeak_12CO.fits', img_c, hdr_c
;    fits_read, 'Tpeak_13CO.fits', img, hdr
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


;xyad,TexHdr,[0,339],[0,419],RA,Dec
;cubemoment, 'ngc226412cofinal.fits', [8.1266,11.6182], direction='B',coveragefile='mask.fits'
;cubemoment, 'ngc226412cofinal.fits', [98.7031,101.5728], direction='L',coveragefile='mask.fits'
;cubemoment, 'ngc226413cofinal.fits', [Dec], direction='B',coveragefile='mask.fits'
;cubemoment, 'ngc226413cofinal.fits', [RA], direction='L',coveragefile='mask.fits'
;cubemoment, 'ngc2264c18ofinal.fits', [Dec], direction='B',coveragefile='mask.fits'
;cubemoment, 'ngc2264c18ofinal.fits', [RA], direction='L',coveragefile='mask.fits'

