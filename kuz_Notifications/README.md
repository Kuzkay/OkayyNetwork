# Kuz_Notifications
Use CallRemoteEvent when calling from the server and CallEvent when calling from the client



## Send basic notification:
```
'KNotify:Send' (text, [color])
```
text - text which will be shown<br/>
color - hex color<br/>

![image](https://i.imgur.com/KBmB0Xr.png)<br/>
![image](https://i.imgur.com/YL0eUu7.png)

## Show notification at the bottom of the screen
```
'KNotify:SendPress' (text)
```
text - text which will be shown<br/>

![image](https://i.imgur.com/ZuIORua.png)

## Force hide notification at the bottom of the screen
```
'KNotify:HidePress' ()
```
## Add progress bar
```
'KNotify:AddProgressBar' (text, duration, color, id, [automatic])
```
text - text you want to display<br/>
duration - duration in seconds (only used for automatic notifications)<br/>
color - HEX color example: "#ff0000"<br/>
id - id/name of the progress bar used to access it <br/>
automatic - boolean, should the progress bar update automatically (go from 0 to 100 in the set duration of time)<br/>

![image](https://i.imgur.com/ShrrmYa.png)

## Set progress bar text
```
'KNotify:SetProgressBarText' (id, text)
```
id - id/name of the progress bar you want to access<br/>
text - new text you want to display on the progress bar<br/>

## Set progress bar percentage
```
'KNotify:SetProgressBar' (id, progress)
```
id - id/name of the progress bar you want to access<br/>
progress - integer or float value of the % you want to set progress bar to (0-100)<br/>

## Force remove progress bar
```
'KNotify:RemoveProgressBar' (id)
```
id - id/name of the progress bar you want to force remove(if you don't use this progress bars with 100% will automatically be removed after 5 seconds)<br/>
