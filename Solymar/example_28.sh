#!/bin/bash
#		GMT EXAMPLE 28
#		$Id: example_28.sh 16758 2016-07-09 20:51:28Z pwessel $
#
# Purpose:	Illustrates how to mix UTM data and UTM gmt projection
# GMT modules:	makecpt, grdgradient, grdimage, grdinfo, grdmath, pscoast, pstext, mapproject
# Unix progs:	rm, echo
#
ps=example_28.ps
r="-97.59/-97.565/21.315/21.34"

# Get intensity grid and set up a color table
#gmt grdgradient Kilauea.utm.nc -Nt1 -A45 -GKilauea.utm_i.nc
#gmt makecpt -Ccopper -T0/1500 > Kilauea.cpt
# Lay down the UTM topo grid using a 1:16,000 scale
#gmt grdimage Kilauea.utm.nc -IKilauea.utm_i.nc -CKilauea.cpt -Jx1:160000 -P -K \
#	--FORMAT_FLOAT_OUT=%.10g --FONT_ANNOT_PRIMARY=9p > $ps
# Overlay geographic data and coregister by using correct region and gmt projection with the same scale
gmt pscoast -R$r -Ju14Q/1:5 -K -Df+ -Slightblue -W0.5p -BNE \
	--FONT_ANNOT_PRIMARY=12p --FORMAT_GEO_MAP=ddd:mmF > $ps
#echo 155:16:20W 19:26:20N KILAUEA | gmt pstext -R -J -O -K -F+f12p,Helvetica-Bold+jCB >> $ps
#gmt psbasemap -R -J -O -K --FONT_ANNOT_PRIMARY=9p -LjRB+c19:23N+f+w5k+l1:16,000+u+o0.2i \
#	--FONT_LABEL=10p >> $ps
# Annotate in km but append ,000m to annotations to get customized meter labels
gmt psbasemap -R$r -Jx1:0.5 -B0.005g0.005+u"@:8:000m@::" -BWSne -O --FONT_ANNOT_PRIMARY=10p >> $ps
# Clean up
#rm -f Kilauea.utm_i.nc Kilauea.cpt tmp.txt
 open $ps