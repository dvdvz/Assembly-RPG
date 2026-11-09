# Bao Le, Heaven Neumann, Gargeya Smruti Ranjan Lnu, David Zeman
# 4/13/2026	CS2640
# Final Program: Choose Your Own Adventure

.include "macros.asm"

.eqv CHOICE, $s0 # letter A, B, C, etc.
.eqv PATH, $s1 # most recently visited path number
.eqv POWER, $s2 # strength of the player character based on various decisions

.eqv piano, 1
.eqv organ, 20
.eqv drums, 47
.eqv horns, 57
.eqv flute, 74
.eqv delay, 121

.macro ifChoiceThenPath (%choice, %path) # sets path number based on the desired letter choice
	bne CHOICE, %choice, noPath
	li PATH, %path
	noPath:
.end_macro

.data
title: .asciiz "     ___ _  _  ___   ___  ___ ___  __   _____  _   _ ___    _____      ___  _     _   _____   _____ _  _ _____ _   _ ___ ___\n    / __| || |/ _ \\ / _ \\/ __| __| \\ \\ / / _ \\| | | | _ \\  / _ \\ \\    / / \\| |   /_\\ |   \\ \\ / / __| \\| |_   _| | | | _ \\ __|\n   | (__| __ | (_) | (_) \\__ \\ _|   \\ V / (_) | |_| |   / | (_) \\ \\/\\/ /| .` |  / _ \\| |) \\ V /| _|| .` | | | | |_| |   / _|\n    \\___|_||_|\\___/ \\___/|___/___|   |_| \\___/ \\___/|_|_\\  \\___/ \\_/\\_/ |_|\\_| /_/ \\_\\___/ \\_/ |___|_|\\_| |_|  \\___/|_|_\\___|\n"
divider1: .asciiz "\n __ /\\ __       __ /\\ __       __ /\\ __       __ /\\ __       __ /\\ __       __ /\\ __       __ /\\ __       __ /\\ __       __ /\\ __\n \\_`\\/`_/ .\\'/. \\_`\\/`_/ .\\'/. \\_`\\/`_/ .\\'/. \\_`\\/`_/ .\\'/. \\_`\\/`_/ .\\'/. \\_`\\/`_/ .\\'/. \\_`\\/`_/ .\\'/. \\_`\\/`_/ .\\'/. \\_`\\/`_/\n <_>()<_>-=>*<=-<_>()<_>-=>*<=-<_>()<_>-=>*<=-<_>()<_>-=>*<=-<_>()<_>-=>*<=-<_>()<_>-=>*<=-<_>()<_>-=>*<=-<_>()<_>-=>*<=-<_>()<_>\n /_,/\\,_\\ '/.\\' /_,/\\,_\\ '/.\\' /_,/\\,_\\ '/.\\' /_,/\\,_\\ '/.\\' /_,/\\,_\\ '/.\\' /_,/\\,_\\ '/.\\' /_,/\\,_\\ '/.\\' /_,/\\,_\\ '/.\\' /_,/\\,_\\\n    \\/             \\/             \\/             \\/             \\/             \\/             \\/             \\/             \\/\n"
playerName: .space 32
youWin: .asciiz "\n      _________________________________________________\n     /\\                                                \\\n (O)===)><><><><><><><><><><><><><><><><><><><><><><><><)==(O)\n     \\/''''''''''''''''''''''''''''''''''''''''''''''''/\n     (                                                (\n      )    __   _____  _   _  __      _____ _  _       )\n     (     \\ \\ / / _ \\| | | | \\ \\    / /_ _| \\| |     (\n      )     \\ V / (_) | |_| |  \\ \\/\\/ / | || .` |      )\n             |_| \\___/ \\___/    \\_/\\_/ |___|_|\\_|\n     (                                                (\n      )                                                )\n     (                                                (\n     /\\''''''''''''''''''''''''''''''''''''''''''''''''\\\n (O)===)><><><><><><><><><><><><><><><><><><><><><><><><)==(O)\n     \\/________________________________________________/\n"
gameOver: .asciiz "\n      _______________________________________________________\n     /\\                                                      \\\n (O)===)><><><><><><><><><><><><><><><><><><><><><><><><><><><)==(O)\n     \\/''''''''''''''''''''''''''''''''''''''''''''''''''''''/\n     (                                                      (\n      )      ___   _   __  __ ___    _____   _____ ___       )\n     (      / __| /_\\ |  \\/  | __|  / _ \\ \\ / / __| _ \\     (\n      )    | (_ |/ _ \\| |\\/| | _|  | (_) \\ V /| _||   /      )\n            \\___/_/ \\_\\_|  |_|___|  \\___/ \\_/ |___|_|_\\\n     (                                                      (\n      )                                                      )\n     (                                                      (\n     /\\''''''''''''''''''''''''''''''''''''''''''''''''''''''\\\n (O)===)><><><><><><><><><><><><><><><><><><><><><><><><><><><)==(O)\n     \\/______________________________________________________/\n"

