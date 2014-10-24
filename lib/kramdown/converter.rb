# -*- coding: utf-8 -*-
#
#--
# Copyright (C) 2009-2014 Thomas Leitner <t_leitner@gmx.at>
#
# This file is part of kramdown which is licensed under the MIT.
#++
#

require 'kramdown/utils'

module Kramdown

  # This module contains all available converters, i.e. classes that take a root Element and convert
  # it to a specific output format. The result is normally a string. For example, the
  # Converter::Html module converts an element tree into valid HTML.
  #
  # Converters use the Base class for common functionality (like applying a template to the output)
  # \- see its API documentation for how to create a custom converter class.
  module Converter

    autoload :Base, 'kramdown/converter/base'
    autoload :Html, 'kramdown/converter/html'
    autoload :Latex, 'kramdown/converter/latex'
    autoload :Kramdown, 'kramdown/converter/kramdown'
    autoload :Toc, 'kramdown/converter/toc'
    autoload :RemoveHtmlTags, 'kramdown/converter/remove_html_tags'
    autoload :Pdf, 'kramdown/converter/pdf'

    extend ::Kramdown::Utils::Configurable

    configurable(:syntax_highlighter)

    ["Coderay", "Rouge"].each do |klass_name|
      kn_down = klass_name.downcase.intern
      add_syntax_highlighter(kn_down) do |converter, text, lang, type, opts|
        require "kramdown/converter/syntax_highlighter/#{kn_down}"
        klass = ::Kramdown::Utils.deep_const_get("::Kramdown::Converter::SyntaxHighlighter::#{klass_name}")
        if klass::AVAILABLE
          add_syntax_highlighter(kn_down, klass)
        else
          add_syntax_highlighter(kn_down) {|*args| nil}
        end
        syntax_highlighter(kn_down).call(converter, text, lang, type, opts)
      end
    end

  end

end
