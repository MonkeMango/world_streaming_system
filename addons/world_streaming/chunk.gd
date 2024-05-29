class_name Chunk

extends Node3D

@export var chunk_data : ChunkData
var loading_thread : Thread = Thread.new()
var loaded_assets : Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready():
	if chunk_data.assets_to_stream != null:
		loading_thread.start(load_assets)


# Loads chunk assets via threads
func load_assets() -> void:
	for scenes in chunk_data.assets_to_stream:
		if scenes != null:
			call_deferred("add_assets", scenes)
		else:
			print("damn...")

func add_assets(scene) -> void:
	var instance = scene.instantiate()
	if instance:
		loaded_assets.append(instance)
		call_deferred("check_loaded_assets")

func check_loaded_assets() -> void:
	for asset in loaded_assets:
		if !asset.is_inside_tree():
			add_child(asset)
		else:
			print("already added")
	

func _exit_tree():
	loading_thread.wait_to_finish()
