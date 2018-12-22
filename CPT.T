%EKAGRA LUTHRA CPT PROGRAM, SUPER MARIO ARCHERY
%DATE : 2018/06/17
%SHORT DESCRIPTION: This program is essentially an archery range. It shows a circle for aiming and the user must hit the center of the targets to score points.
%the targets change so the user knows which one to hit, and the 'a' and 'd' keys are for moving left and right. 'w' is to shoot. the user can change
%the time they want to play for, the title background, and the music. The model has the motor moving your character, Dr. Mario, which matches up
%with the aiming on screen.

%importing GUI
import GUI
%setting screen size,removing button bar,allowing view.update,setting position of window,setting title
View.Set ("graphics:1000;562;nobuttonbar;offscreenonly;position:center;truemiddle;title:CPT_EKAGRA")
buttonchoose ("multibutton")

%declaring pictures for title screen, game screen, title text, instructions screen, options screen, and final scoreboard screen
var mainscreen : int := Pic.FileNew ("marioscreen.jpg")
var easyscreen : int := Pic.FileNew ("easyscreen.jpg")
var title : int := Pic.FileNew ("mariotext.jpg")
var helpscreen : int := Pic.FileNew ("helpscreen.jpg")
var optionsscreen : int := Pic.FileNew ("optionsscreen.jpg")
var scorepic : int := Pic.FileNew ("scorescreen.jpg")

%declaring char as an array of booleans to use for key inputs
var chars : array char of boolean

%integer  variables for timer, random target picked, score, shot position, and ending time
var starttime, timepassed : int := 0
var randompicker : int
var shot : int
var score : int := 0
%final score variable, real number
var finalscore : real := 0
%xmover is 500 because that's the center of the screen
var xmover : int := 500
%mousewhere variables
var x, y, button, left, middle, right : int
var targetpicker : int
%default game time
var timeend : int := 60

%declaring fonts. made the fonts the same to have somewhat of a uniform look throughout
var font1 : int := Font.New ("Goudy Stout:30")
var font2 : int := Font.New ("Goudy Stout:21")

%parallelputs for moving motor right
procedure forwardmotor
    parallelput (5)
    delay (3)
    parallelput (6)
    delay (3)
    parallelput (10)
    delay (3)
    parallelput (9)
    delay (3)
end forwardmotor

%parallelputs for moving motor left
procedure backwardmotor
    parallelput (9)
    delay (3)
    parallelput (10)
    delay (3)
    parallelput (6)
    delay (3)
    parallelput (5)
    delay (3)
end backwardmotor

%sound effect for end of game
process endsound
    Music.PlayFile ("endsound.mp3")
end endsound

%sound effect for start of game
process startsound
    Music.PlayFile ("startsound.mp3")
end startsound

%checks how much time has passed and outputs it
procedure timetracker
    timepassed := Time.Elapsed () - starttime
    %divides time by 1000 to put it into seconds rather than milliseconds
    timepassed := timepassed div 1000
    Font.Draw ("Time:", 20, 500, font2, red)
    %converts timepassed to a string to allow Font.Draw to use it
    Font.Draw (intstr (timepassed), 180, 500, font2, red)
end timetracker

%checks the score and ouputs it
procedure scoretracker
    Font.Draw ("Score", 20, 460, font2, red)
    %converts score to a string type
    Font.Draw (intstr (score), 200, 460, font2, red)
end scoretracker

%main procedures
forward proc titlescreen
forward proc game
forward proc instructions
forward proc options
forward proc scorescreen

