#!/usr/bin/perl -l

package BusinessDays;

use strict;
use warnings;
use Date::Calendar::Profiles qw( $Profiles );
use Date::Calendar;

require Exporter;
our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
    'all' => [
        qw(

          )
    ]
);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(calc_business_days);

our $VERSION = '1.00';

my $BusinessHolidays = {
    "New Years Day"       => "01/01",
    "Memorial Day"        => "5/Mon/May",
    "Independence Day"    => "07/04",
    "Labor Day"           => "1/Mon/Sep",
    "Thanksgiving Day"    => "4/Thu/Nov",
    "Thanksgiving Friday" => "4/Fri/Nov",
    "Christmas Eve"       => "12/24",
    "Christmas Day"       => "12/25"
};

sub calc_business_days {
    # expect dates to be passed om form of yyyy-mm-dd
    my $start_date = shift;
    my $end_date   = shift;
    my @start_date = split(/-/, $start_date);
    my @end_date   = split(/-/, $end_date);

    my $start_year  = $start_date[0];
    my $start_month = $start_date[1];
    my $start_day   = $start_date[2];
    my $end_year    = $end_date[0];
    my $end_month   = $end_date[1];
    my $end_day     = $end_date[2];

    if ($start_year eq "0000" or $end_year eq "0000") {
      return 0;
    }

    #my $cal = Date::Calendar->new( $Profiles->{US} )
    my $calendar = Date::Calendar->new($BusinessHolidays)
      or die "no calendar\n";

    # Add 1 to delta return as if started and ended on same day,
    # then should return 1 business day
    my $days = $calendar->delta_workdays(
        $start_year, $start_month, $start_day,    # start date
        $end_year, $end_month, $end_day,          # end date
        1,                                        # include first date
        0);                                       # exclude second date

    #print "days: $days";    
    return $days;
}

1;
__END__

=head1 NAME

BusinessDays - Perl extension

=head1 SYNOPSIS

  use BusinessDays;


=head1 DESCRIPTION

BusinessDays, created by Keith Butler. This module provides
core methods for calculating the number of buisness days between 2 dates. 
This can be used for SLA to not calculate weekends or holidays.

calc_business_days(): returns number of business days excluding holidays

=head2 EXPORT

None by default.

=head1 HISTORY

=over 8

=item 0.01

Original version; created by h2xs 1.23 with options

  -ACXn
	BusinessDays

=back


=head1 SEE ALSO

This module has a dependency on Date::Calendar and Date::Calendar::Profiles

=head1 AUTHOR

Keith Butler, E<lt>keith@thundersteed.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2021 by ThunderSteed

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.24.1 or,
at your option, any later version of Perl 5 you may have available.

=cut
