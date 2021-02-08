//Boot file for the Whisper satellite carrier for most of the mission.
@lazyglobal off.

wait until ship:unpacked.

switch to 1. //Everything is going to be done in the local volume.

declare local bootstate to readjson("bootstate.json").

//I've just now realized this is an easy and rather clever way to not have to write a huge series of if statements. 
runpath(bootstate + ".ks").
