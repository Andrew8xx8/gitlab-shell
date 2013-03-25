require 'open3'
require 'fileutils'

class GitlabSnippets
  attr_reader :snippet_name, :full_path

  def initialize
    @command = ARGV.shift
    @snippet_name = ARGV.shift
    @snippets_path = GitlabConfig.new.snippets_path
    @full_path = File.join(@snippets_path, @snippet_name)
  end

  def exec
    case @command
    when 'add-snippet'; add_snippet
    when 'commit-snippet'; commit_snippet
    when 'rm-snippet';  rm_snippet
    else
      puts 'not allowed'
    end
  end

  protected

  def add_snippet
    FileUtils.mkdir_p(full_path, mode: 0770)
    cmd = "cd #{full_path} && git init" #&& #{create_hooks_cmd}"
    system(cmd)
  end

  def create_hooks_cmd
    pr_hook_path = File.join(ROOT_PATH, 'hooks', 'post-receive')
    up_hook_path = File.join(ROOT_PATH, 'hooks', 'update')

    "ln -s #{pr_hook_path} #{full_path}/hooks/post-receive && ln -s #{up_hook_path} #{full_path}/hooks/update"
  end

  def rm_snippet
    FileUtils.rm_rf(full_path)
  end
end
