;-file clump_filter.pro
;-Usage:
;-.compile clump_filter.pro
;-clump_filter,"filename"

pro clump_filter,file
fits_read,file,tab,hdr
shape=tbget(hdr,tab,'Shape')
a = gettok(shape,' ');Ellipse
a = gettok(shape,' ');J2000
a = gettok(shape,' ');TOPOCENTER
a = gettok(shape,' ');x
a = gettok(shape,' ');y
a = double(gettok(shape,' '));a
b = double(gettok(shape,' '));b
fake = where(a/b gt 20)
tbdelrow,hdr,tab,fake
fits_write,file+'.FIT',tab,hdr
end