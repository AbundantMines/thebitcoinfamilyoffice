#!/usr/bin/perl
use strict;
use warnings;
use File::Glob ':glob';

my @missing = grep { !-f "$_.skip" } map { chomp; $_ } `grep -rL "BreadcrumbList" /workspace/thebitcoinfamilyoffice/blog/*.html | grep -v index`;

for my $fpath (@missing) {
    chomp $fpath;
    open(my $fh, '<', $fpath) or die "Cannot open $fpath: $!";
    local $/;
    my $content = <$fh>;
    close $fh;
    
    next if $content =~ /BreadcrumbList/;
    
    my $canonical = "";
    if ($content =~ /link rel="canonical" href="([^"]+)"/) {
        $canonical = $1;
    }
    unless ($canonical) {
        print "  ⚠ No canonical URL found in $fpath\n";
        next;
    }
    
    my $bc_schema = qq{<script type="application/ld+json">
{
  "\@context": "https://schema.org",
  "\@type": "BreadcrumbList",
  "itemListElement": [
    {"\@type": "ListItem", "position": 1, "name": "Home", "item": "https://thebitcoinfamilyoffice.com"},
    {"\@type": "ListItem", "position": 2, "name": "Research", "item": "https://thebitcoinfamilyoffice.com/blog/"},
    {"\@type": "ListItem", "position": 3, "name": "Article", "item": "$canonical"}
  ]
}
</script>

};
    
    # Try inserting after first ld+json closing </script>
    if ($content =~ s|(</script>)(\s*\n\s*\n<!-- Google Analytics)|$1\n\n$bc_schema$2|s) {
        # inserted
    } elsif ($content =~ s|(</script>)(\s*\n<!-- Google Analytics)|$1\n\n$bc_schema$2|s) {
        # inserted alt
    } else {
        # Insert before </head>
        $content =~ s|(</head>)|$bc_schema$1|;
    }
    
    open(my $out, '>', $fpath) or die "Cannot write $fpath: $!";
    print $out $content;
    close $out;
    print "  ✓ " . (split /\//, $fpath)[-1] . "\n";
}
print "Done\n";
