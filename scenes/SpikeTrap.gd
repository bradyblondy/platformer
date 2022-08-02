extends Area2D


func _ready():
	$AnimationPlayer.play("spikeTrigger")


func _on_SpikeTrap_body_entered(body):
	if body.is_in_group("Player"):
		print("player dead")