# TRACK 1 / INTRO
pitches1: .byte # 60 is middle C, octaves are 12 notes apart
49, 49, 49, 42,
61, 68, 66, 0, 61, 64
durations1: .word # in milliseconds
400, 400, 400, 1600,
400, 400, 400, 400, 400, 2000,
0 # null terminator
instruments1: .byte # use eqv's
drums, drums, drums, drums,
horns, horns, horns, delay, horns, horns

# TRACK 2
pitches2: .byte
40, 64,
52, 55, 60, 59,
40, 62,
52, 55, 60, 59, 63
durations2: .word
350, 700,
350, 350, 350, 2100,
350, 700,
350, 350, 350, 350, 2100,
0
instruments2: .byte
0, 0,
piano, piano, piano, piano,
0, 0,
piano, piano, piano, piano, piano

# TRACK 3
pitches3: .byte
54,
54, 56, 57, 57, 59, 61,
59, 61, 57, 56, 57, 56,
54
durations3: .word
800,
200, 200, 400, 200, 200, 400,
600, 200, 400, 600, 200, 400,
800,
0
instruments3: .byte
organ,
organ, organ, organ, organ, organ, organ,
organ, organ, organ, organ, organ, organ,
organ

.text
start: # print menu, play intro, get player's name, and give them their first set of options
	printString(divider1)
	printString(title)
	printString(divider1)
	la $t0, pitches1
	la $t1, durations1
	la $t2, instruments1
	jal playMusic
	jal getName
	printNewDelayedString("\nHello there, ")
	printString(playerName)
	printNewDelayedString("\nThe princess has been abducted by the Demon King and you have been chosen to save her.\nOn your way you encounter a merchant that is being attacked by monsters! Will you...\n    A) Save the merchant.\n    B) Avoid and continue on your journey.\n\nWhat will you do? ")
	jal twoOptions
	ifChoiceThenPath('A', 1)
	ifChoiceThenPath('B', 2)
	j branchToPath

playMusic: # reusable music function, max volume. load pitches/durations/instruments into $t0/$t1/$t2 before calling
	dummyNote
	musicLoop:
		li $v0, 31
		lw $a1, ($t1)
		beqz $a1, musicDone
		lb $a0, ($t0)
		lb $a2, ($t2)
		li $a3, 127
		syscall
		setSleep($a1)
		add $t0, $t0, 1
		add $t1, $t1, 4
		add $t2, $t2, 1
		j musicLoop
	musicDone:
		dummyNote
		jr $ra

getName:
	printNewDelayedString("\nPlease enter your name: ")
	li $v0, 8
	la $a0, playerName
	li $a1, 32
	syscall
	la $t0, playerName
	nameLoop:
		lb $t1, 0($t0)
		beq $t1, '\n', nameDone
		add $t0, $t0, 1
		branchAlphanumeric($t1, nameLoop, badChar)
	badChar:
		printNewDelayedString("\nLetters and numbers only. 32 characters or less.\n")
		j getName
	nameDone: jr $ra

twoOptions: # gets the user's choice between two options and stores the letter in CHOICE
	getChar(CHOICE)
	branchLetterRange(CHOICE, 'A', 'B', twoOptionsDone, invalidTwo)
	invalidTwo:
		printNewDelayedString("\nPlease choose A or B.\n")
		j twoOptions
	twoOptionsDone: jr $ra

threeOptions:
	getChar(CHOICE)
	branchLetterRange(CHOICE, 'A', 'C', threeOptionsDone, invalidThree)
	invalidThree:
		printNewDelayedString("\nPlease choose A, B, or C.\n")
		j threeOptions
	threeOptionsDone: jr $ra

fourOptions:
	getChar(CHOICE)
	branchLetterRange(CHOICE, 'A', 'D', fourOptionsDone, invalidFour)
	invalidFour:
		printNewDelayedString("\nPlease choose A, B, C, or D.\n")
		j fourOptions
	fourOptionsDone: jr $ra

