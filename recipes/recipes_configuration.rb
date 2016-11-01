# node.override[:xvfb][:display] = 99
node.override[:locale][:lang] = 'en_US.UTF-8'
node.override[:tz] = 'Europe/Moscow'

node.override[:authorization][:sudo] = {
  users: [:root],
  groups: ['sudo', 'devops', 'deploy'],
  passwordless: true,
  include_sudoers_d: true
}
