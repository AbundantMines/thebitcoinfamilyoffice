#!/usr/bin/perl
# Third pass: Handle <article class="content"> files
use strict;
use warnings;
use File::Basename;
use File::Glob ':glob';

my @target_files = (
    "/workspace/thebitcoinfamilyoffice/blog/bitcoin-custody-solutions-family-offices.html",
    "/workspace/thebitcoinfamilyoffice/blog/bitcoin-tax-optimization-high-net-worth.html",
    "/workspace/thebitcoinfamilyoffice/blog/building-bitcoin-native-family-office.html",
    "/workspace/thebitcoinfamilyoffice/blog/complete-guide-bitcoin-family-offices.html",
    "/workspace/thebitcoinfamilyoffice/blog/multi-generational-bitcoin-wealth-estate-planning.html",
);

my $AUTHOR_BOX = <<'AUTHORBOX';
<div class="author-box" style="max-width:var(--max-w,720px);margin:0 auto 2rem;padding:1.5rem 2rem;background:rgba(247,147,26,0.04);border:1px solid rgba(247,147,26,0.25);border-radius:4px;display:flex;gap:1.5rem;align-items:flex-start;">
  <div style="flex-shrink:0;width:48px;height:48px;border-radius:50%;background:rgba(247,147,26,0.10);border:1px solid rgba(247,147,26,0.25);display:flex;align-items:center;justify-content:center;font-size:1rem;color:#f7931a;">&#x20BF;</div>
  <div>
    <p style="font-family:'Inter',-apple-system,sans-serif;font-size:0.65rem;letter-spacing:0.12em;text-transform:uppercase;color:#f7931a;margin-bottom:0.3rem;">The Bitcoin Family Office Research Team</p>
    <p style="font-family:'EB Garamond',Georgia,serif;font-size:0.9rem;color:#9a958d;line-height:1.7;margin:0;">Our research team focuses exclusively on Bitcoin wealth management &mdash; custody architecture, estate planning, tax strategy, and multi-generational stewardship. We do not advise on altcoins or fiat instruments. <a href="/about/" style="color:#f7931a;text-decoration:none;">About us &rarr;</a></p>
  </div>
</div>
AUTHORBOX

my $RELATED_READING = <<'RELATED';
<div style="max-width:720px;margin:0 auto 2rem;padding:0 1.5rem;">
  <p style="font-family:'Inter',-apple-system,sans-serif;font-size:0.6rem;letter-spacing:0.15em;text-transform:uppercase;color:#6b6660;margin-bottom:1.25rem;">Related Reading</p>
  <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:1rem;">
    <a href="/blog/bitcoin-custody-architecture.html" style="display:block;padding:1.25rem;background:#111;border:1px solid rgba(255,255,255,0.06);border-radius:4px;text-decoration:none;transition:border-color 0.2s;" onmouseover="this.style.borderColor='rgba(247,147,26,0.25)'" onmouseout="this.style.borderColor='rgba(255,255,255,0.06)'">
      <p style="font-family:'Inter',-apple-system,sans-serif;font-size:0.6rem;letter-spacing:0.1em;text-transform:uppercase;color:#f7931a;margin-bottom:0.5rem;">Custody</p>
      <p style="font-family:'Playfair Display',Georgia,serif;font-size:1rem;color:#e8e4de;font-weight:400;line-height:1.4;margin:0;">Bitcoin Custody Architecture for Family Offices</p>
    </a>
    <a href="/blog/complete-guide-bitcoin-family-offices.html" style="display:block;padding:1.25rem;background:#111;border:1px solid rgba(255,255,255,0.06);border-radius:4px;text-decoration:none;transition:border-color 0.2s;" onmouseover="this.style.borderColor='rgba(247,147,26,0.25)'" onmouseout="this.style.borderColor='rgba(255,255,255,0.06)'">
      <p style="font-family:'Inter',-apple-system,sans-serif;font-size:0.6rem;letter-spacing:0.1em;text-transform:uppercase;color:#f7931a;margin-bottom:0.5rem;">Overview</p>
      <p style="font-family:'Playfair Display',Georgia,serif;font-size:1rem;color:#e8e4de;font-weight:400;line-height:1.4;margin:0;">The Complete Guide to Bitcoin Family Offices</p>
    </a>
    <a href="/blog/bitcoin-estate-planning-complete-guide.html" style="display:block;padding:1.25rem;background:#111;border:1px solid rgba(255,255,255,0.06);border-radius:4px;text-decoration:none;transition:border-color 0.2s;" onmouseover="this.style.borderColor='rgba(247,147,26,0.25)'" onmouseout="this.style.borderColor='rgba(255,255,255,0.06)'">
      <p style="font-family:'Inter',-apple-system,sans-serif;font-size:0.6rem;letter-spacing:0.1em;text-transform:uppercase;color:#f7931a;margin-bottom:0.5rem;">Estate Planning</p>
      <p style="font-family:'Playfair Display',Georgia,serif;font-size:1rem;color:#e8e4de;font-weight:400;line-height:1.4;margin:0;">Bitcoin Estate Planning: The Complete Guide</p>
    </a>
  </div>
