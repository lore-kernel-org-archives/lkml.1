Return-Path: <linux-kernel-owner+w=401wt.eu-S936032AbXHLSZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936032AbXHLSZr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 14:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763162AbXHLSZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 14:25:38 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:46471 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765282AbXHLSZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 14:25:37 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46BF508A.409@s5r6.in-berlin.de>
Date: Sun, 12 Aug 2007 20:25:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
References: <20070809113122.3aa508e4@oldman.hamilton.local> <20070810201704.GI6002@1wt.eu> <20070810204025.GC29549@fieldses.org> <20070810205117.GJ6002@1wt.eu> <20070811141925.GA21866@fieldses.org> <20070811141718.GK6002@1wt.eu> <20070811201210.f5ba7d4d.rdunlap@xenotime.net> <46BF06E1.9000302@s5r6.in-berlin.de> <20070812154328.GB13141@uranus.ravnborg.org>
In-Reply-To: <20070812154328.GB13141@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Sun, Aug 12, 2007 at 03:10:57PM +0200, Stefan Richter wrote:
>> One note on asciidoc:  I experienced the same as Willy when I wanted to
>> build git with manpages on a distribution without prebuilt asciidoc.
> 
> I assume you had troubles with the docbook utilities and not asciidoc itself.
> asciidoc is used to generate the format used by docbook utilities to
> generate man-pages.

Probably.  I repressed the memory of that traumatizing experience.

> The html example I posted previously were made solely by asciidoc and no
> additional docbook stuff.

Good.  The vanilla asciidoc-8.2.2.tar.gz looks like it can be installed
without any prerequisites besides Python >=2.3.  (The distro which I am
currently using has prepackaged versions of asciidoc.)
-- 
Stefan Richter
-=====-=-=== =--- -==--
http://arcgraph.de/sr/
