db.gimnasioescritura.find()

db.gimnasioescritura.find({idCliente:1})

db.gimnasioescritura.update({idCliente:1},
{$set: {fechaAlta:new Date(), preferencias:["Tenis"]}})

db.gimnasioescritura.update({idCliente:1},
{$set: {nuevoCampo:"Nuevo Campo"}})

db.gimnasioescritura.update(
	{idCliente:1},
	{$push : {preferencias : "Padel"} }
)
        
db.gimnasioescritura.update({idCliente:1},
{$set: {estado:"Activo"}})

db.gimnasioescritura.update(
	{idCliente:1},
	{$push : {preferencias : "Padel"},
         $set: {situacion:'Activo2' }}
)
         
db.gimnasioescritura.update(
	{idCliente:1},
	{$pop : {preferencias : 1} }
)
        
db.gimnasioescritura.find({idCliente:1})

db.gimnasioescritura.update(
	{idCliente:1},
	{$push : 
		{preferencias : 
			{$each : ["Aquagym","Natación"]} 
		}
	}
)