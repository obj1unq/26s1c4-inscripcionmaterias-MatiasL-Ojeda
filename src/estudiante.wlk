import materiaAprobada.*
import materia.*
import carrera.*

class Estudiante{
  const property nombre
  const materiasAprobadas = #{}
  const property carrerasEnCurso   = #{}
  const inscripcion       = #{}

  method aprobar(materia, nota) {
    if (self.aprobo(materia)){
      self.error("Ya esta aprobada")
    }
    materiasAprobadas.add(new MateriaAprobada(materia = materia, nota = nota))
  }

  method aprobo(materia) = materiasAprobadas.any({materias => materias.materia() == materia})

  method cantMateriasAprobadas  () = materiasAprobadas.size()

  // Si no tiene materias aprobadas, se devuelve 0; en caso contrario, se devuelve el promedio.
  method promedioNota() = if (self.cantMateriasAprobadas() == 0) 0 else 
                          materiasAprobadas.fold(0, { promedio, materiaAprobada => promedio + materiaAprobada.nota()}) 
                          / self.cantMateriasAprobadas()

  method todasLasMaterias() = carrerasEnCurso.map { carrera => carrera.materias()}.flatten().asSet()
  
  method puedeInscribirseEn(_materia) = self.todasLasMaterias().contains(_materia) && not(self.aprobo(_materia)) 
                                     && not(self.estaInscripto(_materia))          && self.cumpleRequisitos(_materia)

  method estaInscripto   (materia) = inscripcion.contains(materia)
  method cumpleRequisitos(materia) = materia.requisitos().all { req => self.aprobo(req)}
  
  // Le encargo a materia que determine si el estudiante se inscriba.
  method inscribirseEn(materia) {
    materia.inscribir(self)
  }
  method confirmarInscripcion(materia) {
    inscripcion.add(materia)
  }

  method cancelarInscripcion(materia) {
    inscripcion.remove(materia)
  }

  method materiasInscriptas     () = inscripcion
  method materiasEnListaDeEspera() = self.todasLasMaterias().filter { materia => materia.listaEspera().contains(self)}
  
  method puedeInscribirse() = self.todasLasMaterias().filter({materia => self.puedeInscribirseEn(materia)})
}