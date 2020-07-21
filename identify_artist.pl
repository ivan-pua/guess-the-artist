#!/usr/bin/perl -w
use strict;

# read input from each artist
my %artists; # hash tables of hash tables, indexed by artists

# Save song lyrics dataset into a folder called lyrics
foreach my $file (glob "lyrics/*.txt") {
    
    # open a filehandle FH 
    open my $FH, '<' ,$file or die "Can't open $file: $!"; 
    
    my $wordCount=0;
    $file =~ /lyrics\/(.*).txt/; # get name of artists
    my $name = $1;
    $name =~ tr/"_"/ / ;
    
    my %count; # hash = [("peter", 3), ("piper, 2")....]
    
    while (my $line = <$FH>) {

        $line = lc $line;
        chomp $line;

        # do regex in split
        foreach my $word (split /[^a-zA-Z]/, $line) {
            if (!($word eq "")){
                $artists{$name}{$word}++;
                $wordCount++;
            }
        }       
    }
    $artists{$name}{'wordCount'} = $wordCount;
}


foreach my $f (@ARGV) {
    # read the unseen test file
    my @searchTheseWords;

    open my $filehandle, '<' ,$f or die "help: $!"; 
    while (my $searchedLine = <$filehandle>){
        # read words from text file
        my $prob =0;
        $searchedLine = lc $searchedLine;
        chomp $searchedLine;

        # do regex in split
        foreach my $word (split /[^a-zA-Z]/, $searchedLine) {
            if (!($word eq "")){
                push @searchTheseWords, $word;
            }
        }
    }

    foreach my $name (keys %artists) {
        my $sumProb = 0;
        foreach my $word (@searchTheseWords) {
            my $prob =0;
            if (! exists $artists{$name}{$word}) {
                $artists{$name}{$word} = 0;
            }
            $prob=log(($artists{$name}{$word}+1)/$artists{$name}{'wordCount'});
            $sumProb = $sumProb + $prob;
        }
        $artists{$name}{'sumProb'} = $sumProb; # create a new key to store 'sumProb'
    }


    my @unsorted = keys %artists;
    my @sorted = sort {
        # reverse sort if $b <=> $a
        $artists{$b}->{'sumProb'} <=> $artists{$a}->{'sumProb'}

    } @unsorted;

    # foreach my $singleArtist (@sorted) {
    #     printf "%s: log_probability of %.1f for %s\n", 
    #             $fileName, $artists{$singleArtist}{'sumProb'}, $singleArtist;
    # }
    my $singleArtist = shift @sorted;
    # printf "%s: log_probability of %.1f for %s\n", 
    #             $fileName, $artists{$singleArtist}{'sumProb'}, $singleArtist;

    printf "%s most resembles the work of %s (log-probability=%.1f)\n", 
            $f, $singleArtist, $artists{$singleArtist}{'sumProb'} ;
}
