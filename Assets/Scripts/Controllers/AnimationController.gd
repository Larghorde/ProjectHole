class_name AnimationController

var animationTree:AnimationTree = null

func PlayerAnimations(playerInstance:PlayerController, axis:Vector3, isRunning:bool, isGrounded:bool, isJumping:bool):
	animationTree = playerInstance.animationTree
	animationTree.set("parameters/conditions/idle", axis.x == 0 && isGrounded)
	animationTree.set("parameters/conditions/walk", !isRunning && axis.x != 0 && isGrounded)
	animationTree.set("parameters/conditions/falling", !isGrounded)
	animationTree.set("parameters/conditions/landed", isGrounded)
	animationTree.set("parameters/conditions/jump",  isJumping && isGrounded)
	animationTree.set("parameters/conditions/run",  isRunning && axis.x != 0 && isGrounded)
