var db = require('../db/db.js');

loginGet = function(req, res)
{
	res.render('login', {error:false});
};

loginPost = async function(req, res)
{
	let body = req.body;
	const query = 'select * from usuario where username=$1 and pass=$2';
	let dbres = await db.query(query, [body.username, body.pass]);
	if (dbres.rows.length > 0) 
	{
		req.session.userLogged = dbres.rows[0];
		res.redirect('/campana');
	}else
	{
		res.render('login', {error:true});
	}
};

logout = function(req, res)
{
	req.session.destroy();
    res.redirect('login');
};

createGet = async function(req, res)
{
	let session = req.session.userLogged;
    if (session && session.administrador){
		res.render('user/create');
	}else{
        res.redirect('/login');
    }
};

createPost = async function(req, res)
{
	let body = req.body;
	let session = req.session.userLogged;
	let roles = 
	{
		agente: true,
		admin: body.admin 
	}
	roles.lider = body.lider || body.admin;
	 
    if (session && session.administrador){
		const query = 'insert into usuario(username, pass, agente, lider, administrador) values ($1, $2, $3, $4, $5)';
		let dbres = await db.query(query, [body.username, body.pass, roles.agente, roles.lider, roles.admin]);
        res.send('<div><p>Creacion exitosa</p><a href=\"/campana\">volver</a></div>');
	}else{
        res.redirect('/login');
    }
};

findAll = async function(req, res)
{
	let session = req.session.userLogged;
    if (session && session.administrador){
		const query = 'select * from usuario order by idusuario';
		let dbres = await db.query(query);
		res.render('user/index', {users:dbres.rows, isAdmin:session.administrador});
	}else{
        res.redirect('/login');
    }
};

module.exports = 
{
	loginGet,
	loginPost,
	logout,
	createGet,
	createPost,
	findAll
}; 