db.getCollection('puntuaciones3').find({})

db.puntuaciones3.update(
	{idEstudiante:1},
	{
		$push : 
		{
			puntuaciones : {
				$each : [],
				$sort : { puntuacion : 1}
			} 
		}
	}
)
        
db.gimnasioescritura.find()
        
db.gimnasioescritura.update(
	{idCliente:3},
	{
		$push : 
		{
			preferencias : {
				$each : ["Natación","Futbol"],
				$position : 1 ,
				$slice : 3 ,
				$sort : 1 
			} 
		}
	}
)
        
db.gimnasioescritura.find({preferencias : "Spinning"},{idCliente:1,_id:0})

db.gimnasioescritura.update(
	{idCliente:18, preferencias : "Spinning" },
        {$set:{"preferencias.$":"Bicicleta Estatica"}}
)
        
db.gimnasioescritura.find({idCliente : 18})
        
db.gimnasioescritura.update(
	{idCliente:6, preferencias : "Spinning" }, 
	{$set: 
		{"preferencias.$" : "Bicicleta estática"}<!--primera ocurrencia que cumpla la condicion -->
	}
)
        
db.ejercicioGimnasio.find()
        
//126
db.gimnasioescritura.find({preferencias : "Carrera en cinta"}).count()

db.gimnasioescritura.find({preferencias : ["Spinning", "Elíptica"]})

