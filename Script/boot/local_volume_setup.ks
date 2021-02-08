//Easy way to copy stuff over to your local volume with some simple boilerplate code.
@lazyglobal off.

global function setupLocalVolume {
  declare parameter main_files_directory. //Absolute filepath to the directory where the unique files for this mission are stored.
  declare parameter required_libraries. //List with string names (not filepaths) of the required libraries to be copied to local volume.

  switch to 0. //"0:/"" should be included in your absolute filepath but if you forget we got you!

  cd(main_files_directory).

  //Write main mission files to local volume
  list files in filename_list.

  for filename in filename_list {
    copypath(filename, "1:/" + filename).
  }

  //Write library files to local volume
  cd("0:/lib").

  for library in required_libraries {
    copypath(library, "1:/lib/" + library).
  }
}
