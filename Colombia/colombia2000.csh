#!/bin/csh
set r="-97.4/-32.5/-29.5/26.1"
set ps="./maps/colombia.ps"
set grd="./data/colombia_grd.grd"
set cpt="./data/colombia_cpt.cpt"
set shade="./data/colombia_shade.grd"
set events="./data/events_gmt.txt"
set plates="./data/platesdata.txt"

# Base map
gmt pscoast -R$r -JM6i -S214/235/242 -Wblack -Ggrey -Yc -P -K -Na,thick -Ba10/a10 > $ps

# Cut grid to selected area
# gmt grdcut /Users/jdozal/Desktop/topo30.grd -R$r -G$grd

# Make Color Palette Table
# gmt grd2cpt $grd -Crelief -E -Qi > $cpt

# Crate shade ps (gradient)
# gmt grdgradient $grd -A0 -fg -Nt -G$shade

# Get input file for earthquakes 
awk -F',' '{print $6, $5, $7, $11*0.04;}' data/events.txt > data/events_gmt.txt

# Create cpt for earhquakes depth
#gmt makecpt -Cseis -E5 -i2 $events > depth.cpt

# Add topography layer 
#gmt grdimage $grd -R -K -J -C$cpt -I$shade -O >> $ps

# Add borders
gmt pscoast -R -J -O -K -Na/0.2p >> $ps

# Locate earthquakes (Line, Fill)
gmt psxy -R -J -O -K $events -t60 -Scc -L -Cdepth.cpt >> $ps
gmt psxy -R -J -O -K $events -Scc -W0.25,black -G- -t60 -Cdepth.cpt >> $ps

# Plate boundaries 
gmt psxy -J -R $plates -W2p,black -O -t50 -Sf0.25/3p -Gred >> $ps

# Convert to PDF
gmt psconvert -Tf -Fcolombiafinal $ps

open colombiafinal.pdf