branchToPath: # save states / path checker
	beq PATH, 1, helpMerchant
	beq PATH, 2, avoidMerchant
	beq PATH, 3, reachCity
	beq PATH, 4, restInCity
	beq PATH, 5, exploreCity
	beq PATH, 6, skipCity
	beq PATH, 7, demonKingRecruitment
	beq PATH, 8, gainCompanions
	beq PATH, 9, loneWolf
	beq PATH, 10, legendarySword
	beq PATH, 11, pullSword
	beq PATH, 12, exploreDeeper
	beq PATH, 13, reachCastle
	beq PATH, 14, stormGate
	beq PATH, 15, sneakIn
	beq PATH, 16, confrontDemonKing
	beq PATH, 17, kneel
	beq PATH, 18, faceHim
	beq PATH, 98, goodEnding
	beq PATH, 99, badEnding
	exitProgram

helpMerchant:
	printNewDelayedString("\n\nYou're able to save the merchant!!\nYou lost your arm, but gained a friend for life.")
	printNewDelayedString("\nParty Member Acquired: Merchant")
	add POWER, POWER, 10
	j reachCity

avoidMerchant:
	printNewDelayedString("\n\nYou avoid the merchant only to find that this new path leads you directly to a pack of wolves.\nYou narrowly escape after losing an arm to the wolves.")
	add POWER, POWER, 1
	j reachCity

reachCity:
	printNewDelayedString("\n\nAfter some walking, you reach a city.\n    A) Find an inn and rest, then head out the next day.\n    B) Explore the market.\n    C) Skip past the city and continue on your adventure.\n\nWhat will you do? ")
	jal threeOptions
	ifChoiceThenPath('A', 4)
	ifChoiceThenPath('B', 5)
	ifChoiceThenPath('C', 6)
	j branchToPath

restInCity:
	printNewDelayedString("\n\nYou find a comfortable place to stay for a reasonable price, and once the night passes, you continue on the next morning.")
	add POWER, POWER, 3
	j demonKingRecruitment
	
exploreCity:
	printNewDelayedString("\n\nWhile exploring the market, you find a potion that can heal your missing arm.")
	beq POWER, 10, getPotion
	beq POWER, 1, noPotion
	getPotion:
		printNewDelayedString("\nWondering how you are going to pay for the potion, you see someone handing it to you.")
		printNewDelayedString("\nThe merchant from earlier is buying you the potion to repay you for saving him. You use the potion and get your arm back.")
		add POWER, POWER, 5
		j demonKingRecruitment
	noPotion:
		printNewDelayedString("\nWithout a cent to your name, you have to leave the potion behind, regardless of how much you need it.")
		add POWER, POWER, 1
		j demonKingRecruitment

skipCity:
	printNewDelayedString("\n\nDetermined to continue on your journey, you skip past the city.\nYou don't make it very far, and collapse from overexhaustion just as you reach city limits.")
	j badEnding

demonKingRecruitment:
	printNewDelayedString("\n\nOn your way out of the city, you see recruitment posters to fight the Demon King...\n    A) Join the group of adventurers.\n    B) Continue on your way.\n\nWhat will you do? ")
	jal twoOptions
	ifChoiceThenPath('A', 8)
	ifChoiceThenPath('B', 9)
	j branchToPath

gainCompanions:
	printNewDelayedString("\n\nParty Members Acquired: Sylve the Elf, Bart the Barbarian, and Merlin the Wizard.")
	mul POWER, POWER, 2
	j legendarySword

loneWolf:
	printNewDelayedString("\n\nYou leave the city and continue on your way.")
	add POWER, POWER, 1
	j legendarySword

legendarySword:
	printNewDelayedString("\n\nAfter a long trek, you reach the legendary sword that is used to defeat the Demon King.\n    A) Attempt to pull out the legendary sword from the stone.\n    B) Move on and explore deeper into the path to see what other secrets it holds.\n\nWhat will you do? ")
	jal twoOptions
	ifChoiceThenPath('A', 11)
	ifChoiceThenPath('B', 12)
	j branchToPath

pullSword:
	beq POWER, 22, withCompanions
	beq POWER, 30, withCompanions
	beq POWER, 8, withCompanions
	beq POWER, 4, withCompanions
	beq POWER, 16, noCompanions
	aloneOneArm:
		printNewDelayedString("\n\nYou try pulling out the sword, but fail because you only have one arm.\nThe sword remains in the stone. You must continue without it.")
		mul POWER, POWER, 3
		j reachCastle
	withCompanions:
		printNewDelayedString("\n\nYour companions cheer you on. With their encouragement, you pull the sword free.\nIts blade glows with an ancient power.")
		mul POWER, POWER, 3
		j reachCastle
	noCompanions:
		printNewDelayedString("\n\nUsing both arms and all your strength, you were able to pull out the sword.\nIts blade sighs with a mysterious power.")
		mul POWER, POWER, 3
		j reachCastle

