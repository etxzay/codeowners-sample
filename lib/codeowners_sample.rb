require 'octokit'

class CodeownersSample

  attr_reader :client

  def initialize
    @client = Octokit::Client.new(access_token: token)
    @client.auto_paginate = true
  end

  def call
    prs = repos.map do |repo|
      pull_requests(repo)
    end.flatten

    prs.each do |pr|
      puts "git fetch #{pr[:base][:repo][:ssh_url]} #{pr[:merge_commit_sha]}"
    end
    nil
  end

  def repos(company = 'toptal')
    client.org_repos(company)
  end

  def pull_requests(repo)
    client.pull_requests(repo[:id])
  end

  private

  def token
    ENV['GITHUB_TOKEN']
  end

end
