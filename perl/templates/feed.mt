% my $items = shift;
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xml:base="https://www.blognone.com"  xmlns:dc="http://purl.org/dc/elements/1.1/">
<channel>
<title>Judebot</title>
<link>http://judebot-craftcode.rhcloud.com/</link>
<description>Judebot is a bot who work for someone in Thailand.</description>
<language>en</language>

% foreach my $item ( @{ $items } ) {
<item>
    <title><%= $item->{title} %></title>
    <link><%= $item->{link} %></link>
    <description><%= $item->{description} %></description>
    <pubDate><%= $item->{pubDate} %></pubDate>
</item>
% }

</channel>
</rss>
