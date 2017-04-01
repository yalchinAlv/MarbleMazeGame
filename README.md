# MarbleMazeGame
<b>Bilkent University<br>
CS223 - Digital Design</b><br>
Course Project<br>
Yalchin ALiyev<hr>

## Description
<p>
This project is a marble ball maze game in which the ball should be directed into the desired hole to win the game. 
There will be some trap holes which the user should avoid to put the ball in, otherwise, the game will be lost. 
Accelerometer and gyroscope module will be used to control the ball’s direction. 
The ball will move according to the direction the Basys3 board (with accelerometer and gyroscope module connected to it) tilted. 
There will be some difficulty levels. </p>
<p>	When the game begins, the user will be asked to enter the difficulty level using buttons. 
  Then the data will be accepted by the accelerometer and gyroscope module. 
  After processing the data, the direction and the angle of tilt will be measured and be used to control the ball’s speed and direction. 
  As output, we will use 16x16 led matrix module to display the game. 
  Different colors will be used for ball, trap hole and winning hole. 
  Finally, the speaker module will be used to add sound effects to the game. 
</p>

### Equipments
* Basys3 Artix-7 FPGA (XC7A35T-1CPG236C) 
* MPU6050 6 Axis Gyroscope and Accelerometer Module 
* 2 8x8 Led Matrix Modules
* Buttons available on the Basys3 board 

## Block Diagram

<img src="https://dv14bg.by3302.livefilestore.com/y4m7iBay2Nb4heNnQScS7tU9q8GV1KNUaOOBRH0ePkvI6f5u9X2tiLoCFQalyR9daYhBYzVysHaLZ1Gs2MvJXzaM0QOquDzAfAGKD6C7levKeR5R8P1ImnIu2nDgDYVTiO9TwlqlLpxCRN6bHLlQ9VocQKUIwDtmAwlfyWwhFezw4Gc4ENyTLtfln-P9EiU7xzPErOr9o1abKYrK1iFN8tCcw?width=1920&height=1080&cropmode=none" width="900" height="480" />

<img src="https://dv15bg.by3302.livefilestore.com/y4mZXhXiqy2KAcyKufcJLAy4zwwHqd-Q_2tr_lNNu0k4eTMXKphR4y5ctQJAVya9bJq-jmJwOxYPYGnon5HRPqlj1OPgW2pIxGYt84mrSFJ1c6rgN3mnvQxJ0-f1NGtpqp4jNhBLEE1uSw86-JIy8dHZokNPEYZmKNfE5jWfBUPPi5y8zqeKHw-rpoRick8pkfhBJ6pRM_wMKfRCeOs3-U-Kw?width=1920&height=1080&cropmode=none" width="780" height="390" />

<img src="https://dv12bg.by3302.livefilestore.com/y4m2n89CZksbqPEwBI5vzTNJQdXOMvWb_m-g0A4pKbgZSSOWnsXhie1kEocelXULDTxwvCbXMG9MSCrZ-RgFAlA6Orb5EJal0vcNQjbG3IvdzkBEirXimEPRundRNNA39-7ivtSdT-R2qHxXTR43NVjWW64M-kI5C6lBPK2N1veS2yQHUHwaV8ej_taBsHwK_4-g7PqUCnFyYta1M9DFXyFvg?width=1920&height=1080&cropmode=none" width="800" height="390" />
