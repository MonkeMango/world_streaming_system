class_name ChunkGizmo
extends EditorNode3DGizmoPlugin

func _init():
	set_name("ChunkGizmoPlugin")
	create_material("main", Color(1, 0, 0))
	create_handle_material("handles")

func has_gizmo(gizmo):
	return gizmo is WorldStreamer

func _redraw(gizmo : EditorNode3DGizmo):
	gizmo.clear()
	var scene = gizmo.get_node_3d()

	var lines = PackedVector3Array()

	lines.push_back(Vector3(0, 1, 0))
	lines.push_back(Vector3(0, scene.global_transform.origin, 0))

	var handles = PackedVector3Array()

	handles.push_back(Vector3(0, 1, 0))
	handles.push_back(Vector3(0, scene.global_transform.origin, 0))

	gizmo.add_lines(lines, get_material("main", gizmo), false)
	gizmo.add_handles(handles, get_material("handles", gizmo), [])