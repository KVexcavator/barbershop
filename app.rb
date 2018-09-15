require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require './public/pony.rb'
require 'sqlite3'

def get_db
	return SQLite3::Database.new 'bbs.sqlite'
end

#configure вызывается один раз при изменениии приложения
configure do
	db=get_db

	
	db.execute "CREATE TABLE IF NOT EXISTS 
	`visit` (
						`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
						`name`	VARCHAR,
						`pfone`	VARCHAR,
						`datestamp`	VARCHAR,
						`master`	VARCHAR,
						`color`	VARCHAR
					)"
	
	 db.execute "DROP TABLE IF EXISTS 'masters'"
	 db.execute "CREATE TABLE IF NOT EXISTS 
	 `masters` (
	 					`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	 					`name`	TEXT,
	 					`pfone`	TEXT,
	 					`addres`	TEXT
	 				);"
	 db.execute "INSERT INTO masters (name,pfone,addres) VALUES('Master','45 67 89','Green str 4')"
	 db.execute "INSERT INTO masters (name,pfone,addres) VALUES('Lenka Krivorukaya','45 67 32','Rad str 43')"
	 db.execute "INSERT INTO masters (name,pfone,addres) VALUES('Mariya Ivanobna','56 89 40','Green str 41')"
	 db.execute "INSERT INTO masters (name,pfone,addres) VALUES('Eduard Pedrilo','44 77 00','Orange str 2')"
	 db.execute "INSERT INTO masters (name,pfone,addres) VALUES('Slesar-Santehnik','55 78 89','Blue str 12')"
end

get '/' do
	erb "Hello!"			
end

get '/about' do
	erb :about			
end

get '/visit' do
	erb :visit			
end

get '/contacts' do
	erb :contacts			
end

get '/admin' do
  erb :admin
end

post '/visit' do
	@master      = params[ :master]
	@name        = params[ :name]
	@pfone       = params[ :pfone]
	@data_time   = params[ :data_time]
	@color       = params[ :color]

	#хеш сообщений об ошибке
	hh={ :name       => "Enter name",
       :pfone      => "Enter pfone",
       :data_time  => "Enter date and time",
	}

	@error=hh.select{|key,_| params[key]==''}.values.join(', ')
	if @error !=''
		return erb :visit
	end
	
	if @name !="" and @pfone!="" and @data_time!=""
			
			db=get_db
			db.execute "INSERT INTO visit (name,pfone,datestamp,master,color)
			VALUES (?,?,?,?,?)",[ @name, @pfone, @data_time, @master, @color ]

	    @message_save_visit="Уважаемый #{@name}, Ваша запись сохранена, ждём Вас #{@data_time}."
	    erb :visit
	end
end

post '/contacts' do
	@message_email = params[ :message_email]
	@message_text = params[ :message_text]

	hh={ :message_email       =>  "Enter Email",
       :message_text        =>  "Enter text",
	}

	@error=hh.select{|key,_| params[key]==''}.values.join(', ')
	if @error !=''
		return erb :contacts
	end

	if @message_email !="" and @message_text !=""
  Pony.mail(
	  :from => params[ :message_email],
	  :body => params[ :message_text],
	  :to => 'kv_fam@mail.ru',
	  :via => :smtp,
	  :via_options => { 
	  :address              => 'smtp.gmail.com', 
    :port                 => '25', 
    :enable_starttls_auto => true, 
    :user_name            => "kvronin@gmail.com", 
    :password             => 'сменил', 
    :authentication       => :plain, 
    :domain               => '127.0.0.1:4567'
    }
  )
	  @message_save_contacts="Ваше сообщение отправлено "
	  @intput_contacts= "У вас новые сообщения на электронной почте"
	  erb :contacts
	end

end

post '/admin' do
	@pass_admin= params[ :pass_admin]
	if @pass_admin=="123"
		@message_admin="<a ><a href='showinfo'>Перейти к информации</a>"
	  erb :admin
	elsif
		@message_admin="Неверный пароль, напряги память придурок"
		erb :admin
	end

end

get '/showinfo' do
	db=get_db
	db.results_as_hash=true
	@results=db.execute "SELECT * FROM visit ORDER BY id DESC"

  erb :showinfo
end