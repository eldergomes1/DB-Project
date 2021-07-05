create type productType as enum ('bien', 'servicio');
	
create table usuario(
	idusuario serial primary key,
	username varchar(255) not null,
	pass varchar(255) not null,
	agente boolean not null,
	lider boolean not null,
	administrador boolean not null
);

create table campana(
	idcampana serial primary key,
	nombre varchar(255) not null,
	lider integer not null,
	objetivo decimal(11, 2) not null default 0,
	recaudado decimal(11, 2) not null default 0,
	foreign key (lider) references usuario(idusuario) 
);

create table equipo(
	idcampana integer not null,
	idusuario integer not null,
	primary key(idcampana, idusuario),
	foreign key (idcampana) references campana(idcampana),
	foreign key (idusuario) references usuario(idusuario) 
);

create table producto(
	idproducto serial primary key,
	titulo varchar(255) not null,
	idcampana integer not null,
	costo decimal(11, 2) not null,
	tipo productType not null,
	foreign key (idcampana) references campana(idcampana) 
);

create table orden(
	idorden serial primary key,
	idcampana integer not null,
	idusuario integer not null,
	foreign key (idcampana) references campana(idcampana), 
	foreign key (idusuario) references usuario(idusuario)
);

create table venta(
	idventa serial primary key,
	idorden integer not null,
	unidades integer not null,
	titulo varchar(255) not null,
	costo decimal(11, 2) not null,
	foreign key (idorden) references orden(idorden)
);

create table donacion(
	iddonacion serial primary key,
	idorden integer not null,
	monto decimal(11, 2) not null,
	foreign key (idorden) references orden(idorden)
);

insert into usuario(username, pass, agente, lider, administrador) 
values ('admin', 'admin', true, true, true);