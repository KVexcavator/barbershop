require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

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
	  	output=File.open "./public/visit.txt","a"
	    output.write "Master: #{@master}, Visiter: #{@name} ,Color : #{@color} pfone: #{@pfone}, date & time #{@data_time}<br>"
	    output.close
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
		output=File.open "./public/contacts.txt","a"
		output.write "Email: #{@message_email}<br> Text message:<br> <p>#{@message_text}<p/><br>"
		output.close
	  @message_save_contacts="Ваше сообщение отправлено "
	  erb :contacts
	end

end

post '/admin' do
	@pass_admin= params[ :pass_admin]
	if @pass_admin=="123"
		@intput_visit=File.read "./public/visit.txt"
		@intput_contacts=File.read "./public/contacts.txt"
		erb :admin	
	elsif
		@error_pass_admin="Неверный пароль, гапряги память рпидурок"
		erb :admin
	end

end