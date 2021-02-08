//Currently performing initial orbital insertion and the inclination correction maneuver (if one is plotted).
@lazyglobal off.

print "Beginning initial orbital insertion.".

if !hasnode {
	print "There is no orbital insertion manuever plotted. Terminating program!".
	shutdown.
}
