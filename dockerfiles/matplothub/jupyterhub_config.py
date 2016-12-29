# Configuration file for jupyterhub.

#------------------------------------------------------------------------------
# JupyterHub configuration
#------------------------------------------------------------------------------

# Grant admin users permission to access single-user servers.
# Users should be properly informed if this is enabled.
c.JupyterHub.admin_access = True

# Class for authenticating users.
c.JupyterHub.authenticator_class = 'jupyterhub.auth.PAMAuthenticator'

# The base URL of the entire application
c.JupyterHub.base_url = '/jupyterhub/'

# Send JupyterHub's logs to this file.
# This will *only* include the logs of the Hub itself, not the logs of the proxy
# or any single-user servers.
c.JupyterHub.extra_log_file = '/srv/jupyterhub/jupyterhub.log'

# The public facing ip of the whole application (the proxy)
# c.JupyterHub.ip = ''

# The public facing port of the proxy
# c.JupyterHub.port = 8000

# Purge and reset the database.
c.JupyterHub.reset_db = True

# Path to SSL certificate file for the public facing interface of the proxy
# Use with ssl_key
# c.JupyterHub.ssl_cert = ''

# Path to SSL key file for the public facing interface of the proxy
# Use with ssl_cert
# c.JupyterHub.ssl_key = ''

#------------------------------------------------------------------------------
# Authenticator configuration
#------------------------------------------------------------------------------

# set of usernames of admin users
# If unspecified, only the user that launches the server will be admin.
c.Authenticator.admin_users = {'shmilee'}

# Username whitelist.
# Use this to restrict which users can login. If empty, allow any user to
# attempt login.
c.Authenticator.whitelist = {'shmilee', 'test'}

# get-cmd: openssl passwd -1 -stdin
# set-cmd: echo 'username:<encrypted password>' | chpasswd -e
# use-cmd: in /usr/bin/init.sh before jupyterhub command
# PASSWORD OF USER 1000:shmilee: <$1$xlzqIibN$4ZOddd9zR0WgQxJqHjrhb1>
# PASSWORD OF USER 1001:test:    <$1$6MQLghA4$iXVidf.cX6Q.F61AhMzmm/>

#------------------------------------------------------------------------------
# LocalAuthenticator configuration
#------------------------------------------------------------------------------

# The command to use for creating users as a list of strings.
# For each element in the list, the string USERNAME will be replaced with the
# user's username. The username will also be appended as the final argument.
# For Linux, the default value is:
#     ['adduser', '-q', '--gecos', '""', '--disabled-password']
c.LocalAuthenticator.add_user_cmd = ['useradd', '-g', 'users',
        '-m', '-b', '/srv/jupyterhub', '-p', 'cHg4rr9yoE8ag']

# If a user is added that doesn't exist on the system, should I try to create
# the system user?
c.LocalAuthenticator.create_system_users = True
