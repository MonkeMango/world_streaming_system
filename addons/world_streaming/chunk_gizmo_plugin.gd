class_name ChunkGizmo
extends EditorNode3DGizmoPlugin

func _init():
	set_name("ChunkGizmoPlugin")

func has_gizmo(spatial):
	return spatial is WorldStreamer

func create_gizmo(spatial):
	var gizmo = EditorNode3DGizmo.new()
	gizmo.set_spatial_node(spatial)

	var chunk_manager = spatial as WorldStreamer
	for scene in chunk_manager.chunk_scenes:
		if scene:
			var instance = scene.instance()
			if instance:
				instance.set_visible_in_tree(false)
				var parent_transform = instance.global_transform
				var mesh_instances = find_mesh_instances(instance)
				for mesh_instance in mesh_instances:
					var mesh = mesh_instance.mesh
					if mesh:
						var material = StandardMaterial3D.new()
						material.albedo_color = Color(1, 1, 1, 0.5) # Grayed-out color
						var mesh_gizmo = BoxMesh.new()
						mesh_gizmo.set_mesh(mesh)
						mesh_gizmo.set_material(material)
						mesh_gizmo.set_parent(gizmo)
						mesh_gizmo.set_global_transform(parent_transform * mesh_instance.global_transform)
				
				instance.queue_free()

	return gizmo

func find_mesh_instances(node):
	var mesh_instances = []

	if node is CSGBox3D:
		mesh_instances.append(node)

	for child in node.get_children():
		var child_mesh_instances = find_mesh_instances(child)
		mesh_instances.extend(child_mesh_instances)

	return mesh_instances
