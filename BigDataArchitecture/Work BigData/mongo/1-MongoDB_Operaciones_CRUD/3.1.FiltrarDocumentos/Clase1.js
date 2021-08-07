db.alumnos.find({nombre:"Carlos22"})

db.alumnos.find({edad:{$gt:21.0}}, {_id:0, nombre:1})

db.alumnos.find({edad:{$eq:27.0}}, {_id:0, nombre:1})