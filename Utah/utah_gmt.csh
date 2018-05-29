#!/bin/csh
set r="-115.4/-107.8/36.2/42.6"
set ps="utah_0413.ps"
set TAstations="./Data/TA_Utah.txt"
set USstations="./Data/US_Utah.txt"
set UUstations="./Data/UU_Utah.txt"
set events="./Data/Utah2000_2017_TP.txt"
set eventsNew="./Data/Utah_stations.txt"


# Base map
gmt pscoast -R$r -JM6i -Wblack -Ggrey -Yc -P -Na,thick -K -Ba2/a2 > $ps

# Cut grid to selected area
#gmt grdcut /Volumes/BEBESHITO/topography/topo30.grd -R$r -Gutah_topo.grd

# Make Color Palette Table
#gmt grd2cpt utah_topo.grd -Crelief -E -Qi > utah_cpt.cpt

# Crate shade ps (gradient)
#gmt grdgradient utah_topo.grd -A0 -fg -Nt -Gutah_shade.grd 

# New file for earthquake location and magnitude
awk '{print $1, $2, $11, $3*0.07}' $events > $eventsNew

# Add topography layer 
gmt grdimage utah_topo.grd -R -J -Crelief -Iutah_shade.grd -K -O >> $ps

# Add borders
gmt pscoast -R -J -O -K -Na,thick >> $ps

# Locate Stations 
gmt psxy $TAstations -R -J -i2,1 -St0.4 -W1.0,black -Gblue -O -K >> $ps
gmt psxy $UUstations -R -J -i2,1 -St0.4 -W1.0,black -Ggreen -O -K >> $ps
gmt psxy $USstations -R -J -i2,1 -St0.4 -W1.0,black -Gred -O -K >> $ps

# Adding legend
gmt pslegend -R -J -O -DjBC+w2i+o0/-2.5c << EOF >> $ps
S 0.1i t 0.15i blue 0.25p,black 0.3i TA Stations 
S 0.1i t 0.15i green 0.25p,black 0.3i UU Stations 
S 0.1i t 0.15i red 0.25p,black 0.3i US Stations 
EOF

# Convert to PDF
gmt psconvert -Tf -Futah_stations $ps

open $ps

