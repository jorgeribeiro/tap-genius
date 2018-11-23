-- Tap Genius
-- Developed by Jorge Ribeiro
-- joorgemelo@gmail.com

-- esconde a barra de Status
display.setStatusBar(display.HiddenStatusBar)

-- carregar biblioteca Widget
local widget = require( "widget" )

-- carrega Backgrounds
local background = display.newImage( "background.png", display.contentCenterX, display.contentCenterY )
local backgroundRed = display.newImage( "backgroundRed.png", display.contentCenterX, display.contentCenterY ) backgroundRed.alpha = 0
local backgroundGreen = display.newImage( "backgroundGreen.png", display.contentCenterX, display.contentCenterY ) backgroundGreen.alpha = 0
local backgroundBlue = display.newImage( "backgroundBlue.png", display.contentCenterX, display.contentCenterY ) backgroundBlue.alpha = 0
local backgroundYellow = display.newImage( "backgroundYellow.png", display.contentCenterX, display.contentCenterY ) backgroundYellow.alpha = 0

-- inicia Variáveis
local playButton
local creditsButton
local mainGroup
local interface
local logoCenter
local tableGenerator
local redButton
local greenButton
local blueButton
local yellowButton
local number
local countSongTable
local countReceiveSongTable
local countCompareSongTable	
local timerSrc
local score
local scoreText
local musicNumber

-- inicia Tabelas/Funções
local Main = {}
local startButtonListeners = {}
local showCredits = {}
local hideCredits = {}
local showGameView = {}
local gameListeners = {}
local generateSongTable = {}
local tableList = {}
local playSongTable = {}
local receiveSongTable = {}
local compareSongTable = {}
local removeColorButtons = {}
local disableColorButtons = {}
local fadeInOut = {}

-- inicia Sons
local song1 = audio.loadSound( "song1.ogg" )
local song2 = audio.loadSound( "song2.ogg" )
local song3 = audio.loadSound( "song3.ogg" )
local song4 = audio.loadSound( "song4.ogg" )

-- função Principal
function Main()
	audio.setVolume( 0.5 )
	playButton = widget.newButton
	{
		defaultFile = "playButton.png",
		overFile = "playButtonOver.png",
		onRelease = showGameView
	}
	playButton.x = display.contentCenterX
	playButton.y = display.contentCenterY + 160

	creditsButton = widget.newButton
	{
		defaultFile = "creditsButton.png",
		overFile = "creditsButtonOver.png",
		onRelease = showCredits
	}
	creditsButton.x = display.contentCenterX
	creditsButton.y = display.contentCenterY + 210

	redButton = widget.newButton
	{
		defaultFile = "redButton.png",
		overFile = "redButtonOver.png",
		onPress = function() audio.play( song1 ) fadeInOut( 1 ) end
	}
	redButton.x = display.contentCenterX + 68.5
	redButton.y = display.contentCenterY - 69.5

	greenButton = widget.newButton
	{
		defaultFile = "greenButton.png",
		overFile = "greenButtonOver.png",
		onPress = function() audio.play( song2 ) fadeInOut( 2 ) end
	}
	greenButton.x = display.contentCenterX - 69.5
	greenButton.y = display.contentCenterY - 69.5
	
	blueButton = widget.newButton
	{
		defaultFile = "blueButton.png",
		overFile = "blueButtonOver.png",
		onPress = function() audio.play( song3 ) fadeInOut( 3 ) end
	}
	blueButton.x = display.contentCenterX - 68.5
	blueButton.y = display.contentCenterY + 68.5

	yellowButton = widget.newButton
	{
		defaultFile = "yellowButton.png",
		overFile = "yellowButtonOver.png",
		onPress = function() audio.play( song4 ) fadeInOut( 4 ) end
	}
	yellowButton.x = display.contentCenterX + 68.5
	yellowButton.y = display.contentCenterY + 68.5

	logoCenter = display.newImage( "logoCenter.png", display.contentCenterX + 0.5, display.contentCenterY + 0.5 )

	myText = display.newText( "Toque nas cores para escutar!", display.contentCenterX, display.contentCenterY - 185, "Helvetica", 20 )

	interface = display.newImage( "interface.png", display.contentCenterX, display.contentCenterY )
	interface.isVisible = false

	mainGroup = display.newGroup( playButton, creditsButton )

	number = 1
	countSongTable = 1
	countReceiveSongTable = 1
	countCompareSongTable = 1
	score = 0

	startButtonListeners( "add" )
end

-- função que recebe o toque para exibir o Alerta
local function onTap( event )
    if event.action == "clicked" then
        if event.index == 1 then
            Main()
         elseif event.event.index == 2 then
         	--Não fará nada
        end
    end
