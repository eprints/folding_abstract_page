# Folding abstract page

## Setup
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

The ingredient provides fragments to the citation for each format of document, for example `document_text` and `document_video`. The fragments take the form of an unordered list with each document's `summary_page_doc` citation within each list item.

These fragments can then be displayed in the EPrint `summary_page` citation, as below:

```xml
    <epc:if test="$document_video_player"> 
      <details open="">
        <summary><h2>Online Video</h2></summary>
        <epc:print expr="$document_image" />
      </details>
    </epc:if>
```

An example `summary_page` is included with the ingredient.

## Mapping formats
Sometimes, you might want to map formats - for example, so "video" and "audio" appear in one category, or to map from mimetype style to the expected `text`. This can be done using `$c->{folding_abstract_page}->map_format`, which allows you to modify the format of a document to be something else.
