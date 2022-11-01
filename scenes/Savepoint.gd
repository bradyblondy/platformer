extends Area2D

func _ready():
	$AnimationPlayer.play("checkpoint")
	
func _process(_delta):
	if GamesStats.get_spawn() != self:
		$AnimationPlayer.play("checkpoint")
 



func _on_Savepoint_body_entered(body):
	if body.is_in_group("Player"):
		GamesStats.set_spawn(self)
		$AnimationPlayer.play("saved")
