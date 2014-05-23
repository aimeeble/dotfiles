# -*- coding: utf-8 -*-
#
# Author: Aimee (aimee@aimeeble.com)
# License: BSD

import weechat

SCRIPT_NAME = 'flip'
SCRIPT_AUTHOR = '@aimeeble'
SCRIPT_VERSION = '0.1'
SCRIPT_LICENSE = 'BSD'
SCRIPT_DESC = 'rage-flip stuff'

MAPPING = {
        'a': u'\u0250',
        'b': u'q',
        'c': u'\u0254',
        'd': u'p',
        'e': u'\u01dd',
        'f': u'\u025f',
        'g': u'\u0183',
        'h': u'\u0265',
        'i': u'\u1d09',
        'j': u'\u027e',
        'k': u'\u029e',
        'l': u'l',
        'm': u'\u026f',
        'n': u'u',
        'o': u'o',
        'p': u'd',
        'q': u'b',
        'r': u'\u0279',
        's': u's',
        't': u'\u0287',
        'u': u'n',
        'v': u'\u028c',
        'w': u'\u028d',
        'x': u'x',
        'y': u'\u028e',
        'z': u'z',

        'A': u'\u2200',
        'B': u'B',
        'C': u'\u0186',
        'D': u'D',
        'E': u'\u018e',
        'F': u'\u2132',
        'G': u'\u05e4',
        'H': u'H',
        'I': u'I',
        'J': u'\u017f',
        'K': u'K',
        'L': u'\u02e5',
        'M': u'W',
        'N': u'N',
        'O': u'O',
        'P': u'\u0500',
        'Q': u'Q',
        'R': u'R',
        'S': u'S',
        'T': u'\u2535',
        'U': u'\u2229',
        'V': u'\u039b',
        'W': u'M',
        'X': u'X',
        'Y': u'\u2144',
        'Z': u'Z',

        '0': u'0',
        '1': u'\u0196',
        '2': u'\u1105',
        '3': u'\u0190',
        '4': u'\u3123',
        '5': u'\u03db',
        '6': u'9',
        '7': u'\u3125',
        '8': u'8',
        '9': u'6',

        ',': u'`',
        '.': u'\u02d9',
        '?': u'\u00bf',
        '!': u'\u00a1',
        '`': u',',
        '(': u')',
        ')': u'(',
        '[': u']',
        ']': u'[',
        '{': u'}',
        '}': u'{',
        '<': u'>',
        '>': u'<',
        '&': u'\u214b',
        '_': u'\u203e',
    }


def flip():
    return u'(\u256f\u00b0\u25a1\u00b0)\u256f \ufe35'


def table():
    return u'\u253b\u2501\u253b'


def flip_text(text):
    output = []
    for letter in text:
        if letter in MAPPING:
            letter = MAPPING[letter]
        output.append(letter)
    output.reverse()
    return u''.join(output).strip()


def flip_hook(data, buffer, args):
    if not args:
        text = u'%s %s' % (flip(), table())
    else:
        text = u'%s %s' % (flip(), flip_text(args))
    weechat.command(buffer, text.encode('utf-8'))
    return weechat.WEECHAT_RC_OK


if __name__ == '__main__':
    weechat.register(SCRIPT_NAME,
                     SCRIPT_AUTHOR,
                     SCRIPT_VERSION,
                     SCRIPT_LICENSE,
                     SCRIPT_DESC,
                     "",
                     "")

    weechat.hook_command('flip', 'flips text',
            '[flip] <text>', '', '',
            'flip_hook', '')

    welcome = '%s %s' % (flip(), flip_text('loaded'))
    weechat.prnt('', welcome.encode('utf-8'))
