require_relative 'spec_helper'
require_relative '../lib/gitlab_snippets'

describe GitlabSnippets do
  describe :initialize do
    before do
      argv('add-snippet', '3.git')
      @gl_snippets = GitlabSnippets.new
    end

    it { @gl_snippets.snippet_name.should == '3.git' }
    it { @gl_snippets.instance_variable_get(:@command).should == 'add-snippet' }
    it { @gl_snippets.instance_variable_get(:@full_path).should == '/home/git/snippets/3.git' }
  end

  describe :add_snippet do
    before do
      argv('add-snippet', '3.git')
      @gl_snippets = GitlabSnippets.new
      @gl_snippets.stub(full_path: tmp_repo_path)
    end

    after do
      FileUtils.rm_rf(tmp_repo_path)
    end

    it "should create a directory" do
      @gl_snippets.stub(system: true)
      @gl_snippets.send :add_snippet
      File.exists?(tmp_repo_path).should be_true
    end

    it "should receive valid cmd" do
      valid_cmd = "cd #{tmp_repo_path} && git init"
      @gl_snippets.should_receive(:system).with(valid_cmd)
      @gl_snippets.send :add_snippet
    end
  end

  def argv(*args)
    args.each_with_index do |arg, i|
      ARGV[i] = arg
    end
  end

  def tmp_repo_path
    File.join(ROOT_PATH, 'tmp', '3.git')
  end
end
