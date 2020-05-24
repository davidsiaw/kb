# frozen_string_literal: true

Dir['source/layouts/*.rb'].each do |x|
  load("./#{x}")
end

module Keyboard
  def key(name, second = '', type: nil, length: nil, keyid: nil)
    lenclass = lenclass_for(length)
    classes = ['white', type, 'key', lenclass, keyid]
    element_opts = { class: classes.compact.join(' ') }
    khclass = 'keyholder'
    khclass = 'first-key' if @row_break
    @row_break = false
    div class: khclass do
      if type == :function
        a element_opts do
          div class: :keycap do
            extend Keyboard
            symbol name
            symbol second, class: :side
          end
        end
      elsif type == :control
        a element_opts do
          div class: :keycap do
            extend Keyboard
            symbol name
            br
            symbol second
          end
        end
      elsif type == :numpad
        a element_opts do
          div class: :keycap do
            div class: :numpad_label do
              extend Keyboard
              symbol name, class: :numpad_main_label
              symbol second, class: :numpad_sub_label
            end
          end
        end
      elsif type == :doublecram
        a element_opts do
          div class: :keycap do
            div class: :numpad_label do
              extend Keyboard
              symbol name, class: :cram_main_label
              symbol second, class: :cram_sub_label
            end
          end
        end
      else
        a element_opts do
          div class: :keycap do
            extend Keyboard
            symbol name
            br
            symbol second
          end
        end
      end
    end
  end

  def symbol(*args)
    return icon(args[0]) if args[0].is_a? Symbol

    span(*args)
  end

  def fkey(name, second = '', length: nil, keyid: nil)
    key(name, second, type: :function, length: length, keyid: keyid)
  end

  def ckey(name, second = '', length: nil, keyid: nil)
    key(name, second, type: :control, length: length, keyid: keyid)
  end

  def nkey(name, second = '', length: nil, keyid: nil)
    key(name, second, type: :numpad, length: length, keyid: keyid)
  end

  def dkey(name, second = '', length: nil, keyid: nil)
    key(name, second, type: :doublecram, length: length, keyid: keyid)
  end

  def lenclass_for(length)
    return nil if length.nil?

    "#{length}type"
  end

  def key_block(style: '', &block)
    div class: :key_area, style: style do
      extend Keyboard
      instance_eval(&block)
    end
  end

  def sizes
    {
      one: '56',
      half: '26',
      quarter: '14',
      eighth: '8'
    }
  end

  def spacer(size)
    len = sizes[size]
    div class: :spacer, style: "width: #{len}px" do
    end
  end

  def keyboard_panel(&block)
    div class: :keyboard do
      extend Keyboard
      instance_eval(&block)
    end
  end

  def outer_row(&block)
    @rows ||= 0
    @rows += 1
    if @rows > 1
      div class: :row_space do
      end
    end
    div class: :keyboard_row do
      extend Keyboard
      instance_eval(&block)
    end
  end

  def row_break
    @row_break = true
    div class: :inner_row do
    end
  end

  def outer_column(align_bot: false, &block)
    opts = { class: :column_space }
    if align_bot
      opts[:style] = 'vertical-align: bottom'
    end
    div opts do
      extend Keyboard
      instance_eval(&block)
    end
  end

  def respond_to_keys!
    script <<~SCRIPT
      window.addEventListener("keydown", e => {
        e.preventDefault();
        var keycode = "k" + e.code;
        var elements = document.getElementsByClassName(keycode);
        for(var i=0; i<elements.length; i++) {
          elements[i].classList.add('active');
        }
      });

      window.addEventListener("keyup", e => {
        e.preventDefault();
        var keycode = "k" + e.code;
        var elements = document.getElementsByClassName(keycode);
        for(var i=0; i<elements.length; i++) {
          elements[i].classList.remove('active');
        }
      });
    SCRIPT
  end

  def build_function_keys
    outer_row do
      key_block do
        fkey 'Esc', keyid: 'kEscape'
      end
      spacer :one
      key_block do
        fkey 'F1', keyid: 'kF1'
        fkey 'F2', keyid: 'kF2'
        fkey 'F3', keyid: 'kF3'
        fkey 'F4', keyid: 'kF4'
      end
      spacer :half
      key_block do
        fkey 'F5', keyid: 'kF5'
        fkey 'F6', keyid: 'kF6'
        fkey 'F7', keyid: 'kF7'
        fkey 'F8', keyid: 'kF8'
      end
      spacer :half
      key_block do
        fkey 'F9', keyid: 'kF9'
        fkey 'F10', keyid: 'kF10'
        fkey 'F11', keyid: 'kF11'
        fkey 'F12', keyid: 'kF12'
      end
    end
  end

  def build_navigation_keys(top_row)
    outer_column do
      if top_row
        outer_row do
          key_block style: 'position: relative; left:13px;' do
            ckey 'Print', 'Scrn', keyid: 'kControlRight'
            ckey 'Scroll', 'Lock', keyid: 'kScrollLock'
            ckey 'Pause', 'Break', keyid: 'kPause'
          end
        end
      end

      outer_row do
        key_block style: 'position: relative; left:13px;' do
          ckey 'Insert', keyid: 'kInsert'
          ckey 'Home', keyid: 'kHome'
          ckey 'Page', 'Up', keyid: 'kPageUp'
          row_break
          ckey 'Delete', keyid: 'kDelete'
          ckey 'End', keyid: 'kEnd'
          ckey 'Page', 'Down', keyid: 'kPageDown'
        end
        spacer :quarter
      end

      outer_row do
        key_block style: 'position: relative; top:31px; left:73px;' do
          key :'long-arrow-up', keyid: 'kArrowUp'
        end
        row_break
        key_block style: 'position: relative; top:22px; left:13px;' do
          key :'long-arrow-left', keyid: 'kArrowLeft'
          key :'long-arrow-down', keyid: 'kArrowDown'
          key :'long-arrow-right', keyid: 'kArrowRight'
        end
      end
      outer_row do
      end
    end
  end

  def build_numpad_keys
    outer_column align_bot: true do
      outer_row do
        key_block style: 'position: relative; left:12px;' do
          ckey 'Num', 'Lock', keyid: 'kNumLock'
          nkey '/', keyid: 'kNumpadDivide'
          nkey '*', keyid: 'kNumpadMultiply'
          row_break
          nkey '7', 'Home', keyid: 'kNumpad7'
          nkey '8', '↑', keyid: 'kNumpad8'
          nkey '9', 'PgUp', keyid: 'kNumpad9'
          row_break
          nkey '4', '←', keyid: 'kNumpad4'
          nkey '5', keyid: 'kNumpad5'
          nkey '6', '→', keyid: 'kNumpad6'
          row_break
          nkey '1', 'End', keyid: 'kNumpad1'
          nkey '2', '↓', keyid: 'kNumpad2'
          nkey '3', 'PgDn', keyid: 'kNumpad3'
          row_break
          nkey '0', 'Ins', length: :d, keyid: 'kNumpad0'
          nkey '.', 'Del', keyid: 'kNumpadDecimal'
        end
      end
    end

    outer_column align_bot: true do
      outer_row do
        text ''
        key_block style: 'position: relative; left:8px' do
          key '-', keyid: 'kNumpadSubtract'
          row_break
          nkey '+', length: :b1, keyid: 'kNumpadAdd'
          row_break
          nkey '', 'Enter', length: :b1, keyid: 'kNumpadEnter'
        end
        spacer :eighth
      end
    end
  end

  def keyboard(type, options = {})
    func_keys = options[:func_keys].nil? ? true : options[:func_keys]
    nav_keys = options[:nav_keys].nil? ? true : options[:nav_keys]
    ten_keys = options[:ten_keys].nil? ? true : options[:ten_keys]

    keyboard_panel do
      outer_column do
        build_function_keys if func_keys == true
        ktype = :"build_#{type}_keyboard"
        if self.respond_to?(ktype)
          self.send(ktype)
        end
      end

      build_navigation_keys(func_keys) if nav_keys == true
      build_numpad_keys if ten_keys == true
    end
  end
end



