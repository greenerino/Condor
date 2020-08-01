extends KinematicBody2D

# Improvements:
# Constant vars below can use the const keyword.
# $References should be assigned to variables. This allows the reference to the node's path
#	within the code to only exist in one place. If the scene's structure changes, it makes
#	it easy to update.

var direction = Vector2()
var alive = false
var score = 0
var deaths = 0
var RISE = 1500
var MAX_RISE = 2000
var DROP = 1000
var MAX_DROP = 3000
var RUN = 400
# var DEBUG_POS = Vector2(8363, 188)
var INITIAL_POS = Vector2(350, 515)

func _ready():
	alive = false
	$CanvasLayer/PromptContainer.set_visible(true)
	$CanvasLayer/PromptContainer/CenterContainer/Label.set_text('Right click to start!')

func _input(event):
	if !alive and event.is_action_pressed('right_click'):
		start_game()

func start_game():
	set_position(INITIAL_POS)
	alive = true
	direction.x = RUN
	$CanvasLayer/PromptContainer.set_visible(false)
	$Sprite.set_visible(true)
	$SoundStart.play()

func _process(delta):
	if alive:
		score += delta * 10
		$CanvasLayer/ScoreContainer/Label.set_text('Score: ' + str(round(score)))

func _physics_process(delta):
	if !alive:
		return

	if Input.is_action_pressed('click'):
		direction.y -= RISE * delta
	else:
		direction.y += DROP * delta

	if direction.y > MAX_DROP:
		direction.y = MAX_DROP
	if direction.y < MAX_RISE * -1:
		direction.y = MAX_RISE
	rotation = direction.angle() / 1.5
	var collision = move_and_collide(direction * delta)
	if collision:
		explode()

func explode():
	alive = false
	score = 0
	deaths += 1
	direction = Vector2.ZERO
	$Sprite.set_visible(false)
	$ExplosionPlayer.set_frame(0)
	$ExplosionPlayer.play()
	$SoundExplosion.play()
	$CanvasLayer/PromptContainer.set_visible(true)
	$CanvasLayer/PromptContainer/CenterContainer/Label.set_text('Right click to retry!')
	$CanvasLayer/DeathsContainer/Label.set_text('Deaths:' + str(deaths))
