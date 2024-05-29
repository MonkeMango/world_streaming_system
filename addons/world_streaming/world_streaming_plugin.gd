@tool
extends EditorPlugin

var gizmo : ChunkGizmo

func _enter_tree():
	var gizmo = ChunkGizmo.new()
	add_custom_type("WorldStreaming", "Node3D", preload("res://addons/world_streaming/world_streamer.gd"), preload("res://addons/world_streaming/icon.png"))
	add_node_3d_gizmo_plugin(gizmo)

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type("WorldStreaming")
	remove_node_3d_gizmo_plugin(gizmo)
