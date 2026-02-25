#!/usr/bin/perl
use strict;
use warnings;

my @files = (
    "/workspace/thebitcoinfamilyoffice/blog/bitcoin-custody-solutions-family-offices.html",
    "/workspace/thebitcoinfamilyoffice/blog/bitcoin-tax-optimization-high-net-worth.html",
    "/workspace/thebitcoinfamilyoffice/blog/building-bitcoin-native-family-office.html",
    "/workspace/thebitcoinfamilyoffice/blog/complete-guide-bitcoin-family-offices.html",
    "/workspace/thebitcoinfamilyoffice/blog/multi-generational-bitcoin-wealth-estate-planning.html",
);

for my $fpath (@files) {
    open(my $fh, '<', $fpath) or die;
    local $/;
    my $content = <$fh>;
    close $fh;
    
    next if $content =~ /BreadcrumbList/;
    
    my $canonical = "";
    if ($content =~ /link rel="canonical" href="([^"]+)"/) {
        $canonical = $1;
    }
    next unless $canonical;
    
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
    
    # Insert before </head>
    $content =~ s|(</head>)|$bc_schema$1|;
    
    open(my $out, '>', $fpath) or die;
    print $out $content;
    close $out;
    print "  ✓ Added BreadcrumbList to " . (split /\//, $fpath)[-1] . "\n";
}
print "Done\n";
