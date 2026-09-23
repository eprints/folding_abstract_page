$c->{folding_abstract_page}->{generate_fragments} = sub {
    my ( $repository, $eprint ) = @_;

    my %fragments = ();

    my $video_player = $repository->xml->create_document_fragment;
    if ( $eprint->exists_and_set("official_url") ) {
        my $url = $eprint->value("official_url");
        if ( $url =~ m{^(https?)://www\.youtube\.com/.*\bv=([^;&]+)} ) {
            $video_player->appendChild(
                $repository->xml->create_element(
                    "iframe",
                    width  => 758,
                    height => 426,
                    src    =>
                      sprintf( "$1://www.youtube-nocookie.com/embed/%s", $2 ),
                    frameborder     => 0,
                    allowfullscreen => "yes"
                )
            );
        }
        elsif ( $url =~ m{^(https?)://www\.youtube\.com/live/([^;&]+)} ) {
            $video_player->appendChild(
                $repository->xml->create_element(
                    "iframe",
                    width  => 758,
                    height => 426,
                    src    => sprintf( "$1://www.youtube.com/embed/%s", $2 ),
                    frameborder     => 0,
                    allowfullscreen => "yes"
                )
            );
        }
        elsif ( $url =~ m{^(https?)://vimeo.com/(\d+)} ) {
            $video_player->appendChild(
                $repository->xml->create_element(
                    "iframe",
                    width  => 758,
                    height => 426,
                    src    =>
                      sprintf( "$1://player.vimeo.com/video/%s?dnt=1", $2 ),
                    frameborder     => 0,
                    allowfullscreen => "yes"
                )
            );
        }
    }

    $fragments{document_video_player} = $video_player;

    # Creates a fragment list of document citations for each type of eprint present in the record,
    # in the format of "document_video"
    foreach my $document ($eprint->get_all_documents()) {
        my $format = "document_" . $document->get_value("format");
        if (!defined $fragments{$format}) {
            my $frag = $repository->xml()->create_document_fragment();
            my $elem = $repository->xml()->create_element("ul", class => "document_list", id=>"${format}_list");
            $frag->appendChild($elem);

            $fragments{$format} = $elem;
        };
		my $li = $repository->xml()->create_element("li");
		$li->appendChild($document->render_citation("summary_page_doc"));

        $fragments{$format}->appendChild($li);
    };



    # Convert the document fragments into tuples, of "XHTML"
    foreach my $key ( keys %fragments ) {
        $fragments{$key} = [ $fragments{$key}, "XHTML" ];
    }

    # Goes through all document format types - if we do not have a fragment for a type (as it is not present),
    # create one with the value "false". Needed to stop EPScript from getting upset.
    # 
    # also adds a "size" attribute to the fragments. Used for styling.
    my $ds = $repository->get_dataset("document");
    foreach my $key ( $ds->get_field("format")->tags() ) {
        my $id    = "document_" . $key;
        my $value = $fragments{$id};
        if ( !defined $value ) {
            $fragments{$id} = [ 0, "BOOLEAN" ];
        }
        else {
            my $node = $value->[0];

            my $size = $node->childNodes->size;
            if ( $size == 1 ) {
                $size = "single";
            }
            elsif ( $size < 5 ) {
                $size = "large";
            }
            elsif ( $size < 11 ) {
                $size = "medium";
            }
            else {
                $size = "small";
            }
            $node->setAttribute( "size", $size );
        }
    }

    return %fragments;
};