end

-- função de Touch
function startButtonListeners( action )
	if action == "add" then
		playButton:addEventListener( "tap", showGameView )
		creditsButton:addEventListener( "tap", showCredits )
	else
		playButton:removeEventListener( "tap", showGameView )
		creditsButton:removeEventListener( "tap", showCredits )
	end
end

-- função de chamada dos Créditos
function showCredits( event )
	gameViewFalse()
	creditsView = display.newImage( "credits.png", 300, display.contentCenterY )
	transition.to( creditsView, {time = 100, x = display.contentCenterX, onComplete = function() creditsView:addEventListener( "tap", hideCredits ) end} )
end

-- função de finalizar Créditos
function hideCredits( event )	
	transition.to( creditsView, {time = 300, y = -700, onComplete = function() creditsView:removeEventListener( "tap", hideCredits ) display.remove( creditsView ) creditsView = nil end} )
	gameViewTrue()

end

-- função de início do Jogo
function showGameView( event )
	gameViewFalse()
	generateSongTable()
	scoreText = display.newText( "Score = "..score, display.contentCenterX, display.contentCenterY + 150, native.systemFont, 20 )
	gameListeners( "play" )
end

-- função que gera sequência de Cores
function generateSongTable()
	-- 1 = Red, 2 = Green, 3 = Blue, 4 = Yellow
	for i = 1, 500 do
		tableList[i] = math.random(4)
	end
	print( "Tabela de cores gerada!" )
end

-- executa a sequência a ser Repetida
function playSongTable()
	if tableList[countSongTable] == 1 then
		countSongTable = countSongTable + 1
		redLight = display.newImage( "redButtonOver.png", display.contentCenterX + 68.5, display.contentCenterY - 69.5 )
		audio.play( song1, {duration = 900, onComplete = function() display.remove( redLight ) display.remove( buttonCenter ) if countSongTable <= number then gameListeners( "play" ) else countSongTable = 1 number = number + 1 interface.isVisible = false 	receiveSongTable() end end} )
	elseif tableList[countSongTable] == 2 then
		countSongTable = countSongTable + 1
		greenLight = display.newImage( "greenButtonOver.png", display.contentCenterX - 69.5, display.contentCenterY - 69.5 )
		audio.play( song2, {duration = 900, onComplete = function() display.remove( greenLight ) display.remove( buttonCenter ) if countSongTable <= number then gameListeners( "play" ) else countSongTable = 1 number = number + 1 interface.isVisible = false receiveSongTable() end end} )
	elseif tableList[countSongTable] == 3 then
		countSongTable = countSongTable + 1
		blueLight = display.newImage( "blueButtonOver.png", display.contentCenterX - 68.5, display.contentCenterY + 68.5 )
		audio.play( song3, {duration = 900, onComplete = function() display.remove( blueLight ) display.remove( buttonCenter ) if countSongTable <= number then gameListeners( "play" ) else countSongTable = 1 number = number + 1 interface.isVisible = false receiveSongTable() end end} )
	elseif tableList[countSongTable] == 4 then
		countSongTable = countSongTable + 1
		yellowLight = display.newImage( "yellowButtonOver.png", display.contentCenterX + 68.5, display.contentCenterY + 68.5 )
		audio.play( song4, {duration = 900, onComplete = function() display.remove( yellowLight ) display.remove( buttonCenter ) if countSongTable <= number then gameListeners( "play" ) else countSongTable = 1 number = number + 1 interface.isVisible = false receiveSongTable() end end} )
	end
	buttonCenter = display.newImage( "logoCenter.png", display.contentCenterX + 0.5, display.contentCenterY + 0.5 )
end

-- insere um delay na função playSongTable
function gameListeners( action, time )
	countCompareSongTable = 1
	interface.isVisible = false
	interface = display.newImage( "interface.png", display.contentCenterX, display.contentCenterY )
	scoreText.isVisible = false
	scoreText = display.newText( "Score = "..score, display.contentCenterX, display.contentCenterY + 150, native.systemFont, 20 )

	if( action == "play" ) then
			if ( number == 1 ) then
				timerSrc = timer.performWithDelay( 400, playSongTable )
			else
				timerSrc = timer.performWithDelay( 30, playSongTable )
			end
	elseif(action == "play2" ) then
		timerSrc = timer.performWithDelay( time, playSongTable )		
	else
		timer.cancel(timerSrc)
		timerSrc = nil
	end
end

