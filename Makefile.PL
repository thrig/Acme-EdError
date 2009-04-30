use inc::Module::Install;

# Define metadata
name 'Acme-EdError';
all_from 'lib/Acme/EdError.pm';

# Specific dependencies
test_requires 'Test::More' => '0.86';
test_requires 'IPC::Open3' => '1.0106';

WriteAll;
