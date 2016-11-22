describe 'lacedeamon api' do
  
  base_uri = 'http://lacedeamon.spartaglobal.com/todos'
  # delete_all hook to tear down test data
  after(:each) do delete_all end

  it 'should GET collection of todos' do
    todo1 = HTTParty.post "#{base_uri}?title=thejourneybegins1&due=21-10-2016"
    res = HTTParty.get "#{base_uri}"
    expect(res.code).to eq 200
    expect(res[0]).to be_an_instance_of Hash
    expect(res[0]['id']).not_to be_nil
    expect(res[0]['title']).not_to be_nil
  end

  it 'should POST todo' do
    todo1 = HTTParty.post "#{base_uri}?title=thejourneybeginshello&due=22-10-2016"
    res = HTTParty.get "#{base_uri}/#{todo1['id']}"
    expect(todo1.code).to eq 201
    expect(res).to be_an_instance_of Hash
    expect(res['id']).to eq todo['id']
    expect(res['title']).to eq 'thejourneybeginshello'
    expect(res['due']).to eq '2016-10-22'
    expect(res['created_at']).not_to be_nil
    expect(res['updated_at']).not_to be_nil
  end

  it 'should fail when POSTING wrong parameter names' do
    msg = 'You must provide the following parameters: <title> and <due>. You have provided: ' # WHAT
    todo1 = HTTParty.post "#{base_uri}?ttttttitle=thejourneybeginsshouldit&due=22-10-2016"
    expect(todo1.code).to eq 405
    expect(todo1.body).to eq msg
    todo2 = HTTParty.post "#{base_uri}?title=thejourneybeginsandonitgoes&dueeeeee=22-10-2016"
    expect(todo2.code).to eq 405
    expect(todo2.body).to eq msg
    todo3 = HTTParty.post "#{base_uri}"
    expect(todo3.code).to eq 405
    expect(todo3.body).to eq msg
  end

  it 'should fail when PATCHING to collection' do
    todo1 = HTTParty.post "#{base_uri}?title=thejourneybeginsyay&due=22-10-2016"
    expect(todo1.code).to eq 405
    expect(todo1.body).to eq 'Method not allowed. You cannot update the Collection.'
  end

  it 'should fail when PUTTING to collection' do
    todo1 = HTTParty.post "#{base_uri}?title=thejourneybeginshuzzah&due=22-10-2016"
    expect(todo1.code).to eq 405
    expect(todo1.body).to eq 'Method not allowed. You cannot update the Collection.'
  end

  it 'should fail when DELETING a collection' do
    todo1 = HTTParty.post "#{base_uri}?title=thejourneybeginshuzzah2&due=22-10-2016"
    expect(todo1.code).to eq 405
    expect(todo1.body).to eq 'Method not allowed. You cannot update the Collection.'
  end

  it 'should GET a specific todo' do
    todo1 = HTTParty.post "#{base_uri}?title=thejourneybeginsaidsley&due=22-10-2016"
    res = HTTParty.get "#{base_uri}/#{todo['id']}"
    expect(res.code).to eq 200
    expect(res['id']).to eq todo1['id']
    expect(res['title']).to eq 'thejourneybeginsaidsley'
    expect(res['due']).to eq '2016-10-22'
    expect(res['created_at']).not_to be_nil
    expect(res['updated_at']).not_to be_nil
  end

  it 'should fail when GETTING a todo with wrong id' do
    todo1 = HTTParty.post "#{base_uri}?title=thejourneybeginssusley&due=22-10-2016"
    HTTParty.delete "#{base_uri}/#{todo['id']}"
    res = HTTParty.get "#{base_uri}/#{todo['id']}"
    expect(res.code).to eq 404
    expect(res.body).to eq nil
  end

  it 'should fail when POSTING a todo with todo/id format' do
    todo1 = HTTParty.post "#{base_uri}/7890?title=thejourneybeginshusley&due=22-10-2106"
    expect(todo1.code).to eq 405
    expect(todo1.body).to eq 'Method not allowed. To create a new todo, POST to collection, not an item within it.'
  end

  it 'should fail when POSTING a todo with invalid date' do
    todo1 = HTTParty.post "#{base_uri}?title=thejourneybeginscomputerpeople&due=hhhhhhh"
    expect(todo1.code).to eq 400
    expect(todo1.body).to eq 'Invalid date format. Use yyyy-mm-dd.'
  end

  it 'should PATCH a todo' do
    todo1 = HTTParty.post "#{base_uri}?title=thejourneybeginsrandomstufff&due=21-10-2016"
    patch = HTTParty.patch "#{base_uri}/#{todo['id']}?title=thejourneybeginsandmorerandomstuff"
    expect(patch.code).to eq 200
    res = HTTParty.get "#{base_uri}/#{todo['id']}"
    expect(res.code).to eq 200
    expect(res['title']).to eq 'thejourneybeginsandmorerandomstuff'
    #test updated at 
  end

  it 'should fail when PATCHING a todo with wrong id' do
    todo1 = HTTParty.post "#{base_uri}?title=thejourneybeginspatching&due=21-10-2016"
    HTTParty.detete"#{base_uri}/#{todo['id']}"
    patch = HTTParty.patch "#{base_uri}/#{todo['id']}"
    expect(patch.code).to eq 404
    expect(patch.body).to eq nil
  end

  it 'should fail when PATCHING a todo with wrong params' do 
    todo1 = HTTParty.post"#{base_uri}?title=thejourneybeginsWorngParams&due=21-10-2016"
    patch = HTTParty.patch"#{base_uri}/#{todo['id']}?tittle=thejourneybeginsWorngParam&due=21-10-2016"
    expect(patch.code).to eq 422 
    expect(patch.body).to eq "You must provide the following parameters: <title> or <due> in addition to specifying the todo's <id> in the URL."
  end

  it 'should fail when PATCHING a todo with invalid date'do 
   todo1 = HTTParty.post"#{base_uri}?title=thejourneybeginsInvalidDate&due=21-10-2016"
   patch = HTTParty.patch"#{base_uri}/#{todo['id']}?title=thejourneybeginsInvalidDate&due=blablalbla"
   expect(patch.code).to eq 400 
   expect(todo1.body).to eq 'Invalid date format. Use yyyy-mm-dd'
  end

  it  'should PUT a todo'  do 
    todo1 = HTTParty.post"#{base_uri}?title=thejourneybeginsPuts&due=22-10-2016"
    put = HTTParty.put"#{base_uri}/#{todo['id']}?title=thejourneybegins3&due=21-10-2016"
    get = HTTParty.get"#{base_uri}/#{todo['id']}"
    expect(get.code).to eq 200
    expect(get[title]).to eq 'thejourneybegins3' 
    
  end
    
  end

  it 'should fail when PUTTING with wrong id ' do
    todo1 = HTTParty.post "#{base_uri}?title=thejourneybeginsWongId&due=23-10-2016"
    HTTParty.delete "#{base_uri}/#{todo['id']}"
    put = HTTParty.put"#{base_uri}/#{todo['id']}"
    expect(put.code).to eq 404
    expect(put.body).to eq nil
  end

  it 'should fail when PUTTING with wrong params' do 
    todo1 = HTTParty.post "#{base_uri}?title=thejourneybeginsmorstuff&due=23-10-2016"
    put = HTTPart.put "#{base_uri}/#{todo['id']}?tittleeeey=thejourneybeginsandmorerandomstuff&due=23-10-2016"
    expect(put.code).to eq 422
    expect(put.body).to eq "You must provide the following parameters: <title> or <due> in addition to specifying the todo's <id> in the URL."
  end

  it 'should fail when PUTTING with invalid date' do 
    todo1 = HTTParty.post "#{base_uri}?title=thejourneybegins3000&due=23-10-2016"
    put = HTTParty.put "#{base_uri}/#{todo['id']}?title=thejourneybegins3000&due=hfhgrg"
    expect(put.code).to eq 400
    expect(put.body).to eq 'Invalid date format. Use yyyy-mm-dd'
  end

  it 'should DELETE a todo' do 
    todo1 = HTTParty.post "#{base_uri}?title=thejourneybeginsonanotherlevel&due=23-10-2016"
    HTTParty.delete "#{base_uri}/#{todo['id']}"
    expect(delete.code).to eq 204
    expect(delete.body).to eq ''
  end 

  it 'should fail when DELETING todo with wrong id' do 
    todo1 = HTTParty.post "#{base_uri}?title=thejourneybegins400&due=23-10-2016"
    HTTParty.delete "#{base_uri}/#{todo]['id']}"
    HTTParty.delete "#{base_uri}/#{todo]['id']}"
    expect(delete.code).to eq 404
    expect(delete.body).to eq ''
  end

  it 'should fail when id is too large' do 
    todo1 = HTTParty.post "#{base_uri}?title=thejourneyshouldbloodybegin&due=23-10-2016"
    
  end 


end