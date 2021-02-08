//Initial boot file for the Whisper satellite carrier.
@lazyglobal off.

wait until ship:unpacked.

//Set up local volume
runpath("0:/boot/local_volume_setup.ks").

declare local libs to list("maneuver", "orbit", "rcs").
setupLocalVolume("0:/whisper/satellite_carrier", libs).

//Setup bootstate.json
writejson("waiting_to_start", "1:/bootstate.json").

//Set boot file to satellite_carrier_boot.ks
set core:bootfilename to "1:/satellite_carrier_boot.ks".

//Reboot
reboot.
