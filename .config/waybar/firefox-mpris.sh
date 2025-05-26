# list all running players
from mpris2 import get_players_uri
print([uri for uri in get_players_uri()])
# get_players_uri can be called with filter parameter
get_players_uri('.+rhythmbox')
# you can set it yourself
uri = 'org.mpris.MediaPlayer2.gmusicbrowser'
# or use one predefined
from mpris2 import SomePlayers, Interfaces
uri = '.'.join([Interfaces.MEDIA_PLAYER, SomePlayers.GMUSICBROWSER])