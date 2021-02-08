//This should be the initial bootstate when the satellite carrier is booted up in the field for the first time. It doesn't really do anything by itself, just sets up the next state.
@lazyglobal off.

print "The fully automated portion of the Whisper mission has begun.".
print "Proceeding to next bootstate.".

writejson("initial_insertion", "bootstate.json").

reboot.
