#!/usr/bin/env ruby
# coding: utf-8

require 'fine_ants'
require File.expand_path(File.dirname(__FILE__) + '/icbc_argentina_adapter')

accounts = FineAnts.download(IcbcArgentinaAdapter, {
  :user => ENV['MY_USERNAME'],
  :password => ENV['MY_PASSWORD']
})

puts accounts
