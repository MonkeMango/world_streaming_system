class_name WorldStreamer

extends Node3D

@export var chunk_radius: float = 500.0 # Radius to load chunks around the player
@export var chunk_scenes: Array[PackedScene] # Array of chunk scenes

var chunks = {}
var loaded_chunks = {}
var player: Node3D = null
var loading_thread = {}

func _ready():
	player = get_parent().get_node("Player")
	initialize_chunks()
	load_initial_chunks()

func _process(delta):
	if player:
		update_chunks()

func initialize_chunks():
	for scene in chunk_scenes:
			var instance = scene.instantiate()  
			if instance.chunk_data:
				var position = instance.chunk_data.position
				chunks[position] = scene
			else:
				print("ChunkData is not assigned to the Chunk script in:", str(scene.get_path()))

func load_initial_chunks():
	for position in chunks.keys():
		var distance_to_player = player.global_transform.origin.distance_to(position)
		if distance_to_player <= chunk_radius:
			load_chunk(position)

func update_chunks():
	if not player:
		return

	var player_position = player.global_transform.origin

	for position in chunks.keys():
		var distance_to_player = player_position.distance_to(position)
		
		if distance_to_player <= chunk_radius:
			if position not in loaded_chunks:
				load_chunk(position)
		else:
			if position in loaded_chunks:
				unload_chunk(position)

func load_chunk(position: Vector3):
	var position_str = str(position)
	if not has_node(position_str):
		var thread = Thread.new()
		loading_thread[position] = thread
		thread.start(_load_chunk_threaded.bind(position))

func _load_chunk_threaded(position: Vector3):
	var scene = chunks[position]
	call_deferred("_add_chunk", position, scene)


func _add_chunk(position: Vector3, scene):
	var position_str = str(position)
	var instance = scene.instantiate()
	add_child(instance)
	instance.global_transform.origin = position
	instance.name = position_str
	loaded_chunks[position] = instance
	
	if !loading_thread[position].is_alive():
		loading_thread[position].wait_to_finish()

func unload_chunk(position: Vector3):
	var position_str = str(position)
	if has_node(position_str):
		var chunk_node = get_node(position_str)
		if chunk_node:
			chunk_node.queue_free()
			loaded_chunks.erase(position)

