# coding: utf-8
class Category::Task::Node::PagesController < ApplicationController
  include Cms::ReleaseFilter::Page

  public
    def generate(opts)
      opts[:task].log "#{opts[:node].url}"

      generate_node opts[:node]
    end
end