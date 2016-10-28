;; this program will plot B-band image and the CO contours

pro mk_figimg, psfile=psfile, bw=bw, root=root

  if not keyword_set(root) then root='~/Programs/CO/'

  if keyword_set(psfile) then begin
     ps_start, psfile, /encapsulated, /nomatch, xsize=10, ysize=10
     thick=4
     size=7
  endif else begin
     thick=2
     window, xsize=800, ysize=800
     size=8
  endelse

  if keyword_set(bw) then begin
     cti=0
     sign=-1.
     stretch=10
  endif else begin
     cti=57 ; or take your pick of these values
     sign=1.
     stretch=2
  endelse
  
  ;; the images
  dat1=mrdfits(root+'Data/LCO/PKS0439_B.fits',0,h)
  dat1=dat1(250:350,250:350) ;shrink data size
  dat2=mrdfits(root+'Data/ALMA/Fits/PKS0439_CO20_mom0_sig0.fits',0,h)
  
  ;; dimensions
  dim1=size(dat1, /dim)
  dim2=size(dat2, /dim)
  
  ;; the scale and center of the images
  pixscl1=0.259 ;arcsec/pixel
  ;cntr1=[300,301]
  cntr1=[50,51]
  pixscl2=0.400 ;arcsec/pixel
  cntr2=[89,90]
  
  ;; plot the first image
  cgimage, (sign*dat1), CTIndex=cti, position=[0.18, 0.18, 0.90, 0.90], $
           color='black', xr=0.259*[cntr1(0)-dim1(0),dim1(0)-cntr1(0)], $
           yr=0.259*[cntr1(1)-dim1(1),dim1(1)-cntr1(1)], stretch=stretch

  ;; get the x and y array of the second image
  xr2=0.400*[findgen(dim2(0))-cntr2(0)]
  yr2=0.400*[findgen(dim2(1))-cntr2(1)]

  ;; put contours at 3 sigma, 3+sqrt2*sigma, 3+2sqrt(2)sigma, etc
  ;; also at -3 sigma, -3+sqrt2*sigma
  cgcontour, dat2, xr2, yr2, /ov, c_color='black', $
             levels=[0.216,0.318,0.420,0.522,0.624,0.726,0.828], $
             c_labels=[0,0,0,0,0,0,0], thick=thick
  cgcontour, dat2, xr2, yr2, /ov, c_color='black', $
             levels=[-0.420,-0.318,-0.216], $
             c_labels=[0,0,0], thick=thick, c_line=[1,1,1]
  
  ;; the primary beam
  tvellipse, 4.71/2, 2.25/2, -10, -10, 90+74.54, /data, color='black', $
             thick=thick, /fill ;;values from CASAVIEWER 

  ;; some text
  cgtext, -1.4, 0., 'QSO', charsize=1.8, color='black', charthick=thick
  ;cgtext, -12, 5, 'Galaxy', charsize=1.8, color='white', charthick=thick
  ;cgtext, -12, 3.7, 'detected', charsize=1.8, color='white', charthick=thick
  ;cgtext, -12, 2, 'with ALMA', charsize=1.8, color='white', charthick=thick

  ;usersym, [0,3,2.75,3,2.75], [0,0,-0.25,0,0.25], thick=thick*3
  ;cgplot, [-7],[4], psym=8, /ov, symsize=size, thick=thick, color='white'
  ;usersym, [0,1.5,1.5,1.5,1.2], [0,1.5,1.2,1.5,1.5], thick=thick*3
  ;cgplot, [-4],[-3], psym=8, /ov, symsize=size, thick=thick, color='white'
  
  ;; the coordinate rose
  usersym, [0,-5,-4.75,-5,-4.75], [0,0,-0.25,0,0.25], thick=thick*3
  cgplot, [11],[-11], psym=8, /ov, symsize=size, thick=thick, color='black'
  cgtext, 5.5, -10.5, 'E', charsize=1.5, color='white', charthick=thick

  usersym, [0,0,-0.25,0,0.25],[0,5,4.75,5,4.75], thick=thick*3
  cgplot, [11],[-11], psym=8, /ov, symsize=size, thick=thick, color='black'
  cgtext, 10, -6, 'N', charsize=1.5, color='white', charthick=thick

  cgplot, [0], [0],  position=[0.18, 0.18, 0.90, 0.90], xthick=thick, $
          ythick=thick, $
          /noerase, xr=0.259*[cntr1(0)-dim1(0),dim1(0)-cntr1(0)], $
           yr=0.259*[cntr1(1)-dim1(1),dim1(1)-cntr1(1)], $
          xtit='X (arcsec)', ytit='Y (arcsec)'

  ;; the distance bar
  cgplot, [-3,-3+2.59], [-11,-11], psym=-26, /ov, color='black', thick=thick*3, $
          symsize=1.5
  cgtext, -3., -10.3, '5 kpc', charsize=1.8, color='black', charthick=thick
  
  cgtext, -12.5, 11, 'PKS0439-433: B-band image + CO(1-0) contours', $
          charsize=1.8, color='black', charthick=thick 
  
  if keyword_set(psfile) then ps_end
  
end
