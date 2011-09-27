declare namespace atom="http://www.w3.org/2005/Atom";
declare namespace avm='http://www.communicatingastronomy.org/avm/1.0/';
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace dc="http://purl.org/dc/elements/1.1/";
declare namespace photoshop='http://ns.adobe.com/photoshop/1.0/';
declare namespace media="http://search.yahoo.com/mrss/";

<rss xmlns:atom="http://www.w3.org/2005/Atom" version="2.0" xmlns:media="http://search.yahoo.com/mrss/">
  <channel>
    <title>Image Gallery</title>
      <description></description>
      <link>http://www.spitzer.caltech.edu/resource_list/0-Image-Gallery</link>
      <atom:icon>http://www.spitzer.caltech.edu/images/spitzer_icon.png?1274224175</atom:icon>

{
for $match in //rdf:Description[fn:matches(fn:string(avm:Type),"Observation")]
let $image := $match/ancestor::rdf:RDF
let $title := $image//dc:title/rdf:Alt/rdf:li/text()
let $description := $image//photoshop:Headline/text()
let $category := $image//avm:Type/text()
let $link := $image//avm:ReferenceURL/text()
let $guid := $image//avm:ID/text()
let $date := $image//avm:MetadataDate/text()
let $contentUrl := $image//avm:ResourceURL/text()
return
        <item>
                <title>{$title}</title>
                <description>{$description}</description>
                <category>{$category}</category>
                <link>{$link}</link>
                <guid isPermaLink='false'>{$guid}</guid>
                <pubDate>{$date}</pubDate>
                <media:content type='image/jpeg' url='{$contentUrl}' medium='image' />
                <media:thumbnail url='{$contentUrl}' />
        </item>
}
  </channel>
</rss>
