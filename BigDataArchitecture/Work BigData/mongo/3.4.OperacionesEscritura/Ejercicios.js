datos = cat("importDatos.json")

datos = JSON.parse(datos)

db.ejercicioGimnasio.find({
    idCliente:{$in:datos.ids}
})

db.tareas.insert({tarea: "Reunion 2", fecha:ISODate("2016-11-18T10:30:00.000Z")})

db.tareas.findAndModify({
    sort:{fecha:1},
    remove:true
})

db.tareas.find()

