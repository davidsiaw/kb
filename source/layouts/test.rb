module Keyboard
  def build_test_keyboard
    outer_row do
      key_block do
        key 'OK', '`', keyid: 'kBackquote'
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
        fkey 'Oops', length: :d, keyid: 'kBackspace'

        row_break
        dkey 'Next Enemy', length: :b, keyid: 'kTab'
        nkey 'Q', keyid: 'kKeyQ'
        nkey 'W', :'arrow-up', keyid: 'kKeyW'
        nkey 'E', 'Use', keyid: 'kKeyE'
        nkey 'R', 'reload', keyid: 'kKeyR'
        nkey 'T', keyid: 'kKeyT'
        nkey 'Y', keyid: 'kKeyY'
        nkey 'U', keyid: 'kKeyU'
        nkey 'I', keyid: 'kKeyI'
        nkey 'O', keyid: 'kKeyO'
        nkey 'P', keyid: 'kKeyP'
        nkey '{', '', keyid: 'kBracketLeft'
        nkey '}', ']', keyid: 'kBracketRight'
        nkey '|', '\\', length: :b, keyid: 'kBackslash'

        row_break
        fkey 'Raeg lock', length: :c, keyid: 'kCapsLock'
        nkey 'A', :'arrow-left', keyid: 'kKeyA'
        nkey 'S', :'arrow-down', keyid: 'kKeyS'
        nkey 'D', :'arrow-right', keyid: 'kKeyD'
        nkey 'F', 'Use', keyid: 'kKeyF'
        nkey 'G', keyid: 'kKeyG'
        nkey 'H', keyid: 'kKeyH'
        nkey 'J', keyid: 'kKeyJ'
        nkey 'K', keyid: 'kKeyK'
        nkey 'L', keyid: 'kKeyL'
        nkey ':', ';', keyid: 'kSemicolon'
        nkey '"', "'", keyid: 'kQuote'
        fkey 'kkkk', length: :e, keyid: 'kEnter'

        row_break
        fkey 'Temporary Raeg', length: :e, keyid: 'kShiftLeft'
        key 'Z', keyid: 'kKeyZ'
        key 'X', keyid: 'kKeyX'
        key 'C', keyid: 'kKeyC'
        key 'V', keyid: 'kKeyV'
        key 'B', keyid: 'kKeyB'
        key 'N', keyid: 'kKeyN'
        key 'M', keyid: 'kKeyM'
        key '<', ',', keyid: 'kComma'
        key '>', '.', keyid: 'kPeriod'
        key '?', '/', keyid: 'kSlash '
        fkey 'LShift not working', length: :f, keyid: 'kShiftRight'

        row_break
        fkey 'Crouch', length: :a, keyid: 'kControlLeft'
        dkey 'what is', 'this for', length: :a, keyid: 'kMetaLeft'
        fkey '+ F4', length: :a, keyid: 'kAltLeft'

        fkey 'JUMP!', length: :s, keyid: 'kSpace'

        fkey '???', length: :a, keyid: 'kAltRight'
        fkey :'windows', length: :a, keyid: 'kMetaRight'
        fkey :'mouse-pointer', length: :a, keyid: 'kContextMenu'
        fkey '???', length: :a, keyid: 'kControlRight'
      end
    end
  end
end
