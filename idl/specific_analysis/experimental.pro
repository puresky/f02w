; Open the image.
imageSize = [340, 420]
;file = FILEPATH('m51.dat', SUBDIRECTORY = ['examples', 'data'])
; Use READ_BINARY to read the image as a binary file.
;binary_img = READ_BINARY(file, DATA_DIMS = imageSize)
; Display the original image
file = 'ngc226412cofinal.fits'
fits_read, file, data, hdr  
x=REFORM(data[200,200,*])
xx=(reform(data[200,200,*]))[1:755]
y=GAUSS_SMOOTH(x,2)
yy=Gauss_smooth(xx,2)
yyy=smooth(xx,9)
plot, x,yrange=[-5,20]
cgoplot,xx+2
cgoplot,y,color='yellow'
cgoplot,yy+2,color='yellow'
cgoplot,yyy+4, color='green'
print,mean(x),mean(xx),mean(y),mean(yy),mean(x-y),mean(xx-yy),mean(xx-yyy)
print,stddev(x-y),stddev(xx-yy),stddev(xx-yyy),stddev([x[1:250],x[350:755]])

img00 = image(data[*,*,300], RGB_TABLE = 6)

;file = 'ngc2264c18ofinal.fits'
file = 'Tpeak_C18O.fits'
fits_read, file, data, hdr
data=data>0
img01 = IMAGE(data, RGB_TABLE = 6)
; Transform the image into the frequency domain and shift the zero-frequency location from (0,0) to the center of the data.
ffTransform = FFT(data, /CENTER)
; Compute the power spectrum of the transform and apply a log scale.
powerSpectrum = ABS(ffTransform)^2
scaledPowerSpect = ALOG10(powerSpectrum)
; Display the log-scaled power spectrum as an image.
img02 = IMAGE(scaledPowerSpect, RGB_TABLE = 6)
; Scale the power spectrum to make its maximum value equal to 0.
scaledPS0 = scaledPowerSpect - MAX(scaledPowerSpect)
; Display the log-scaled power spectrum as a surface.
s3 = SURFACE(scaledPS0, AXIS_STYLE = 0, ZTITLE = 'Max-Scaled(Log(Squared Amplitude))', FONT_SIZE = 8, COLOR = 'aquamarine')
; Add the z-axis.
;ax = AXIS('Z', LOCATION = [0, imageSize[1], 0])
; Apply a mask to remove values less than -7, just below the peak of the power spectrum. The data type
; of the array returned by the FFT function is complex, which contains real and imaginary parts. In image
; processing, we are more concerned with the amplitude, which is the real part. The amplitude is the only part
; represented in the surface and displays the results of the transformation.
mask = REAL_PART(scaledPS0) GT -7
; Apply the mask to the transform to exclude the noise.
maskedTransform = ffTransform*mask
; Perform an inverse FFT to the masked transform, to
; transform it back to the spatial domain.
inverseTransform = REAL_PART(FFT(maskedTransform, /INVERSE, /CENTER))
; Display the result of the inverse transformation.
img03 = IMAGE(inverseTransform, RGB_TABLE = 6)
img04 = image(data-inversetransform, rgb_table = 6)

file = 'Tex.fits'
fits_read,file,data,hdr
ffLaplacian=laplacian(data)
img01=image(ffLaplacian)
plothist,ffLaplacian,/nan

convolve(data,1)
filter_image(data)
sigma_filter(data,1)
psf_gaussian(1)

end