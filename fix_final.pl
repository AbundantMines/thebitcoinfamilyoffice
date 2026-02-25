#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use File::Glob ':glob';

my $BLOG_DIR = "/workspace/thebitcoinfamilyoffice/blog";
my @blog_files = sort grep { !/\/index\.html$/ } glob("$BLOG_DIR/*.html");

my $AUTHOR_BOX = <<'AUTHORBOX';
<div class="author-box" style="max-width:var(--max-w);margin:0 auto 2rem;padding:1.5rem 2rem;background:var(--bg-elevated);border:1px solid var(--accent-border);border-radius:4px;display:flex;gap:1.5rem;align-items:flex-start;">
  <div style="flex-shrink:0;width:48px;height:48px;border-radius:50%;background:var(--accent-dim);border:1px solid var(--accent-border);display:flex;align-items:center;justify-content:center;font-family:var(--sans);font-size:1rem;color:var(--accent);">&#x20BF;</div>
  <div>
    <p style="font-family:var(--sans);font-size:0.65rem;letter-spacing:0.12em;text-transform:uppercase;color:var(--accent);margin-bottom:0.3rem;">The Bitcoin Family Office Research Team</p>
    <p style="font-family:var(--serif);font-size:0.9rem;color:var(--text-secondary);line-height:1.7;margin:0;">Our research team focuses exclusively on Bitcoin wealth management &mdash; custody architecture, estate planning, tax strategy, and multi-generational stewardship. We do not advise on altcoins or fiat instruments. <a href="/about/" style="color:var(--accent);text-decoration:none;">About us &rarr;</a></p>
  </div>
</div>
AUTHORBOX

my $RELATED_READING = <<'RELATED';
<div style="max-width:var(--max-w);margin:0 auto 2rem;padding:0 1.5rem;">
  <p style="font-family:var(--sans);font-size:0.6rem;letter-spacing:0.15em;text-transform:uppercase;color:var(--text-muted);margin-bottom:1.25rem;">Related Reading</p>
  <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:1rem;">
    <a href="/blog/bitcoin-custody-architecture.html" style="display:block;padding:1.25rem;background:var(--bg-elevated);border:1px solid var(--border);border-radius:4px;text-decoration:none;transition:border-color 0.2s;" onmouseover="this.style.borderColor='var(--accent-border)'" onmouseout="this.style.borderColor='var(--border)'">
      <p style="font-family:var(--sans);font-size:0.6rem;letter-spacing:0.1em;text-transform:uppercase;color:var(--accent);margin-bottom:0.5rem;">Custody</p>
      <p style="font-family:var(--display);font-size:1rem;color:var(--text);font-weight:400;line-height:1.4;margin:0;">Bitcoin Custody Architecture for Family Offices</p>
    </a>
    <a href="/blog/complete-guide-bitcoin-family-offices.html" style="display:block;padding:1.25rem;background:var(--bg-elevated);border:1px solid var(--border);border-radius:4px;text-decoration:none;transition:border-color 0.2s;" onmouseover="this.style.borderColor='var(--accent-border)'" onmouseout="this.style.borderColor='var(--border)'">
      <p style="font-family:var(--sans);font-size:0.6rem;letter-spacing:0.1em;text-transform:uppercase;color:var(--accent);margin-bottom:0.5rem;">Overview</p>
      <p style="font-family:var(--display);font-size:1rem;color:var(--text);font-weight:400;line-height:1.4;margin:0;">The Complete Guide to Bitcoin Family Offices</p>
    </a>
    <a href="/blog/bitcoin-estate-planning-complete-guide.html" style="display:block;padding:1.25rem;background:var(--bg-elevated);border:1px solid var(--border);border-radius:4px;text-decoration:none;transition:border-color 0.2s;" onmouseover="this.style.borderColor='var(--accent-border)'" onmouseout="this.style.borderColor='var(--border)'">
      <p style="font-family:var(--sans);font-size:0.6rem;letter-spacing:0.1em;text-transform:uppercase;color:var(--accent);margin-bottom:0.5rem;">Estate Planning</p>
      <p style="font-family:var(--display);font-size:1rem;color:var(--text);font-weight:400;line-height:1.4;margin:0;">Bitcoin Estate Planning: The Complete Guide</p>
    </a>
  </div>
