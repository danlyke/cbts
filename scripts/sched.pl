#!/usr/bin/env perl
use warnings;
use strict;
use Data::Dumper;

our @dates;
require './schedule_data.pl';

open my $fh, '>', '../src/html/Schedule.html';
print $fh <<EOF;
EOF

my $container_id = 0;
my $rowcolumn = 1;
my $table_id = '001';
for my $date (@dates)
{
    my $day = $date->{date};
    my ($dd) = $day =~ /(\d+)$/;
    warn "Unable to find day in $day" if (!$dd);

    my $cid0 = sprintf('%03d', $container_id);
    ++ $container_id;
    my $cid1 = sprintf('%03d', $container_id);
    ++ $container_id;
    
    print $fh <<EOF;
<!-- $day -->
<div id="_idContainer$cid0" class="Basic-Text-Frame dayContainer-$dd">
	<p class="Date">$day</p>
</div>
<div id="_idContainer$cid1" class="Basic-Text-Frame dayContainer-$dd">

	<table id="table$table_id" class="Basic-Table">
		<colgroup>
EOF
    my $events = $date->{events};
    my (%programs, @programs, %rooms, @rooms, %programs_by_room);
    for my $event (@$events)
    {
        if (defined($event->{program}) && !defined($programs{$event->{program}}))
        {
            push @programs, $event->{program};
            $programs{$event->{program}} = $#programs;
        }
        if (defined($event->{room}) && !defined($rooms{$event->{room}}))
        {
            push @rooms, $event->{room};
            $rooms{$event->{room}} = $#rooms;
        }

        if (defined($event->{room})) {
            $programs_by_room{$event->{room}} = [] unless defined($programs_by_room{$event->{room}});
        }
        
        if (defined($event->{program}) && defined($event->{room}))
        {
            push @{$programs_by_room{$event->{room}}}, $event->{program};
        }
    }

    for my $col (@rooms)
    {
        print $fh <<EOF;
			<col class="_idGenTableRowColumn-$rowcolumn" />
EOF
        $rowcolumn++;
    }
    
    print $fh <<EOF;
		</colgroup>
		<thead>
			<tr class="Basic-Table _idGenTableRowColumn-$rowcolumn">
				<td class="Basic-Table Header" />
EOF
    $rowcolumn++;
    for my $program (@programs)
    {
        my $dance_program = $program;
        print $fh <<EOF;
				<td class="Basic-Table $dance_program">
					<p class="Level">$program</p>
				</td>
EOF
    }
    print $fh <<EOF;
			</tr>
		</thead>
		<tbody>
			<tr class="Basic-Table _idGenTableRowColumn-$rowcolumn">
				<td class="Basic-Table Body _idGenCellOverride-1" />
EOF
    $rowcolumn++;
    for my $room (@rooms)
    {
        my $programs = join(' ', @{ $programs_by_room{$room} });
        print $fh <<EOF;
				<td class="Basic-Table Rooms $programs">
					<p class="Rooms"><span class="Rooms">$room</span><span class="RoomArrow">↓</span></p>
				</td>
EOF
    }

    my $timeslot = '<not defined>';
    my @eventrows;
    my $eventrow = {};
    for my $event (@$events)
    {
        if ($event->{timeslot} && $event->{timeslot} ne $timeslot)
        {
            push @eventrows, {timeslot => $timeslot, rooms => $eventrow } if (%$eventrow);
                
            $eventrow = {};
            $timeslot = $event->{timeslot};
            $rowcolumn++;
        }
        $eventrow->{$event->{room}} = $event if ($event->{room})
    }
    push @eventrows, {timeslot => $timeslot, rooms => $eventrow } if (%$eventrow);

    # for each row, if the description from the previous timeslot
    # is the same as the current timeslot, collapse the column

    my %prevrooms = ();
    for my $eventrow (@eventrows)
    {
        my $rooms = $eventrow->{rooms};

        for my $room (keys %prevrooms)
        {
            undef $prevrooms{$room} if (!defined($rooms->{$room}));
        }
        for my $room (@rooms)
        {
            $rooms->{$room} = { desc => '' } unless defined($rooms->{$room});
        }
    }

    %prevrooms = ();
    for my $eventrow (@eventrows)
    {
        my $rooms = $eventrow->{rooms};

        for my $room (keys %prevrooms)
        {
            undef $prevrooms{$room} if (!defined($rooms->{$room}));
        }

        my @rooms_this_row = keys %$rooms;
        for my $room (@rooms_this_row)
        {
            if ($prevrooms{$room} && defined($prevrooms{$room}{desc}) && defined($rooms->{$room}{desc}) &&  $prevrooms{$room}{desc} eq $rooms->{$room}{desc})
            {
                $prevrooms{$room}{rowspan} = 1 unless defined($prevrooms{$room}{rowspan});
                $prevrooms{$room}{rowspan}++;
                undef($rooms->{$room});
            }
            $prevrooms{$room} = $rooms->{$room} if defined($rooms->{$room});
        }
    }

    print Dumper(\@eventrows);

    for my $eventrow (@eventrows)
    {
        print $fh <<EOF;
			<tr class="Basic-Table _idGenTableRowColumn-$rowcolumn">
				<td class="Basic-Table Body">
					<p class="Basic-Paragraph">
						<span class="Body">$eventrow->{timeslot}</span>
					</p>
				</td>
EOF
        $rowcolumn++;
        
        for my $room (@rooms)
        {
            my $event = $eventrow->{rooms}{$room};
            if ($event)
            {
                my $program = defined($event->{program}) ? " $event->{program}" : join(' ', @{ $programs_by_room{$room} });
;
                my $rowspan = defined($event->{rowspan}) ? " rowspan=$event->{rowspan}" : '';
                warn "no desc in ".Dumper($event) unless defined($event->{desc});
                print $fh <<EOF;
				<td class="Basic-Table $program"$rowspan>
					<p class="Headline-caller">$event->{desc}</p>
				</td>
EOF
            }
        }
        print $fh <<EOF;
			</tr>
EOF
    }
        print $fh <<EOF;
		</tbody>
	</table>
</div>
EOF
}

print $fh <<EOF;
EOF
