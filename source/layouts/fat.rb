module Keyboard
  def build_fat_keyboard
    outer_row do
      key_block do
        key '~', '`', keyid: 'kBackquote'
        key '!', '1', keyid: 'kDigit1'
        key '@', '2', keyid: 'kDigit2'
        key '#', '3', keyid: 'kDigit3'
        key '$', '4', keyid: 'kDigit4'
        key '%', '5', keyid: 'kDigit5'
        key '^', '6', keyid: 'kDigit6'
        key '&', '7', keyid: 'kDigit7'
        key '*', '8', keyid: 'kDigit8'
        key '(', '9', keyid: 'kDigit9'
        key ')', '0', keyid: 'kDigit0'
        key '_', '-', keyid: 'kMinus'
        key '+', '=', keyid: 'kEqual'
        key '|', '\\', keyid: 'kBackslash'
        fkey 'Bksp', keyid: 'kBackspace'

        row_break
        fkey 'Tab', length: :b, keyid: 'kTab'
        'qwertyuiop'.split('').each do |x|
          key x.upcase, keyid: "kKey#{x.upcase}"
        end
        key '{', '[', keyid: 'kBracketLeft'
        key '}', ']', keyid: 'kBracketRight'

        row_break
        fkey 'Caps Lock', length: :c, keyid: 'kCapsLock'
        'asdfghjkl'.split('').each do |x|
          key x.upcase, keyid: "kKey#{x.upcase}"
        end
        key ':', ';', keyid: 'kSemicolon'
        key '"', "'", keyid: 'kQuote'
        fkey 'Enter', length: :l1, keyid: 'kEnter'

        row_break
        fkey 'LShift', length: :e, keyid: 'kShiftLeft'
        'zxcvbnm'.split('').each do |x|
          key x.upcase, keyid: "kKey#{x.upcase}"
        end
        key '<', ',', keyid: 'kComma'
        key '>', '.', keyid: 'kPeriod'
        key '?', '/', keyid: 'kSlash '
        fkey 'RShift', length: :f, keyid: 'kShiftRight'

        row_break
        fkey 'LCtrl', length: :a, keyid: 'kControlLeft'
        fkey 'LOS', length: :a, keyid: 'kMetaLeft'
        fkey 'LAlt', length: :a, keyid: 'kAltLeft'

        fkey '', length: :s, keyid: 'kSpace'

        fkey 'RAlt', length: :a, keyid: 'kAltRight'
        fkey 'ROS', length: :a, keyid: 'kMetaRight'
        fkey 'Menu', length: :a, keyid: 'kContextMenu'
        fkey 'RCtrl', length: :a, keyid: 'kControlRight'
      end
    end
  end
end
