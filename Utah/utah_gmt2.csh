#!/bin/csh
set r="-115.4/-107.8/36.2/42.6"
set ps="utah_0413.ps"
set TAstations="./Data/TA_Utah.txt"
set USstations="./Data/US_Utah.txt"
set UUstations="./Data/UU_Utah.txt"
set events="./Data/Utah2000_2017_TP.txt"
set eventsNew="./Data/Utah_events.txt"
set depth="./Data/depth.cpt"


# Base map
gmt pscoast -R$r -JM6i -Wblack -Ggrey -Yc -P -Na,thick -K -Ba2/a2 > $ps

# Cut grid to selected area
#gmt grdcut /Volumes/BEBESHITO/topography/topo30.grd -R$r -Gutah_topo.grd

# Make Color Palette Table
#gmt grd2cpt utah_topo.grd -Crelief -E -Qi > utah_cpt.cpt

# Crate shade ps (gradient)
#gmt grdgradient utah_topo.grd -A0 -fg -Nt -Gutah_shade.grd 

# New file for earthquake location and magnitude
#awk '{print $2, $1, $11, $3*0.2}' $events > $eventsNew

# Add topography layer 
gmt grdimage utah_topo.grd -R -J -Crelief -Iutah_shade.grd -K -O >> $ps

# Add borders
gmt pscoast -R -J -O -K -Na,thick >> $ps

# Locate earthquakes (Line, Fill)
gmt psxy -R -J -O -K $eventsNew -t30 -Scc -L -C$depth >> $ps
gmt psxy -R -J -O -K $eventsNew -Scc -W0.25,black -G- -t60 -C$depth >> $ps

# Add scale (Magnitude) and stations legend 
gmt pslegend -R -J -O -K -DJBC+o-5.2/0.5i+w1.7i -F+gwhite+p1p,black << EOF >> $ps
H 12 - Magnitude
G 0.1i
S 0.4i c 0.4 - black 0.75i M = 2
G 0.1i
S 0.4i c 0.8 - black 0.75i M = 4
G 0.25i
S 0.4i c 1.2 - black 0.75i M = 6
G 0.23i
EOF

gmt pslegend -R -J -O -DJBC+o-2.6/0.5i+w1i -F+gwhite+p1p,black << EOF >> $ps
H 12 - Depth 
G 0.1i
S 0.2i c 0.30 255/10.625/0 black 0.32i 0 km
G 0.1i
S 0.2i c 0.30 255/201.88/0 black 0.32i 50 km
G 0.1i
S 0.2i c 0.30 151.88/255/18.75 black 0.32i 100 km
G 0.1i
S 0.2i c 0.30 0/100/236.87 black 0.32i 150 km
G 0.1i
EOF

# Convert to PDF
gmt psconvert -Tf -Futah_events $ps

open $ps