%title screen procedure
body proc titlescreen
    %setting the screen
    setscreen ("graphics:1000;562;nobuttonbar;offscreenonly;position:center;truemiddle;title:CPT_EKAGRA")
    %drawing pictures and text
    Pic.Draw (mainscreen, 0, 0, picCopy)
    Pic.Draw (title, 20, 500, picCopy)
    Font.Draw ("Play", 20, 420, font2, black)
    drawbox (15, 410, 165, 450, black)
    Font.Draw ("How To Play", 20, 360, font2, black)
    drawbox (15, 350, 385, 390, black)
    Font.Draw ("Options", 20, 300, font2, black)
    drawbox (15, 290, 250, 330, black)
    %loop to check mouse location and draw text based off of if mouse is down or not
    loop
	%checks mouse location and draws a target around cursor for a visual effect
	mousewhere (x, y, button)
	drawfilloval (x, y, 25, 25, white)
	drawfilloval (x, y, 18, 18, black)
	drawfilloval (x, y, 11, 11, blue)
	drawfilloval (x, y, 4, 4, red)
	%updates screen
	View.Update
	%redraws main screen and title so the target doesnt drag over the whole screen
	Pic.Draw (mainscreen, 0, 0, picCopy)
	Pic.Draw (title, 20, 500, picCopy)
	%if statements for selecting which screen to go to. draws text in different color if mouse hovers over it
	if x >= 15 and x <= 165 and y >= 410 and y <= 450 and button = 0 then
	    Font.Draw ("Play", 20, 420, font2, brightred)
	    drawbox (15, 410, 165, 450, brightred)
	elsif x >= 15 and x <= 165 and y >= 410 and y <= 450 and button = 1 then
	    %goes to main game
	    game
	    exit
	else
	    Font.Draw ("Play", 20, 420, font2, black)
	    drawbox (15, 410, 165, 450, black)
	end if
	if x >= 15 and x <= 385 and y >= 350 and y <= 390 and button = 0 then
	    Font.Draw ("How To Play", 20, 360, font2, brightred)
	    drawbox (15, 350, 385, 390, brightred)
	elsif x >= 15 and x <= 385 and y >= 350 and y <= 390 and button = 1 then
	    %goes to instructions screen
	    instructions
	    exit
	else
	    Font.Draw ("How To Play", 20, 360, font2, black)
	    drawbox (15, 350, 385, 390, black)
	end if
	if x >= 15 and x <= 250 and y >= 290 and y <= 330 and button = 0 then
	    Font.Draw ("Options", 20, 300, font2, brightred)
	    drawbox (15, 290, 250, 330, brightred)
	elsif x >= 15 and x <= 250 and y >= 290 and y <= 330 and button = 1 then
	    %goes to options screen
	    options
	    exit
	else
	    Font.Draw ("Options", 20, 300, font2, black)
	    drawbox (15, 290, 250, 330, black)
	end if
    end loop
end titlescreen

%main procedure for instructions
body proc instructions
    %draws text
    Font.Draw ("Back", 100, 40, font2, black)
    drawbox (95, 35, 245, 75, black)
    Font.Draw ("Options", 355, 40, font2, black)
    drawbox (350, 35, 585, 75, black)
    Font.Draw ("Play", 700, 40, font2, black)
    drawbox (695, 35, 840, 75, black)
    %loop for checking mouse location
    loop
	%checks mouse location, draws target around for visual effect
	mousewhere (x, y, button)
	drawfilloval (x, y, 25, 25, white)
	drawfilloval (x, y, 18, 18, black)
	drawfilloval (x, y, 11, 11, blue)
	drawfilloval (x, y, 4, 4, red)
	%updates screen
	View.Update
	%redraws picture to cover up last target location so target doesnt drag on and cover up picture
	Pic.Draw (helpscreen, 0, 0, picCopy)
	%instructions on how to play
	Font.Draw ("How To Play", 230, 500, font1, black)
	Font.Draw ("Move Mario and aim with the", 10, 400, font2, black)
	Font.Draw ("'a' and 'd' keys and shoot with 'w'.", 10, 360, font2, black)
	Font.Draw ("Hit the center of the targets", 10, 320, font2, black)
	Font.Draw ("to earn a point. Score as many", 10, 280, font2, black)
	Font.Draw ("points as you can before the", 10, 240, font2, black)
	Font.Draw ("time runs out.", 10, 200, font2, black)
	%checks mouse location and draws text in different color if mouse hovers over it
	if x >= 95 and x <= 245 and y >= 35 and y <= 75 and button = 0 then
	    Font.Draw ("Back", 100, 40, font2, brightred)
	    drawbox (95, 35, 245, 75, brightred)
	elsif x >= 95 and x <= 245 and y >= 35 and y <= 75 and button = 1 then
	    %goes back to title screen
	    titlescreen
	    exit
	else
	    Font.Draw ("Back", 100, 40, font2, black)
	    drawbox (95, 35, 245, 75, black)
	end if
	if x >= 350 and x <= 585 and y >= 35 and y <= 75 and button = 0 then
	    Font.Draw ("Options", 355, 40, font2, brightred)
	    drawbox (350, 35, 585, 75, brightred)
	elsif x >= 350 and x <= 585 and y >= 35 and y <= 75 and button = 1 then
	    %goes to options screen
	    options
	    exit
	else
	    Font.Draw ("Options", 355, 40, font2, black)
	    drawbox (350, 35, 585, 75, black)
	end if
	if x >= 695 and x <= 840 and y >= 35 and y <= 75 and button = 0 then
	    Font.Draw ("Play", 700, 40, font2, brightred)
	    drawbox (695, 35, 840, 75, brightred)
	elsif x >= 695 and x <= 840 and y >= 35 and y <= 75 and button = 1 then
	    %goes to game
	    game
	    exit
	else
	    Font.Draw ("Play", 700, 40, font2, black)
	    drawbox (695, 35, 840, 75, black)
	end if
    end loop