</div>
RELATED

my $BREADCRUMB = <<'BREADCRUMB';
  <p class="article-breadcrumb" style="font-family:var(--sans);font-size:0.65rem;letter-spacing:0.1em;text-transform:uppercase;color:var(--text-muted);margin-bottom:2rem;padding-bottom:1rem;border-bottom:1px solid var(--border);">
    <a href="/" style="color:var(--text-muted);text-decoration:none;">Home</a> <span style="margin:0 0.5rem;">&#x203A;</span>
    <a href="/blog/" style="color:var(--text-muted);text-decoration:none;">Research</a> <span style="margin:0 0.5rem;">&#x203A;</span>
    <span style="color:var(--text-secondary);">Article</span>
    <span style="margin-left:1.5rem;padding-left:1.5rem;border-left:1px solid var(--border);">Est. 8 min read</span>
  </p>
BREADCRUMB

my $changed = 0;

for my $fpath (@blog_files) {
    my $filename = basename($fpath);
    
    open(my $fh, '<', $fpath) or die;
    local $/;
    my $content = <$fh>;
    close $fh;
    
    my $original = $content;
    my @changes;
    
    # FIX 4: Breadcrumb
    if ($content !~ /article-breadcrumb/) {
        if ($content =~ s|(<article class="article-body">)(\s*\n)|$1$2$BREADCRUMB|s) {
            push @changes, "FIX4";
        }
    }
    
    # FIX 1+5: Author box + Related Reading
    # Strategy: find </article> and insert before the first block-level element after it
    if ($content !~ /author-box/) {
        # Find what comes after </article>
        my $inserted = 0;
        
        # Case 1: after </article> comes services-cta
        if (!$inserted && $content =~ s|(</article>\s*\n\s*\n)(<div class="services-cta">)|$1${RELATED_READING}\n${AUTHOR_BOX}\n$2|s) {
            $inserted = 1;
        }
        # Case 2: after </article> comes some other cta-box or cta div, then section.related
        if (!$inserted && $content =~ s|(</article>\s*\n\s*\n)(<div class="cta-box">)|$1${RELATED_READING}\n${AUTHOR_BOX}\n$2|s) {
            $inserted = 1;
        }
        # Case 3: after </article> comes section.related
        if (!$inserted && $content =~ s|(</article>\s*\n\s*\n)(<section class="related">)|$1${RELATED_READING}\n${AUTHOR_BOX}\n$2|s) {
            $inserted = 1;
        }
        # Case 4: after </article> comes section class="related" with single newline
        if (!$inserted && $content =~ s|(</article>\n)(<section class="related">)|$1\n${RELATED_READING}\n${AUTHOR_BOX}\n$2|s) {
            $inserted = 1;
        }
        # Case 5: after </article> comes <div class="related">
        if (!$inserted && $content =~ s|(</article>\s*\n\s*\n)(<div class="related">)|$1${RELATED_READING}\n${AUTHOR_BOX}\n$2|s) {
            $inserted = 1;
        }
        # Case 6: before footer
        if (!$inserted && $content =~ s|(</article>\s*\n\s*\n)(<footer)|$1${RELATED_READING}\n${AUTHOR_BOX}\n$2|s) {
            $inserted = 1;
        }
        
        if ($inserted) {
            push @changes, "FIX1+5";
        }
    }
    
    # FIX 10: About link in footer
    if ($content !~ m|href="/about/"| && $content =~ /<div class="footer-links">/) {
        if ($content =~ s|(<div class="footer-links">\s*\n)(\s*<a)|$1    <a href="/about/">About</a>\n$2|) {
            push @changes, "FIX10";
        }
    }
    
    if ($content ne $original) {
        open(my $out, '>', $fpath) or die;
        print $out $content;
        close $out;
        $changed++;
        print "  ✓ $filename: " . join(", ", @changes) . "\n";
    }
}

print "\nTotal modified: $changed\n";
