describe 'lacedeamon api' do
  
  after(:all) do ApiHelper.teardown end
  #after(:all) do delete_all end

  it 'should GET collection of todos' do
    todo1 = ApiHelper.post_example
    res = ApiHelper.get_collection
    expect(res.code).to eq 200
    expect(res[0]).to be_an_instance_of Hash
    expect(res[0]['id']).not_to be_nil
    expect(res[0]['title']).not_to be_nil
  end

  it 'should POST todo' do
    todo1 = ApiHelper.post 'thejourneybeginshello', '22-10-2016'
    res = ApiHelper.get_todo todo1['id']
    expect(todo1.code).to eq 201
    expect(res).to be_an_instance_of Hash
    expect(res['id']).to eq todo1['id']
    expect(res['title']).to eq 'thejourneybeginshello'
    expect(res['due']).to eq '2016-10-22'
    expect(res['created_at']).not_to be_nil
    expect(res['updated_at']).not_to be_nil
  end

  it 'should fail when POSTING wrong parameter names' do
    msg = 'You must provide the following parameters: <title> and <due>. You have provided: ' # WHAT
    todo1 = HTTParty.post "#{ApiHelper.base_uri}?tittttttle=thejourneybeginsandonitgoes&due=22-10-2016"
    expect(todo1.code).to eq 405
    expect(todo1.body).to eq msg
    todo2 = HTTParty.post "#{ApiHelper.base_uri}?title=thejourneybeginsandonitgoes&dueeeeee=22-10-2016"
    expect(todo2.code).to eq 405
    expect(todo2.body).to eq msg
    todo3 = HTTParty.post "#{ApiHelper.base_uri}"
    expect(todo3.code).to eq 405
    expect(todo3.body).to eq msg
  end

  it 'should fail when PATCHING to collection' do
    todo1 = HTTParty.patch "#{ApiHelper.base_uri}?title=thejourneybeginsyay&due=22-10-2016"
    expect(todo1.code).to eq 405
    expect(todo1.body).to eq 'Method Not Allowed. You cannot update the Collection.'
  end

  it 'should fail when PUTTING to collection' do
    todo1 = HTTParty.put "#{ApiHelper.base_uri}?title=thejourneybeginshuzzah&due=22-10-2016"
    expect(todo1.code).to eq 405
    expect(todo1.body).to eq 'Method Not Allowed. You cannot update the Collection.'
  end

  it 'should fail when DELETING a collection' do
    todo1 = HTTParty.delete "#{ApiHelper.base_uri}"
    expect(todo1.code).to eq 405
    expect(todo1.body).to eq 'Method Not Allowed. You cannot delete the Collection.'
  end

  it 'should GET a specific todo' do
    todo1 = ApiHelper.post 'thejourneybeginsaidsley', '22-10-2016'
    res = ApiHelper.get_todo todo1['id']
    expect(res.code).to eq 200
    expect(res['id']).to eq todo1['id']
    expect(res['title']).to eq 'thejourneybeginsaidsley'
    expect(res['due']).to eq '2016-10-22'
    expect(res['created_at']).not_to be_nil
    expect(res['updated_at']).not_to be_nil
  end

  it 'should fail when GETTING a todo with wrong id' do
    todo1 = ApiHelper.post 'thejourneybeginssusley', '22-10-2016'
    ApiHelper.delete todo1['id']
    res = ApiHelper.get_todo todo1['id']
    expect(res.code).to eq 404
    expect(res.body).to eq ''
  end

  it 'should fail when POSTING a todo with todo/id format' do
    todo1 = HTTParty.post "#{ApiHelper.base_uri}/7890?title=thejourneybeginshusley&due=22-10-2106"
    expect(todo1.code).to eq 405
    expect(todo1.body).to eq 'Method Not Allowed. To create a new todo, POST to the collection, not an item within it.'
    # Tear down
    ApiHelper.delete todo1['id']
  end

  it 'should fail when POSTING a todo with invalid date' do
    todo1 = ApiHelper.post 'thejourneybegins', 'hhhhhhh'
    expect(todo1.code).to eq 400
    expect(todo1.body).to eq 'Invalid date format. Use yyyy-mm-dd.'
  end

  it 'should PATCH a todo' do
    todo1 = ApiHelper.post 'thejourneybeginsrandomstuff', '21-10-2016'
    patch = ApiHelper.patch todo1['id'], 'thejourneybeginsandmorerandomstuff', '22-10-2016'
    expect(patch.code).to eq 200
    res = ApiHelper.get_todo todo1['id']
    expect(res.code).to eq 200
    expect(res['title']).to eq 'thejourneybeginsandmorerandomstuff'
    expect(res['due']).to eq '2016-10-21'
    expect(DateTime.parse(res['updated_at'])).to be > DateTime.parse(todo1['updated_at'])
  end

  it 'should fail when PATCHING a todo with wrong id' do
    todo1 = ApiHelper.post_example
    ApiHelper.delete todo1['id']
    patch = ApiHelper.patch todo1['id'], 'thejourneybegins', '22-10-2016'
    expect(patch.code).to eq 404
    expect(patch.body).to eq ''
  end

  it 'should fail when PATCHING a todo with wrong params' do
    todo1 = ApiHelper.post_example
    patch = HTTParty.patch "#{ApiHelper.base_uri}#{todo1['id']}?tittle=thejourneybeginsWorngParam&dudde=21-10-2016"
    expect(patch.code).to eq 422 
    expect(patch.body).to eq "You must provide the following parameters: <title> or <due> in addition to specifying the todo's <id> in the URL."
  end

  it 'should fail when PATCHING a todo with invalid date'do 
    todo1 = ApiHelper.post_example
    patch = ApiHelper.patch todo1['id'], 'thejourneybegins', 'blablablabla'
    expect(patch.code).to eq 400 
    expect(patch.body).to eq 'Invalid date format. Use yyyy-mm-dd'
  end

  it 'should PUT a todo' do
    todo1 = ApiHelper.post_example
    put = ApiHelper.put todo1['id'], 'thejourneybeginsgood', '25-12-2016'
    res = ApiHelper.get_todo todo1['id']
    expect(res.code).to eq 200
    expect(res['title']).to eq 'thejourneybeginsgood' 
    expect(res['due']).to eq '2016-12-25'
    expect(DateTime.parse res['updated_at']).to be > DateTime.parse(todo1['updated_at'])
  end

  it 'should fail when PUTTING with wrong id ' do
    todo1 = ApiHelper.post_example
    ApiHelper.delete todo1['id']
    put = ApiHelper.put todo1['id'], 'thejourneybegins12', '26-10-2016'
    expect(put.code).to eq 404
    expect(put.body).to eq ''
  end

  it 'should fail when PUTTING with wrong params' do 
    todo1 = ApiHelper.post_example
    put = HTTParty.put "#{ApiHelper.base_uri}#{todo1['id']}?tittleeeey=thejourneybeginsandmorerandomstuff&due=23-10-2016"
    expect(put.code).to eq 422
    expect(put.body).to eq "You must provide the following parameters: <title> and <due> in addition to specifying the todo's <id> in the URL."
  end

  it 'should fail when PUTTING with invalid date' do 
    todo1 = ApiHelper.post_example
    put = ApiHelper.put todo1['id'], 'thejourneybegins3000', 'hsdfhaosd'
    expect(put.code).to eq 400
    expect(put.body).to eq 'Invalid date format. Use yyyy-mm-dd'
  end

  it 'should DELETE a todo' do 
    todo1 = ApiHelper.post_example
    del = ApiHelper.delete todo1['id']
    expect(del.code).to eq 204
    expect(del.body).to eq nil
  end 

  it 'should fail when DELETING todo with wrong id' do 
    todo1 = ApiHelper.post_example
    ApiHelper.delete todo1['id']
    del = ApiHelper.delete todo1['id']
    expect(del.code).to eq 404
    expect(del.body).to eq ''
  end

  it 'should fail get request when id is too large' do 
    res = ApiHelper.get_todo 9999999999999
    expect(res.code).to eq 400
    expect(res.body).to eq 'id value out of range.'
  end 

end