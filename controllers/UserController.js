var db = require('../db/db.js');

loginGet = function(req, res)
{
	if (req.session.userLogged !== undefined) {
		res.redirect('/campana');
		return;
	}

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

	let isAgent = true;
	let isLider = body.lider ?? false;
	let isAdmin = body.admin ?? false;
	isLider = isLider || isAdmin;
	 
    if (session === undefined || !session.administrador){
        res.redirect('/login');
    }
	let username = body.username;
	let pass = body.pass;
	const undefinedOrEmpty = (prop) => prop == undefined || prop === '' || prop.trim().length === 0;
	try {
		if (undefinedOrEmpty(username) || undefinedOrEmpty(pass)) {
			throw "username o password vacios";
		}

		const query = 'insert into usuario(username, pass, agente, lider, administrador) values ($1, $2, $3, $4, $5)';
		await db.query(query, [username, pass, isAgent, isLider, isAdmin]);
		res.render('success');
	} catch (error) {
		res.render('error');
		console.log(error);
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