exploreDeeper:
	printNewDelayedString("\n\nYou discover a hidden cave containing armor that increases your defense.\nEquipped with this new gear, you feel ready to face whatever lies ahead.\nYou return to the entrance and continue your journey.")
	j reachCastle

reachCastle:
	printNewDelayedString("\n\nYou reach the base of the Demon King's castle. It is surrounded in dark clouds.")
	beq POWER, 66, elfInParty
	beq POWER, 25, elfInParty
	beq POWER, 90, elfInParty
	beq POWER, 33, elfInParty
	beq POWER, 34, elfInParty
	beq POWER, 11, elfInParty
	beq POWER, 12, elfInParty
	beq POWER, 7, elfInParty
	printNewDelayedString("\n\nWith no other option, you attempt to storm the gates.")
	beq POWER, 48, loneWithSword
	printNewDelayedString("\nThe guards overwhelm you.")
	j badEnding
	elfInParty:
		printNewDelayedString("\n\n    A) Attempt to storm the front gate.\n    B) Take the secret passage that Sylve the elf spotted along the side of the fortress.\n What will you do? ")
		jal twoOptions
		ifChoiceThenPath('A', 14)
		ifChoiceThenPath('B', 15)
		j branchToPath
	loneWithSword:
		printNewDelayedString("\n\nYou fight with maximum effort. You get through the gates alone but are wounded.\nYou press on.")
		j confrontDemonKing

stormGate:
	beq POWER, 66, withSword
	beq POWER, 90, withSword
	beq POWER, 34, withSword
	beq POWER, 12, withSword
	withoutSword:
		printNewDelayedString("\n\nYou and your party fight valiantly and are able to defeat the guards with some effort.\nYou enter the fortress.")
		j confrontDemonKing
	withSword:
		printNewDelayedString("\n\nYour party fights though the demon guards with ease. The sword cuts the gates and demons with ease.\nYou enter the fortress.")
		j confrontDemonKing

sneakIn:
	printNewDelayedString("\n\nYou sneak inside undetected.")
	j confrontDemonKing


confrontDemonKing:
	printNewDelayedString("\n\nInside the fortress, you find the princess locked in a cell at the top of a tower guarded by the Demon King himself.\nHe offers you a choice.\n    A) Kneel and serve him, he'll spare your life.\n    B) Face him in combat.\nWhat will you do? ")
	jal twoOptions
	ifChoiceThenPath('A', 17)
	ifChoiceThenPath('B', 18)
	j branchToPath

kneel:
	printNewDelayedString("\n\nYou kneel.\nThe kingdom falls and the princess is never rescued.")
	j badEnding

faceHim:
	beq POWER, 66, easyWin
	beq POWER, 90, easyWin
	beq POWER, 34, easyWin
	beq POWER, 12, easyWin
	beq POWER, 25, hardWin
	beq POWER, 33, hardWin
	beq POWER, 11, hardWin
	beq POWER, 3, hardWin
	printNewDelayedString("\n\nYou fight with everything you've got, but the Demon King's power is too much for you to handle.")
	j badEnding
	easyWin:
		printNewDelayedString("\n\nThe sword's ancient magic turns out to be anti-demon magic. After a fierce battle, you strike the final blow.")
		j goodEnding	
	hardWin:
		printNewDelayedString("\n\nThe battle is long and devastating. Sylve the Elf sacrifices herself so you are able to deal the final blow.\nThe Demon King is dead, but at the cost of your love, Sylve.")
		j goodEnding

goodEnding: # prints good ending screen and plays winning music
	printNewDelayedString("\n\nYou carry the princess out of the wretched castle as the Demon King’s power fades. The kingdom weeps with joy and you are named a Hero of the realm. Peace reigns once again.\n")
	printString(youWin)
	la $t0, pitches3
	la $t1, durations3
	la $t2, instruments3
	jal playMusic
	exitProgram

badEnding: # prints bad ending screen and plays losing music
	printNewDelayedString("\n\nThe Demon King takes over the world. Your name has been dishonored. The kingdom vanishes.\n")
	printString(gameOver)
	la $t0, pitches2
	la $t1, durations2
	la $t2, instruments2
	jal playMusic
	exitProgram
