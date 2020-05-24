module Keyboard
  def build_nmb_rt102_keyboard
    outer_row do
      key_block do
        dkey '半角/', '全角', keyid: 'kBackquote'
        dkey '!', '1 ぬ', keyid: 'kDigit1'
        dkey '"', '2 ふ', keyid: 'kDigit2'
        dkey '# ぁ', '3 あ', keyid: 'kDigit3'
        dkey '$ ぅ', '4 う', keyid: 'kDigit4'
        dkey '% ぇ', '5 え', keyid: 'kDigit5'
        dkey '& ぉ', '6 お', keyid: 'kDigit6'
        dkey "' ゃ", '7 や', keyid: 'kDigit7'
        dkey '( ゅ', '8 ゆ', keyid: 'kDigit8'
        dkey ') ょ', '9 よ', keyid: 'kDigit9'
        dkey '~ を', '0 わ', keyid: 'kDigit0'
        dkey '= £', '- ほ', keyid: 'kEqual'
        dkey 'ー 々', '^ へ'
        dkey '| ﹁ ', '¥ ﹂', keyid: 'kBackslash'
        nkey '', 'Back Space', keyid: 'kBackspace'

        row_break
        fkey 'Tab', length: :b, keyid: 'kTab'
        nkey 'Q ', 'た', keyid: 'kKeyQ'
        nkey 'W ', 'て', keyid: 'kKeyW'
        nkey 'E ぃ', 'い', keyid: 'kKeyE'
        'rtyuio'.split('').zip(
          'すかんなにら'.split('')
        ).each do |x, y|
          nkey x.upcase, y, keyid: "kKey#{x.upcase}"
        end
        nkey 'P 『', 'せ', keyid: 'kKeyP'
        nkey '` ￠', '@'
        nkey '{ 「', '[ °'
        fkey 'Enter', length: :l2, keyid: 'kEnter'

        row_break
        dkey 'Caps Lock', '英数', length: :c, keyid: 'kCapsLock'
        'asdfghjkl'.split('').zip(
          'ちとしはきくまのり'.split('')
        ).each do |x, y|
          nkey x.upcase, y, keyid: "kKey#{x.upcase}"
        end
        nkey '+ 』', '; れ'
        nkey '* ヶ', ': け'
        nkey '} 」', '] む'

        row_break
        fkey 'LShift', length: :d, keyid: 'kShiftLeft'
        nkey 'Z っ', 'つ', keyid: 'kComma'
        'xcvbnm'.split('').zip(
          'さそひこみも'.split('')
        ).each do |x, y|
          nkey x.upcase, y, keyid: "kKey#{x.upcase}"
        end
        nkey '< 、', ', ね', keyid: 'kComma'
        nkey '> 。', '. る', keyid: 'kPeriod'
        nkey '? ・', '/ め', keyid: 'kSlash '
        nkey '_ |', '\\ ろ', keyid: 'kSlash '
        fkey 'RShift', length: :d, keyid: 'kShiftRight'

        row_break
        fkey 'LCtrl', length: :c, keyid: 'kControlLeft'
        fkey 'LAlt', length: :b, keyid: 'kAltLeft'
        fkey '無変換', length: :b

        fkey '', length: :f, keyid: 'kSpace'

        dkey '前侯補', '変換(次侯補)', length: :c
        dkey 'カタカナ', 'ひらがな', length: :c
        fkey 'RAlt', length: :c, keyid: 'kAltRight'
        fkey 'RCtrl', length: :c, keyid: 'kControlRight'
      end
    end
  end
end
