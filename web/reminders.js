var app = Elm.Main.fullscreen();

function getUser(auth) {
    var isAuthorized = auth.isSignedIn.get();

    if (!isAuthorized) {
        return null;
    }

    var user = auth.currentUser.get();
    var profile = user.getBasicProfile();

    return {
        email: profile.getEmail(),
    };
}


gapi.load('client:auth2', function() {
    var SCOPE = 'https://www.googleapis.com/auth/calendar';

    gapi.client.init({
        'apiKey': 'AIzaSyAYk1JO0wu3UxAbYmeDxLclOA2psEwLQZE',
        'discoveryDocs': ["https://www.googleapis.com/discovery/v1/apis/calendar/v3/rest"],
        'clientId': '853474051422-rbvibfhir17apk19nq9vf3j8sshdo81f.apps.googleusercontent.com',
        'scope': SCOPE
    }).then(function() {
        var auth = gapi.auth2.getAuthInstance();

        // Listen for sign-in state changes.
        auth.isSignedIn.listen(function(isAuthorized) {
            var user = getUser(auth);
            app.ports.authChange.send(user)
        });

        var user = getUser(auth);
        app.ports.authChange.send(user)
    });

});
