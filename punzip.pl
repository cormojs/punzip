#!/usr/bin/perl -sl
use Archive::Zip;
use Text::Iconv;

# Pretend option
our $p;

# Create new archive
our $c;

# Encoding option
our $encoding_from;
our $encoding_to;

sub usage {
  print "To compress files:\n",
    "  punzip.pl -c=archive_name files...\n";
  print "To extract an archive:\n",
    "  punzip.pl archive_name";
  print "Note that -p option will print all information but do not actually run."
}

sub deflate {
  my ($p, $files, $archive) = @_;
  my $zip = Archive::Zip->new();

  print "Compress to $archive...";
  print "---";
  foreach (@$files) {
    print "Deflating... $filename";
  }

}

sub inflate {
  my ($pretend, $archive, $encoder) = @_;
  my $zip = Archive::Zip->new();

  $zip->read($archive) == AZ_OK
    or die "Cannot read archive $archive.";

  print "Archive $archive:";

  foreach ($zip->members()) {
    my $filename = (defined $encoder
		    ? $encoder->convert($_->fileName())
		    : $_->fileName());

    print "Inflating... $filename";

    !defined $pretend
      and $zip->extractMember($_, $filename);
  }

  print "---";
  print $zip->numberOfMembers(), " files extracted";
}

sub main {
  !defined $encoding_from
    and $encoding_from = "SJIS";
  !defined $encoding_to
    and $encoding_to = "SJIS";

  if (defined $c) {
    deflate($p, \@ARGV, $c);
  } else {
    inflate($p, $ARGV[0],
	    ($encoding_from eq $encoding_to
	     ? Text::Iconv->new($encoding_from, $encoding_to)
	     : undef));
  }
}

main();
