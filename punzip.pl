#!/usr/bin/perl -sl
use strict;
use Archive::Zip;
use Text::Iconv;

# Pretend option
our $p;

# Encoding option
our $encoding_from;
our $encoding_to;

sub usage {
  print "To extract an archive:\n",
    "  punzip.pl archive_name";
  print "Option -p will print all information but do not actually run.";
  print "Option -encoding_from=<encoding> and -encoding_to=<encoding>";
  print "  convert name of extracted files ";
  print "  each default value of these is SJIS";
}

sub inflate {
  my ($pretend, $archive, $encoder) = @_;
  my $zip = Archive::Zip->new();

  $zip->read($archive) == Archive::Zip->AZ_OK
    or die "Cannot read archive $archive.";

  print "Archive $archive:";

  foreach ($zip->members()) {
    my $filename = $encoder->convert($_->fileName());

    print "Inflating... $filename";

    !defined $pretend
      and $zip->extractMember($_, $filename);
  }

  print "---";
  print $zip->numberOfMembers(), " files extracted";
}

sub main {
  inflate($p, $ARGV[0], Text::Iconv->new($encoding_from, $encoding_to));
}

main();
