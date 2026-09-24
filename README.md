# Folding abstract page
An ingredient for EPrints that adds folding per-document type sections to the abstract page.

Provides a EPrint `summary_page` citation with the folding pages, which can be copied to the archive and modified as needed.

To get it working, you must install the ingredient, then update the render_citation in eprint_render.pl to call off to `$c->folding_abstract_page->generate_fragments`, as below:
```pl
my $page = $eprint->render_citation(
  "summary_page",
  %fragments,
  flags=>$flags,
  &{$repository->config("folding_abstract_page", "generate_fragments")}($repository, $eprint)
);
```
