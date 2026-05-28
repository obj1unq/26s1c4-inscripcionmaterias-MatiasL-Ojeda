class Materia {
  var   property nombre
  var   property inscriptos  = #{}
  var   property listaEspera =  []
  const property requisitos  = #{}
  const cupoMaximo

  method hayCupo                   () = inscriptos.size() < cupoMaximo

  method inscribir(estudiante) {
    if (not estudiante.puedeInscribirseEn(self)) {
      self.error("No cumple condiciones de inscripción")
    }
    if (self.hayCupo()) {
      inscriptos.add(estudiante)
      estudiante.confirmarInscripcion(self)
    } else {
      listaEspera.add(estudiante)
    }
  }

  method darDeBaja(estudiante) {
    if (not inscriptos.contains(estudiante)) {
    self.error("El estudiante no está inscripto")
    }
    inscriptos.remove(estudiante)
    estudiante.cancelarInscripcion(self)
    self.promoverDesdeLista()
  }

  method promoverDesdeLista() {
    if (not (listaEspera.isEmpty())) {
      const proximo = listaEspera.first()
      listaEspera.remove(proximo)
      inscriptos.add(proximo)
      proximo.confirmarInscripcion(self)
    }
  }
}