var app = Elm.Main.fullscreen();

// Listen for request user requests from elm
app.ports.requestUser.subscribe(function() {
    gapi.load('client:auth2', gapiInit);
});

// Listen for reminder list requests from elm
app.ports.requestReminders.subscribe(function() {
    requestReminders();
});

// Listen for parse query requests from elm
app.ports.parseQuery.subscribe(function(query) {
    var draft = parseQuery(query);
    app.ports.draft.send(draft);
});

// Listen for create reminder requests from elm
app.ports.createReminder.subscribe(function(draft) {
    createReminder(draft);
});


function gapiInit() {
    gapi.client.init({
        'apiKey': 'AIzaSyAYk1JO0wu3UxAbYmeDxLclOA2psEwLQZE',
        'discoveryDocs': ["https://www.googleapis.com/discovery/v1/apis/calendar/v3/rest"],
        'clientId': '853474051422-rbvibfhir17apk19nq9vf3j8sshdo81f.apps.googleusercontent.com',
        'scope': 'https://www.googleapis.com/auth/calendar',
    }).then(function() {
        var auth = gapi.auth2.getAuthInstance();

        // Listen for sign in events from elm
        app.ports.signIn.subscribe(function() {
            auth.signIn();
        });

        // Listen for sign out events from elm
        app.ports.signOut.subscribe(function() {
            auth.signOut();
        });

        // Listen for sign-in state changes and send to elm
        auth.isSignedIn.listen(function() {
            sendUser(auth);
        });

        // Send initial user to elm
        sendUser(auth);
    });

}

function requestReminders() {
    var now = new Date();

    var req = gapi.client.calendar.events.list({
        calendarId: "primary",
        maxResults: 250,
        timeMin: now.toISOString(),
        orderBy: "startTime",
        singleEvents: true,
        privateExtendedProperty: "isReminder=true"
    });

    // TODO: check response code
    req.execute(function(res) {
        if (res.items) {
            var items = res.items.map(formatReminder);
            app.ports.reminders.send(items);
        }
    });
}

function formatReminder(item) {
    var startDate = new Date(item.start.dateTime);

    return {
        title: item.summary,
        link: item.htmlLink,
        startDate: startDate.toISOString(),
        start: humanDate(startDate),
        startRelative: moment(startDate).fromNow(),
    };
}

function parseQuery(query) {
    var results = chrono.parse(query);
    if (results.length < 1) {
        return null;
    }

    var res = results[0];

    var startDate = res.start.date();
    var endDate = startDate;

    if (res.end) {
        endDate = end.date();
    }

    var title = query.replace(res.text, "").trim();
    if (!title) {
        title = query;
    }

    var staleStartDate = startDate < new Date();

    return {
        title: title,
        startDate: startDate.toISOString(),
        endDate: endDate.toISOString(),
        start: humanDate(startDate),
        end: humanDate(endDate),
        staleStartDate: staleStartDate,
    };
}

function createReminder(draft) {
    var event = {
        summary: draft.title,
        start: {
            dateTime: draft.startDate,
        },
        end: {
            dateTime: draft.endDate,
        },
        reminders: {
            useDefault: false,
            overrides: [
                {method: 'email', minutes: 0},
                {method: 'popup', minutes: 0},
            ],
        },
        extendedProperties: {
            private: {
                isReminder: true,
            },
        },
    };

    var request = gapi.client.calendar.events.insert({
        'calendarId': 'primary',
        'resource': event
    });

    request.execute(function(event) {
        var reminder = formatReminder(event);
        app.ports.createReminderSuccess.send(reminder);
    });
}

function humanDate(dt) {
    return moment(dt).format("HH:mm @ dddd, DD MMM YYYY");
}

// Helper function to send current user to elm
function sendUser(auth) {
    var user = getUser(auth);
    app.ports.authChange.send(user);
}


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
