# Manipul8


## Setup

Make sure you have [Processing3][processing] and [reacTIVision][rv] installed. Then check out this repository.
If you're not comfortable with git, you can just download the code as a zip file. 

### Versions
Manipul8 uses [semantic versioning][semver] to keep track of versions. This helps with communication, 
so that we know which code has errors or new features. You can always see the current version of your 
code at the top of Settings, and in the log when you start the app. You can select a version to download 
by selecting a particular tag in the `Branch` dropdown on this page. 

### Configuration
If fiducials are not showing up where you expect them on the screen, you probably need to run configuration.
Press `n` to start configuration. You will see four crosshairs appear, one at a time, in each corner of the screen.
Position a fiducial over each crosshairs and then press `c`. 

If the sizes of objects on the screen are wonky, change values in Settings. 

## Testing 

Manipul8 can be tested indepentently of the TUIO table using the [reacTIVision TUIO simulator][rv]. 
After you download and upack the files, replace `resources/config.xml` with the version included in this repository so 
that you will have access to the proper fiducial IDs. 

[processing]: https://processing.org/
[semver]: https://semver.org/
[rv]: http://reactivision.sourceforge.net/
