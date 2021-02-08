@lazyglobal off.

declare local eta_to_an to ship:orbit:eta:periapsis - ((ship:orbit:argumentofperiapsis / 360 ) * ship:orbit:period) + ship:orbit:period.

declare local eta_to_desired to eta_to_an + (ship:orbit:period / 4).

add(node(eta_to_desired + time:seconds, 0, 0, 0)). 
