
baseline.class
* baseline spectra, no smooth-method applied. 
* @baseline path source extension order modxl modxr winle winri
* it will create or replace "source.bas" and "source.rms" in "./", 

concatenate.class
* concatenate files having similar names.
* @concatenate path source band extension
* it will search files "source-band.extension" in "path/", 
* and create or replace "sourceband.rgd" in "./". 

makecube.class
* @makecube gridpath path source band extension
*

makelmv.class
* current version smoothing to 2km/s  applied.
* @makelmv path source extension method
* method=0, no gridding; method=1, gridding. 
* it will create or replace "source.lmv" in "./".

modify.class
* shift rest frequency from 13CO(1-0) to C18O(1-0)
* @modify path source extension
* read "path/sourceL.extension", create or replace "./sourceL2.extension".

rmbadchan.class
* remove bad channels by replacing it with its neighbour
* @rmbadch path source extension velocity1 velocity2
* create or replace "./source_good.extension".

sum.class
* reminder: there is a task also named "sum".
* baseline the spectra, average spectra who share the same offsets, weighted by sigma.
* the files should be grided to 30"x30" first. 
* @sum path source extension modxl modxr winle winri
* it will create or replace "source.sum" in "./".


