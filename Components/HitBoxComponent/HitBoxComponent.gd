extends Area3D

class_name HitBox

enum type_of_hit {
	LIGHT,
	HEAVY
}

var heavy_damage := 3
var light_damage := 1

func hit(_type_of_hit:type_of_hit):
	
	if not get_overlapping_areas().is_empty():
		
		for hurt_box in get_overlapping_areas():
			if hurt_box is HurtBox:
				match _type_of_hit:
					type_of_hit.LIGHT:
						hurt_box.give_hit(light_damage)
					type_of_hit.HEAVY:
						hurt_box.give_hit(heavy_damage)

