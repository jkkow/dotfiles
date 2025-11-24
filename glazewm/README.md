# Manage Config GlazeWM

Config management of GlazeWM via personal git repository

## Install GlazeWM

```
scoop bucket add extras
scoop install extras/glazewm
```

need to install `zebar` too.

```
scoop install zebar
```

## Check Config File Location

When GlazeWM installed and _run for the first time_, `.glzr\glazewm` folder is created in the following location.

`C:\Users\user_name\.glzr\`

Change the config path to the my custom config folder.

Use the following command

```
setx GLAZEWM_CONFIG_PATH C:\Users\jkkow\.config\glazewm\config.yaml
```

This `setx` command set a environment variable permanently so that you don't need to set the path whenever you remoot or start a new session.
you should locate config file (`config.yaml`) for GlazeWM here.

## Set symboliclink 

Remote Github repo

```
git@github.com:jkkow/dotfiles.git
```
Find configuration for the Glazewm is in the 'glazewm' folder.
Use that as a symboliclink source.
