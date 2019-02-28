## ditherflac24to16

A simple Ruby script to convert 24-bit FLAC files to 16-bit.

You need [SoX](http://sox.sourceforge.net/) in order for this to work.

## Usage

```
./ditherflac24to16.rb "<source directory>" "<destination directory>" <sample rate>
```

The destination directory will be created for you.
You need to input the correct sample rate of the source files (e.g. 48000 or 44100).
Once you run this, the script iterates over all the FLAC files in your source directory and runs SoX to dither them from 24 to 16 bits, writing the new files to your destination directory, and of course, leaving your original files intact.. 

## Example

```
$ pwd
/home/bob
$ ls -l
drwx------ 2 bob users 9 Nov 26 21:55 'Artist - 2018 - Album Title [FLAC 24-bit]'
./ditherflac24to16.rb "Artist - 2018 - Album Title [FLAC 24-bit]" "Artist - 2018 - Album Title [FLAC]" 44100
...
$ ls -l
drwx------ 2 bob users 9 Nov 26 21:55 'Artist - 2018 - Album Title [FLAC 24-bit]'
drwx------ 2 bob users 9 Nov 27 15:25 'Artist - 2018 - Album Title [FLAC]'
```
