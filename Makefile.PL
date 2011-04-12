
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Make your object constructor collect all unknown attributes',
  'AUTHOR' => 'Mark Morgan <makk384@gmail.com>, Karen Etheridge <ether@cpan.org>',
  'BUILD_REQUIRES' => {
    'Test::Deep' => '0',
    'Test::Fatal' => '0',
    'Test::More' => '0.88'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'MooseX-SlurpyConstructor',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'MooseX::SlurpyConstructor',
  'PREREQ_PM' => {
    'Moose' => '0.94',
    'namespace::autoclean' => '0'
  },
  'VERSION' => '1.2',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



