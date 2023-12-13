extends AudioStreamPlayer
class_name MusicPlayer

@export var songList : Array[AudioStreamWAV]

enum State {
	INTRO,
	LOW,
	MID,
	HIGH
}

var currentState : State
var playbackPosition : float
var beenQueued = false
var currentSong

func _ready():
	currentState = State.INTRO
	beenQueued = false

func _process(delta):
	currentSong = stream
	if currentState == State.INTRO:
		if beenQueued == false and stream != songList[3]:
			QueueChange(songList[3])
	if currentState == State.LOW:
		if beenQueued == false and stream != songList[0]:
			QueueChange(songList[0])
	if currentState == State.MID:
		if beenQueued == false and stream != songList[1]:
			QueueChange(songList[1])
	if currentState == State.HIGH:
		if beenQueued == false and stream != songList[2]:
			QueueChange(songList[2])
	
	
	playbackPosition = get_playback_position()

func introState():
	if currentState != State.INTRO:
		beenQueued = false
		currentState = State.INTRO
func lowState():
	if currentState != State.LOW:
		beenQueued = false
		currentState = State.LOW
func midState():
	if currentState != State.MID:
		beenQueued = false
		currentState = State.MID
func highState():
	if currentState != State.HIGH:
		beenQueued = false
		currentState = State.HIGH

func QueueChange(music : AudioStreamWAV):
	stream = music
	if music != songList[3]:
		var currentPos = playbackPosition
		play()
		self.seek(currentPos)
		beenQueued = true
	else:
		play()
		beenQueued = true
