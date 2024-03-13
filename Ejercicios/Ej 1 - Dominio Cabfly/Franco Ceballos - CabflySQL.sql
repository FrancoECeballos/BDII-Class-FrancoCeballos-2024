DROP DATABASE IF EXISTS base_cabfly;

CREATE DATABASE base_cabfly;

USE base_cabfly;

CREATE TABLE IF NOT EXISTS TipoDocumento (
	IDTipoDocumento INT NOT NULL,
    nombreTipoDocumento VARCHAR(100) NOT NULL,
    descripcionTipoDocumento VARCHAR(400),
	primary key (IDTipoDocumento)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Tarjeta (
	numeroTarjeta INT NOT NULL,
    CVV INT NOT NULL,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    telefono VARCHAR(12),
    fechaVencimiento DATETIME NOT NULL,
	primary key (numeroTarjeta)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Pasajero (
	numeroDocumentoPasajero INT NOT NULL,
    TipoDocumento_IDTipoDocumento INT NOT NULL,
    Tarjeta_numeroTarjeta INT NOT NULL,
    nombrePasajero VARCHAR(50),
    apellidoPasajero VARCHAR(50),
    telefono VARCHAR(12),
    email VARCHAR(20),
	primary key (numeroDocumentoPasajero),
    constraint fkPasajero_TipoDocumento
    FOREIGN KEY(TipoDocumento_IDTipoDocumento)
    references TipoDocumento(IDTipoDocumento),
    constraint fkPasajero_Tarjeta
    FOREIGN KEY(Tarjeta_numeroTarjeta)
    references Tarjeta(numeroTarjeta)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Ciudad (
	IDCiudad INT NOT NULL,
    nombreCiudad VARCHAR(100) NOT NULL,
    descripcionCiudad VARCHAR(400),
	primary key (IDCiudad)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Aeronave (
	numeroAeronave VARCHAR(50) NOT NULL,
    modelo VARCHAR(100) NOT NULL,
	primary key (numeroAeronave)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Puerta (
	IDPuerta INT NOT NULL,
    ubicacionPuerta VARCHAR(100) NOT NULL,
    descripcionPuerta VARCHAR(400),
	primary key (IDPuerta)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS ServicioComida (
	IDServicioComida INT NOT NULL,
    nombreServicioComida VARCHAR(100),
    descripcionServicioComida VARCHAR(400),
	primary key (IDServicioComida)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS EstadoAsiento (
	IDEstadoAsiento INT NOT NULL,
    nombreEstadoAsiento VARCHAR(100),
    descripcionEstadoAsiento VARCHAR(400),
	primary key (IDEstadoAsiento)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS TipoAsiento (
	IDTipoAsiento INT NOT NULL,
    descripcionTipoAsiento VARCHAR(400),
	precio FLOAT NOT NULL,
	primary key (IDTipoAsiento)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Asiento (
	IDAsiento INT NOT NULL,
    ubicacionAsiento VARCHAR(400),
    EstadoAsiento_IDEstadoAsiento INT NOT NULL,
    TipoAsiento_IDTipoAsiento INT NOT NULL,
    constraint fkAsiento_EstadoAsiento
    FOREIGN KEY(EstadoAsiento_IDEstadoAsiento)
    references EstadoAsiento(IDEstadoAsiento),
    constraint fkVuelo_TipoAsiento
    FOREIGN KEY(TipoAsiento_IDTipoAsiento)
    references TipoAsiento(IDTipoAsiento),
	primary key (IDAsiento)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Vuelo (
	numeroVuelo INT NOT NULL,
    nombreCompania VARCHAR(20),
    Ciudad_ciudadSalida INT NOT NULL,
    Ciudad_ciudadLlegada INT NOT NULL,
    fechaYHoraSalida DATETIME,
	fechaYHoraEntrada DATETIME,
    Aeronave_numeroAeronave VARCHAR(50) NOT NULL,
	distancia FLOAT(50) NOT NULL,
    ServicioComida_IDServicioComida INT NOT NULL,
    Puerta_IDPuerta INT NOT NULL,
    constraint fkVuelo_Ciudad
    FOREIGN KEY(Ciudad_ciudadSalida)
    references Ciudad(IDCiudad),
    FOREIGN KEY(Ciudad_ciudadLlegada)
    references Ciudad(IDCiudad),
    constraint fkVuelo_Aeronave
    FOREIGN KEY(Aeronave_numeroAeronave)
    references Aeronave(numeroAeronave),
    constraint fkVuelo_ServicioComida
    FOREIGN KEY(ServicioComida_IDServicioComida)
    references ServicioComida(IDServicioComida),
    constraint fkReserva_Puerta
    FOREIGN KEY(Puerta_IDPuerta)
    references Puerta(IDPuerta),
	primary key (numeroVuelo)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Reserva (
	codReserva INT NOT NULL,
    Vuelo_numeroVuelo INT NOT NULL,
    Pasajero_numeroDocumentoPasajero INT NOT NULL,
    Asiento_IDAsiento INT NOT NULL,
    fechaYHoraReserva DATETIME,
	numeroTarjeta FLOAT(50) NOT NULL,
    constraint fkReserva_Asiento
    FOREIGN KEY(Asiento_IDAsiento)
    references Asiento(IDAsiento),
    constraint fkReserva_Vuelo
    FOREIGN KEY(Vuelo_numeroVuelo)
    references Vuelo(numeroVuelo),
    constraint fkReserva_Pasajero
    FOREIGN KEY(Pasajero_numeroDocumentoPasajero)
    references Pasajero(numeroDocumentoPasajero),
	primary key (codReserva)
)ENGINE=INNODB;