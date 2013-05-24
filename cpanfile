requires 'perl', '5.008005';

# requires 'Some::Module', 'VERSION';
requires 'Net::IPMessenger', '>= 0.14';

on test => sub {
    requires 'Test::More', '0.88';
    requires 'Net::EmptyPort';
};
