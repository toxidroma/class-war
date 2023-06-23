import SendToServer, SendOmit, SendPAS, SendPVS,
    Broadcast, Send, Start, Receive from net
import AddNetworkString from util
class
    @__inherited: (child) =>
        assert type(child.__name) == "string"
        AddNetworkString child.__name if SERVER
        Receive child.__name, child\Receive

    @Unreliable: false

    @Read: (len) =>
    @Write: (...) =>
    @Receive: (len, ply) => @Callback ply, @Read len
    @Callback: (...) =>

    @BuildMessage: (...) =>
        Start @__name, @Unreliable
        @Write ... 

    @SendToServer: (...) =>
        assert CLIENT
        @BuildMessage ...
        SendToServer!

    @Send: (ply, ...) =>
        assert SERVER
        @BuildMessage ...
        Send ply

    @SendOmit: (ply, ...) =>
        assert SERVER
        @BuildMessage ...
        SendOmit ply

    @SendPAS: (pos, ...) =>
        assert SERVER
        @BuildMessage ...
        SendPAS pos

    @SendPVS: (pos, ...) =>
        assert SERVER
        @BuildMessage ...
        SendPVS pos
    
    @Broadcast: (...) =>
        assert SERVER
        @BuildMessage ...
        Broadcast!