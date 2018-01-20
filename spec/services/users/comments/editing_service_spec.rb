require 'rails_helper'

describe Users::Comments::EditingService do
  let(:user) { create(:user) }
  let(:comment) { create(:user_comment) }
  let(:creator) { comment.created_by }
  let(:content) { 'ABCDEFGHIJKLMNOP' }

  it 'succesfully edits a comment' do
    subject.call(user, comment, content: content)

    expect(comment).to_not be_changed
    expect(comment.created_by).to eq(creator)
    expect(comment.content).to eq(content)
  end

  it 'creates comment edit history' do
    subject.call(user, comment, content: content)

    expect(comment.edits.count).to eq(1)
    edit = comment.edits.first
    expect(edit.created_by).to eq(user)
    expect(edit.content).to eq(content)
  end

  it 'handles invalid data' do
    subject.call(user, comment, content: '')

    expect(comment).to be_invalid
    expect(comment.edits).to be_empty
  end
end
