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

  it 'should fail when POSTING wrong parameters'

  it 'should fail when PATCHING to collection'

  it 'should fail when PUTTING to collection'

  it 'should fail when DELETING a collection'

  it 'should GET a specific todo'

  it 'should fail when GETTING a todo with wrong id'

  it 'should fail when POSTING a todo with todo/id format'

  it 'should fail when POSTING a todo with invalid date'

  it 'should PATCH a todo'

  it 'should fail when PATCHING a todo with wrong id'

  it 'should fail when PATCHING a todo with wrong params'

  it 'should fail when PATCHING a todo with invalid date'

  it  'should PUT a todo'

  it 'should fail when PUTTING with wrong id'

  it 'should fail when PUTTING with wrong params'

  it 'should fail when PUTTING with invalid date'

  it 'should DELETE a todo'

  it 'should fail when DELETING todo with wrong id'

  it 'should fail when id is too large'

end