--função que recebe a sequência do Jogador
function receiveSongTable()	
	redButton = widget.newButton
	{
		defaultFile = "redButton.png",
		overFile = "redButtonOver.png",
		onRelease = function() compareSongTable( 1 ) end,
		onPress = function() countReceiveSongTable = countReceiveSongTable + 1 audio.play( song1 ) fadeInOut( 1 ) end
	}
	redButton.x = display.contentCenterX + 68.5
	redButton.y = display.contentCenterY - 69.5

	greenButton = widget.newButton
	{
		defaultFile = "greenButton.png",
		overFile = "greenButtonOver.png",
		onRelease = function() compareSongTable( 2 ) end,
		onPress = function() countReceiveSongTable = countReceiveSongTable + 1 audio.play( song2 ) fadeInOut( 2 ) end
	}
	greenButton.x = display.contentCenterX - 69.5
	greenButton.y = display.contentCenterY - 69.5
	
	blueButton = widget.newButton
	{
		defaultFile = "blueButton.png",
		overFile = "blueButtonOver.png",
		onRelease = function() compareSongTable( 3 ) end,
		onPress = function() countReceiveSongTable = countReceiveSongTable + 1 audio.play( song3 ) fadeInOut( 3 ) end
	}
	blueButton.x = display.contentCenterX - 68.5
	blueButton.y = display.contentCenterY + 68.5

	yellowButton = widget.newButton
	{
		defaultFile = "yellowButton.png",
		overFile = "yellowButtonOver.png",
		onRelease = function() compareSongTable( 4 ) end,
		onPress = function() countReceiveSongTable = countReceiveSongTable + 1 audio.play( song4 ) fadeInOut( 4 ) end
	}
	yellowButton.x = display.contentCenterX + 68.5
	yellowButton.y = display.contentCenterY + 68.5

	logoCenter = display.newImage( "logoCenter.png", display.contentCenterX + 0.5, display.contentCenterY + 0.5 )
end

-- função que compara a sequência do jogador com a sequência Correta
function compareSongTable( color )
	print( "Cor na tabela = "..tableList[countCompareSongTable] )
	print( "Cor recebida = "..color )
	if color == tableList[countCompareSongTable] then
		if countReceiveSongTable == number then 
			disableColorButtons() 
			countReceiveSongTable = 1 
			removeColorButtons()
			score = score + 1
			scoreText.isVisible = false
			gameListeners( "play2", 1200 )
		else
			removeColorButtons() 
			receiveSongTable()
		end
	else
		removeColorButtons()
		scoreText.isVisible = false
		local alert = native.showAlert( "GAME OVER", "Você errou a sequência! Score = "..score, { "MENU INICIAL" }, onTap )
	end
	countCompareSongTable = countCompareSongTable + 1
end

-- função que faz o fade de cores no background
function fadeInOut( color )
	if color == 1 then
		transition.to( backgroundRed, {alpha = 1, time = 200, onComplete = function () transition.to ( backgroundRed, { alpha = 0, time = 200 } ) end } )
	elseif color == 2 then
		transition.to( backgroundGreen, {alpha = 1, time = 200, onComplete = function () transition.to ( backgroundGreen, { alpha = 0, time = 200 } ) end } )
	elseif color == 3 then
		transition.to( backgroundBlue, {alpha = 1, time = 200, onComplete = function () transition.to ( backgroundBlue, { alpha = 0, time = 200 } ) end } )
	elseif color == 4 then
		transition.to( backgroundYellow, {alpha = 1, time = 200, onComplete = function () transition.to ( backgroundYellow, { alpha = 0, time = 200 } ) end } )
	end
end

-- função que remove os Botões
function removeColorButtons()
	display.remove( redButton ) 
	display.remove( greenButton ) 
	display.remove( blueButton ) 
	display.remove( yellowButton )
	display.remove( logoCenter )
end

-- função que desativa os Botões
function disableColorButtons()
	redButton:setEnabled( false )
	greenButton:setEnabled( false )
	blueButton:setEnabled( false )
	yellowButton:setEnabled( false )
end

-- função que exibe algumas imagens
function gameViewTrue()
	playButton.isVisible = true
	creditsButton.isVisible = true
	logoCenter.isVisible = true
	redButton.isVisible = true
	greenButton.isVisible = true
	blueButton.isVisible = true
	yellowButton.isVisible = true
	myText.isVisible = true
	interface.isVisible = false
end

-- função que esconde algumas imagens
function gameViewFalse()
	playButton.isVisible = false
	creditsButton.isVisible = false
	logoCenter.isVisible = false
	redButton.isVisible = false
	greenButton.isVisible = false
	blueButton.isVisible = false
	yellowButton.isVisible = false
	myText.isVisible = false
	interface.isVisible = false
end

Main()