</div>
RELATED

my $BREADCRUMB = <<'BREADCRUMB';

<p class="article-breadcrumb" style="font-family:'Inter',-apple-system,sans-serif;font-size:0.65rem;letter-spacing:0.1em;text-transform:uppercase;color:#6b6660;margin-bottom:2rem;padding-bottom:1rem;border-bottom:1px solid rgba(255,255,255,0.06);">
  <a href="/" style="color:#6b6660;text-decoration:none;">Home</a> <span style="margin:0 0.5rem;">&#x203A;</span>
  <a href="/blog/" style="color:#6b6660;text-decoration:none;">Research</a> <span style="margin:0 0.5rem;">&#x203A;</span>
  <span style="color:#9a958d;">Article</span>
  <span style="margin-left:1.5rem;padding-left:1.5rem;border-left:1px solid rgba(255,255,255,0.06);">Est. 8 min read</span>
</p>
BREADCRUMB

my $changed = 0;

for my $fpath (@target_files) {
    my $filename = basename($fpath);
    
    open(my $fh, '<', $fpath) or die "Cannot open $fpath: $!";
    local $/;
    my $content = <$fh>;
    close $fh;
    
    my $original = $content;
    my @changes;
    
    # FIX 4: Breadcrumb after <article class="content">
    if ($content !~ /article-breadcrumb/) {
        if ($content =~ s|(<article class="content">)(\s*\n)|$1$2$BREADCRUMB|s) {
            push @changes, "FIX4:breadcrumb";
        }
    }
    
    # FIX 1 + FIX 5: After </article> insert Related Reading + Author Box
    if ($content !~ /Related Reading/ && $content !~ /author-box/) {
        if ($content =~ s|(</article>\s*\n\s*\n)(<div class="related">)|$1${RELATED_READING}\n${AUTHOR_BOX}\n$2|s) {
            push @changes, "FIX5+FIX1:before-related-div";
        } elsif ($content =~ s|(</article>\s*\n\s*\n)(<footer)|$1${RELATED_READING}\n${AUTHOR_BOX}\n$2|s) {
            push @changes, "FIX5+FIX1:before-footer";
        }
    }
    
    # FIX 10: About in footer
    if ($content !~ m|href="/about/"| && $content =~ /footer/) {
        # These files may have different footer structures
        if ($content =~ s|(disclosures[^<]*</a>)(\s*</p>)(\s*</div>)|$1$2\n<p><a href="/about/">About</a></p>$3|s) {
            push @changes, "FIX10:about-footer";
        }
    }
    
    if ($content ne $original) {
        open(my $out, '>', $fpath) or die "Cannot write $fpath: $!";
        print $out $content;
        close $out;
        $changed++;
        print "  ✓ $filename: " . join(", ", @changes) . "\n";
    } else {
        print "  ~ $filename: no changes\n";
    }
}

print "\nDone. Modified $changed/" . scalar(@target_files) . " files.\n";
