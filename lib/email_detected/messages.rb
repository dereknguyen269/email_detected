module EmailDetected
  MESSAGES = {
    -1 =>  'Validation failed (non-SMTP)',
    250 => 'Requested mail action okay, completed',
    251 => 'User not local; will forward to <forward-path>',
    550 => 'Requested action not taken:, mailbox unavailable',
    551 => 'User not local; please try <forward-path>',
    552 => 'Requested mail action aborted:, exceeded storage allocation',
    553 => 'Requested action not taken:, mailbox name not allowed',
    450 => 'Requested mail action not taken:, mailbox unavailable',
    451 => 'Requested action aborted:, local error in processing',
    452 => 'Requested action not taken:, insufficient system storage',
    500 => 'Syntax error, command unrecognised',
    501 => 'Syntax error in parameters or arguments',
    503 => 'Bad sequence of commands',
    521 => '<domain> does not accept mail [rfc1846]',
    421 => '<domain> Service not available, closing transmission channel'
  }
end