end instructions

%game procedure
body proc game
    %targetpicker is used to draw a random target for the user to hit
    targetpicker := Rand.Int (1, 4)
    %clears previous screen
    cls
    %draws the background picture
    Pic.Draw (easyscreen, 0, 0, picCopy)

    %draws leftmost target
    drawfilloval (120, 281, 75, 75, white)
    drawfilloval (120, 281, 60, 60, black)
    drawfilloval (120, 281, 45, 45, blue)
    drawfilloval (120, 281, 30, 30, red)
    drawfilloval (120, 281, 15, 15, yellow)

    %draws target second from the left
    drawfilloval (370, 281, 75, 75, white)
    drawfilloval (370, 281, 60, 60, black)
    drawfilloval (370, 281, 45, 45, blue)
    drawfilloval (370, 281, 30, 30, red)
    drawfilloval (370, 281, 15, 15, yellow)

    %draws target third from the left
    drawfilloval (620, 281, 75, 75, white)
    drawfilloval (620, 281, 60, 60, black)
    drawfilloval (620, 281, 45, 45, blue)
    drawfilloval (620, 281, 30, 30, red)
    drawfilloval (620, 281, 15, 15, yellow)

    %draws rightmost target
    drawfilloval (870, 281, 75, 75, white)
    drawfilloval (870, 281, 60, 60, black)
    drawfilloval (870, 281, 45, 45, blue)
    drawfilloval (870, 281, 30, 30, red)
    drawfilloval (870, 281, 15, 15, yellow)

    %updates screen
    View.Update

    %start of game sound effect
    fork startsound

    %draws red, yellow, and green light with delays to give user a bit of time to get ready to play the game
    View.Update
    drawfilloval (500, 281, 90, 90, red)
    View.Update
    delay (1400)
    drawfilloval (500, 281, 90, 90, yellow)
    View.Update
    delay (1400)
    drawfilloval (500, 281, 90, 90, green)
    View.Update
    delay (2000)
    View.Update

    %draws aim circle. xmover is a value that the user can change by pressing 'a' or 'd' to move left or right
    drawoval (xmover, 281, 25, 25, black)
    delay (125)

    %starts counter
    starttime := Time.Elapsed ()

    %this loop contains the entire game, essentially
    loop
	%draws aim circle
	drawoval (xmover, 281, 25, 25, black)
	%updates to draw circle
	View.Update
	%redraws picture to cover up old circle
	Pic.Draw (easyscreen, 0, 0, picCopy)

	%time and score procedures
	timetracker
	scoretracker

	%checks if time has reached limit
	if timepassed >= timeend then
	    %end sound effect
	    fork endsound
	    %exits loop
	    exit
	end if

	%checks the key being pressed
	Input.KeyDown (chars)

	%checks what random number "targetpicker" has picked, and draws targets accordingly
	if targetpicker = 1 then
	    drawfilloval (120, 281, 75, 75, white)
	    drawfilloval (120, 281, 60, 60, black)
	    drawfilloval (120, 281, 45, 45, blue)
	    drawfilloval (120, 281, 30, 30, red)
	    drawfilloval (120, 281, 15, 15, yellow)
	elsif targetpicker = 2 then
	    drawfilloval (370, 281, 75, 75, white)
	    drawfilloval (370, 281, 60, 60, black)
	    drawfilloval (370, 281, 45, 45, blue)
	    drawfilloval (370, 281, 30, 30, red)
	    drawfilloval (370, 281, 15, 15, yellow)
	elsif targetpicker = 3 then
	    drawfilloval (620, 281, 75, 75, white)
	    drawfilloval (620, 281, 60, 60, black)
	    drawfilloval (620, 281, 45, 45, blue)
	    drawfilloval (620, 281, 30, 30, red)
	    drawfilloval (620, 281, 15, 15, yellow)
	elsif targetpicker = 4 then
	    drawfilloval (870, 281, 75, 75, white)
	    drawfilloval (870, 281, 60, 60, black)
	    drawfilloval (870, 281, 45, 45, blue)
	    drawfilloval (870, 281, 30, 30, red)
	    drawfilloval (870, 281, 15, 15, yellow)
	end if

	%draws aim circle, this one is for making sure that its in front of the targets, not behind
	drawoval (xmover, 281, 25, 25, black)
	%updates screen
	View.Update

	%checks input from keyboard (whether it's 'a', 'd', 'w', or nothing)
	%if it's 'd' and not past the right edge of the screen
	if chars ('d') and xmover <= 960 then
	    %adds 4 to xmover, moving the aim circle to the right
	    xmover += 4
	    %moves motor to pull mario to the right
	    backwardmotor
	    %if it's 'a' and not past the left edge of the screen
	elsif chars ('a') and xmover >= 40 then
	    %takes away 4 from xmover, moving aim circle to left
	    xmover -= 4
	    %turns motor to pull mario to the left
	    forwardmotor
	    %if 'w' is clicked
	elsif chars ('w') then
	    %it picks a random number to add to xmover for where the shot will go inside the circle
	    randompicker := Rand.Int (-17, 17)
	    %location of the shot, determined by where the aim circle is and what the "randompicker" adds to it
	    shot := xmover + randompicker

	    %short delay
	    delay (100)

	    %checks which target is currently active
	    if targetpicker = 1 then
		%checks if the shot within the bounds of the center of the target
		if shot >= 105 and shot <= 135 then
		    %plays sound effect if the user scores
		    Music.Sound (900, 85)
		    Music.SoundOff
		    Music.Sound (1500, 85)
		    Music.SoundOff
		    Music.Sound (2100, 85)
		    Music.SoundOff

		    %selects a different target to draw
		    targetpicker := Rand.Int (2, 4)
		    %adds to score
		    score += 1
		    %updates screen
		    View.Update
		end if
	    elsif targetpicker = 2 then
		if shot >= 355 and shot <= 385 then
		    %plays sound effect
		    Music.Sound (900, 85)
		    Music.SoundOff
		    Music.Sound (1500, 85)
		    Music.SoundOff
		    Music.Sound (2100, 85)
		    Music.SoundOff

		    %loop for selecting a new target. it'll only exit the loop if the target is not the same one already on the screen
		    loop
			targetpicker := Rand.Int (1, 4)
			exit when not targetpicker = 2
		    end loop

		    %adds to score
		    score += 1
		    %updates screen
		    View.Update
		end if
	    elsif targetpicker = 3 then
		if shot >= 605 and shot <= 635 then
		    %sound effect
		    Music.Sound (900, 85)
		    Music.SoundOff
		    Music.Sound (1500, 85)
		    Music.SoundOff
		    Music.Sound (2100, 85)
		    Music.SoundOff

		    %loop for selecting a new target, will only exit loop if target picked is not the same one already on the screen
		    loop
			targetpicker := Rand.Int (1, 4)
			exit when not targetpicker = 3
		    end loop

		    %adds to score
		    score += 1
		    %updates screen
		    View.Update
		end if
	    elsif targetpicker = 4 then
		if shot >= 855 and shot <= 885 then
		    %sound effect
		    Music.Sound (900, 85)
		    Music.SoundOff
		    Music.Sound (1500, 85)
		    Music.SoundOff
		    Music.Sound (2100, 85)
		    Music.SoundOff
		    %picks a new target other than the one selected
		    targetpicker := Rand.Int (1, 3)
		    %adds to score
		    score += 1
		    %updates screen
		    View.Update
		end if
	    end if
	    %if no button is being pressed
	else
	    %turn all lights on
	    parallelput (255)
	end if
    end loop

    %loop for after the timer has run out, the game is over
    %this loop brings the motor and the aim back to the middle of model/screen
    loop
	%draws aim circle
	drawoval (xmover, 281, 25, 25, black)
	%updates screen
	View.Update
	%draws picture
	Pic.Draw (easyscreen, 0, 0, picCopy)

	%if aim circle is to the right of the middle of the screen
	if xmover > 500 then
	    %xmover is subtracted by 4, moving aim to the left
	    xmover -= 4
	    %turns motor left
	    forwardmotor
	elsif xmover < 500 then
	    %4 is added to xmover, moving aim to the right
	    xmover += 4
	    %turns motor right
	    backwardmotor
	end if
	%if xmover is exactly in the middle
	if xmover = 500 then
	    %go to the scorescreen procedure
	    scorescreen
	    %exit this loop
	    exit
	end if
    end loop
end game

%options screen procedure
body proc options
    %clears previous screen
    cls

    %draws background picture and title
    Pic.Draw (optionsscreen, 0, 0, picCopy)
    Font.Draw ("Options", 340, 500, font1, black)

    %draws text and boxes around options available
    %options for music
    Font.Draw ("Music:", 50, 450, font2, black)
    Font.Draw ("Delfino", 235, 450, font2, black)
    drawbox (230, 445, 460, 475, black)
    Font.Draw ("8Bit", 480, 450, font2, black)
    drawbox (475, 445, 600, 475, black)
    Font.Draw ("Underwater", 620, 450, font2, black)
    drawbox (615, 445, 990, 475, black)
    Font.Draw ("None", 235, 405, font2, black)
    drawbox (230, 400, 375, 430, black)

    %options for background
    Font.Draw ("Title Background:", 50, 360, font2, black)
    Font.Draw ("Default", 610, 360, font2, black)
    drawbox (605, 355, 860, 385, black)
    Font.Draw ("Minimal", 235, 315, font2, black)
    drawbox (230, 310, 490, 340, black)
    Font.Draw ("Old", 510, 315, font2, black)
    drawbox (505, 310, 615, 340, black)
    Font.Draw ("Cartoon", 635, 315, font2, black)
    drawbox (630, 310, 878, 340, black)

    %options for time
    Font.Draw ("Timer:", 50, 270, font2, black)
    Font.Draw ("1Min", 260, 270, font2, black)
    drawbox (255, 265, 395, 295, black)
    Font.Draw ("2Min", 410, 270, font2, black)
    drawbox (405, 265, 545, 295, black)
    Font.Draw ("3Min", 560, 270, font2, black)
    drawbox (555, 265, 695, 295, black)

    %loop for mouse location and buttons
    loop
	%checks mouse location and draws target for asthetic appeal
	mousewhere (x, y, button)
	drawfilloval (x, y, 25, 25, white)
	drawfilloval (x, y, 18, 18, black)
	drawfilloval (x, y, 11, 11, blue)
	drawfilloval (x, y, 4, 4, red)

	%updates screen
	View.Update

	%draws picture and text
	Pic.Draw (optionsscreen, 0, 0, picCopy)
	Font.Draw ("Options", 340, 500, font1, black)

	Font.Draw ("Music:", 50, 450, font2, black)

	%options for music, if certain boxes are pressed, certain music will play. The box pressed will turn red
	if x >= 230 and x <= 460 and y >= 445 and y <= 475 and button = 1 then
	    Font.Draw ("Delfino", 235, 450, font2, red)
	    drawbox (230, 445, 460, 475, red)
	    %music change
	    Music.PlayFileLoop ("delfino.mp3")
	    Font.Draw ("8Bit", 480, 450, font2, black)
	    drawbox (475, 445, 600, 475, black)
	    Font.Draw ("Underwater", 620, 450, font2, black)
	    drawbox (615, 445, 990, 475, black)
	    Font.Draw ("None", 235, 405, font2, black)
	    drawbox (230, 400, 375, 430, black)
	    delay (150)
	elsif x >= 475 and x <= 600 and y >= 445 and y <= 475 and button = 1 then
	    Font.Draw ("Delfino", 235, 450, font2, black)
	    drawbox (230, 445, 460, 475, black)
	    Font.Draw ("8Bit", 480, 450, font2, red)
	    drawbox (475, 445, 600, 475, red)
	    %music change
	    Music.PlayFileLoop ("8bit.mp3")
	    Font.Draw ("Underwater", 620, 450, font2, black)
	    drawbox (615, 445, 990, 475, black)
	    Font.Draw ("None", 235, 405, font2, black)
	    drawbox (230, 400, 375, 430, black)
	    delay (150)
	elsif x >= 615 and x <= 990 and y >= 445 and y <= 475 and button = 1 then
	    Font.Draw ("Delfino", 235, 450, font2, black)
	    drawbox (230, 445, 460, 475, black)
	    Font.Draw ("8Bit", 480, 450, font2, black)
	    drawbox (475, 445, 600, 475, black)
	    Font.Draw ("Underwater", 620, 450, font2, red)
	    drawbox (615, 445, 990, 475, red)
	    %music change
	    Music.PlayFileLoop ("underwater.mp3")
	    Font.Draw ("None", 235, 405, font2, black)
	    drawbox (230, 400, 375, 430, black)
	    delay (150)
	elsif x >= 230 and x <= 375 and y >= 400 and y <= 430 and button = 1 then
	    Font.Draw ("Delfino", 235, 450, font2, black)
	    drawbox (230, 445, 460, 475, black)
	    Font.Draw ("8Bit", 480, 450, font2, black)
	    drawbox (475, 445, 600, 475, black)
	    Font.Draw ("Underwater", 620, 450, font2, black)
	    drawbox (615, 445, 990, 475, black)
	    Font.Draw ("None", 235, 405, font2, red)
	    drawbox (230, 400, 375, 430, red)
	    %stops playing music alltogether
	    Music.PlayFileStop
	else
	    Font.Draw ("Delfino", 235, 450, font2, black)
	    drawbox (230, 445, 460, 475, black)
	    Font.Draw ("8Bit", 480, 450, font2, black)
	    drawbox (475, 445, 600, 475, black)
	    Font.Draw ("Underwater", 620, 450, font2, black)
	    drawbox (615, 445, 990, 475, black)
	    Font.Draw ("None", 235, 405, font2, black)
	    drawbox (230, 400, 375, 430, black)
	end if

	Font.Draw ("Title Background:", 50, 360, font2, black)

	%options for background of title screen, if certain boxes are pressed, certain pictures will be drawn on THE TITLE SCREEN. The box pressed will turn red
	if x >= 605 and x <= 860 and y >= 355 and y <= 385 and button = 1 then
	    Font.Draw ("Default", 610, 360, font2, red)
	    drawbox (605, 355, 860, 385, red)
	    %mainscreen get re-declared
	    mainscreen := Pic.FileNew ("marioscreen.jpg")
	    Font.Draw ("Minimal", 235, 315, font2, black)
	    drawbox (230, 310, 490, 340, black)
	    Font.Draw ("Old", 510, 315, font2, black)
	    drawbox (505, 310, 615, 340, black)
	    Font.Draw ("Cartoon", 635, 315, font2, black)
	    drawbox (630, 310, 878, 340, black)
	elsif x >= 230 and x <= 490 and y >= 310 and y <= 340 and button = 1 then
	    Font.Draw ("Default", 610, 360, font2, black)
	    drawbox (605, 355, 860, 385, black)
	    Font.Draw ("Minimal", 235, 315, font2, red)
	    drawbox (230, 310, 490, 340, red)
	    %mainscreen gets re-declared
	    mainscreen := Pic.FileNew ("minimaltitle.jpg")
	    Font.Draw ("Old", 510, 315, font2, black)
	    drawbox (505, 310, 615, 340, black)
	    Font.Draw ("Cartoon", 635, 315, font2, black)
	    drawbox (630, 310, 878, 340, black)
	elsif x >= 505 and x <= 615 and y >= 310 and y <= 340 and button = 1 then
	    Font.Draw ("Default", 610, 360, font2, black)
	    drawbox (605, 355, 860, 385, black)
	    Font.Draw ("Minimal", 235, 315, font2, black)
	    drawbox (230, 310, 490, 340, black)
	    Font.Draw ("Old", 510, 315, font2, red)
	    drawbox (505, 310, 615, 340, red)
	    %mainscreen gets re-delcared
	    mainscreen := Pic.FileNew ("oldschooltitle.jpg")
	    Font.Draw ("Cartoon", 635, 315, font2, black)
	    drawbox (630, 310, 878, 340, black)
	elsif x >= 630 and x <= 878 and y >= 310 and y <= 340 and button = 1 then
	    Font.Draw ("Default", 610, 360, font2, black)
	    drawbox (605, 355, 860, 385, black)
	    Font.Draw ("Minimal", 235, 315, font2, black)
	    drawbox (230, 310, 490, 340, black)
	    Font.Draw ("Old", 510, 315, font2, black)
	    drawbox (505, 310, 615, 340, black)
	    Font.Draw ("Cartoon", 635, 315, font2, red)
	    drawbox (630, 310, 878, 340, red)
	    %mainscreen gets re-declared
	    mainscreen := Pic.FileNew ("cartoon2.jpg")
	else
	    Font.Draw ("Default", 610, 360, font2, black)
	    drawbox (605, 355, 860, 385, black)
	    Font.Draw ("Minimal", 235, 315, font2, black)
	    drawbox (230, 310, 490, 340, black)
	    Font.Draw ("Old", 510, 315, font2, black)
	    drawbox (505, 310, 615, 340, black)
	    Font.Draw ("Cartoon", 635, 315, font2, black)
	    drawbox (630, 310, 878, 340, black)
	end if

	Font.Draw ("Timer:", 50, 270, font2, black)

	%options for time, if certain boxes are pressed, the time for playing the game will change. The box pressed will turn red
	if x >= 255 and x <= 395 and y >= 265 and y <= 295 and button = 1 then
	    Font.Draw ("1Min", 260, 270, font2, red)
	    drawbox (255, 265, 395, 295, red)
	    %sets time to 60 seconds
	    timeend := 60
	    Font.Draw ("2Min", 410, 270, font2, black)
	    drawbox (405, 265, 545, 295, black)
	    Font.Draw ("3Min", 560, 270, font2, black)
	    drawbox (555, 265, 695, 295, black)
	elsif x >= 405 and x <= 545 and y >= 265 and y <= 295 and button = 1 then
	    Font.Draw ("1Min", 260, 270, font2, black)
	    drawbox (255, 265, 395, 295, black)
	    Font.Draw ("2Min", 410, 270, font2, red)
	    drawbox (405, 265, 545, 295, red)
	    %sets time to 120 seconds
	    timeend := 120
	    Font.Draw ("3Min", 560, 270, font2, black)
	    drawbox (555, 265, 695, 295, black)
	elsif x >= 555 and x <= 695 and y >= 265 and y <= 295 and button = 1 then
	    Font.Draw ("1Min", 260, 270, font2, black)
	    drawbox (255, 265, 395, 295, black)
	    Font.Draw ("2Min", 410, 270, font2, black)
	    drawbox (405, 265, 545, 295, black)
	    Font.Draw ("3Min", 560, 270, font2, red)
	    drawbox (555, 265, 695, 295, red)
	    %sets time to 180 seconds
	    timeend := 180
	else
	    Font.Draw ("1Min", 260, 270, font2, black)
	    drawbox (255, 265, 395, 295, black)
	    Font.Draw ("2Min", 410, 270, font2, black)
	    drawbox (405, 265, 545, 295, black)
	    Font.Draw ("3Min", 560, 270, font2, black)
	    drawbox (555, 265, 695, 295, black)
	end if

	%if statements for going back to the main screen or playing
	if x >= 95 and x <= 245 and y >= 35 and y <= 75 and button = 0 then
	    Font.Draw ("Back", 100, 40, font2, brightred)
	    drawbox (95, 35, 245, 75, brightred)
	elsif x >= 95 and x <= 245 and y >= 35 and y <= 75 and button = 1 then
	    %goes to title screen
	    titlescreen
	    exit
	else
	    Font.Draw ("Back", 100, 40, font2, black)
	    drawbox (95, 35, 245, 75, black)
	end if
	if x >= 695 and x <= 840 and y >= 35 and y <= 75 and button = 0 then
	    Font.Draw ("Play", 700, 40, font2, brightred)
	    drawbox (695, 35, 840, 75, brightred)
	elsif x >= 695 and x <= 840 and y >= 35 and y <= 75 and button = 1 then
	    %goes to game
	    game
	    exit
	else
	    Font.Draw ("Play", 700, 40, font2, black)
	    drawbox (695, 35, 840, 75, black)
	end if
    end loop
end options

%main procedure for final scorescreen
body proc scorescreen
    %the user's final score is the score divided by time
    %this means that the higher your score is, the better
    finalscore := score / timeend

    %clears screen
    cls

    %draws picture and text
    Pic.Draw (scorepic, 0, 0, picCopy)
    Font.Draw ("Game Over", 290, 500, font1, brightred)
    Font.Draw ("Final Score:", 200, 300, font2, brightred)

    %writes score, "realstr" converts final score to a string going to 4 decimal places
    Font.Draw (realstr (finalscore, 4), 570, 300, font2, brightred)
    %updates screen
    View.Update

    %loop for mouse and buttons
    loop
	%draws text and score
	Font.Draw ("Game Over", 290, 500, font1, brightred)
	Font.Draw ("Final Score:", 200, 300, font2, brightred)
	Font.Draw (realstr (finalscore, 4), 570, 300, font2, brightred)
	%mouse location, draws target around mouse
	mousewhere (x, y, button)
	drawfilloval (x, y, 25, 25, white)
	drawfilloval (x, y, 18, 18, black)
	drawfilloval (x, y, 11, 11, blue)
	drawfilloval (x, y, 4, 4, red)
	%updates screen
	View.Update
	%draws picture
	Pic.Draw (scorepic, 0, 0, picCopy)

	%is statements for where the user wants to go after the game is done, changes color when mouse hovers over
	if x >= 95 and x <= 260 and y >= 35 and y <= 75 and button = 0 then
	    Font.Draw ("Home", 100, 40, font2, brightred)
	    drawbox (95, 35, 260, 75, brightred)
	elsif x >= 95 and x <= 260 and y >= 35 and y <= 75 and button = 1 then
	    %resets variables
	    score := 0
	    timepassed := 0
	    finalscore := 0

	    %goes to title screen
	    titlescreen

	    %exits loop
	    exit
	else
	    Font.Draw ("Home", 100, 40, font2, black)
	    drawbox (95, 35, 260, 75, black)
	end if
	if x >= 350 and x <= 585 and y >= 35 and y <= 75 and button = 0 then
	    Font.Draw ("Options", 355, 40, font2, brightred)
	    drawbox (350, 35, 585, 75, brightred)
	elsif x >= 350 and x <= 585 and y >= 35 and y <= 75 and button = 1 then
	    %resets variables
	    score := 0
	    timepassed := 0
	    finalscore := 0

	    %goes to options
	    options

	    %exits loop
	    exit
	else
	    Font.Draw ("Options", 355, 40, font2, black)
	    drawbox (350, 35, 585, 75, black)
	end if
	if x >= 695 and x <= 840 and y >= 35 and y <= 75 and button = 0 then
	    Font.Draw ("Play", 700, 40, font2, brightred)
	    drawbox (695, 35, 840, 75, brightred)
	elsif x >= 695 and x <= 840 and y >= 35 and y <= 75 and button = 1 then
	    %resets variables
	    score := 0
	    timepassed := 0
	    finalscore := 0

	    %goes to game again
	    game

	    %exits loop
	    exit
	else
	    Font.Draw ("Play", 700, 40, font2, black)
	    drawbox (695, 35, 840, 75, black)
	end if
    end loop
end scorescreen

%plays default music
Music.PlayFileLoop ("delfino.mp3")

%goes to title screen procedure, this is technically the first thing that happens in the program
titlescreen

