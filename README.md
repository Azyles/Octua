# OCTUA

The app can be used to turn an older device into your very own security camera/motion detector. Using ML-Kit I was able to make the camera scan for faces and alert the user when a face is found. The motion detector, using the phones Accelerometer and Gyroscope, log potential break-ins. The cameras can be remotely controlled using the apps with a Home account.

## FACE DETECTION.

Using googles ML-Kit Ocuta is able to detect faces. Upon activation the app starts to look for faces and when found it logs it in the database and alerts the user. The app scans the firestore database for any changes so a specific bool. When the camera is enabled the bool in the database is changed to true and the camera begins scanning. This allows users to enable the camera from wherever they maybe. 
