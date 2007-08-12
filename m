Return-Path: <linux-kernel-owner+w=401wt.eu-S1765568AbXHLDGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765568AbXHLDGh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 23:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757933AbXHLDGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 23:06:24 -0400
Received: from xenotime.net ([66.160.160.81]:60058 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764362AbXHLDGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 23:06:16 -0400
Date: Sat, 11 Aug 2007 20:12:10 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Willy Tarreau <w@1wt.eu>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-Id: <20070811201210.f5ba7d4d.rdunlap@xenotime.net>
In-Reply-To: <20070811141718.GK6002@1wt.eu>
References: <20070809113122.3aa508e4@oldman.hamilton.local>
	<20070810201704.GI6002@1wt.eu>
	<20070810204025.GC29549@fieldses.org>
	<20070810205117.GJ6002@1wt.eu>
	<20070811141925.GA21866@fieldses.org>
	<20070811141718.GK6002@1wt.eu>
Organization: YPO4
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Aug 2007 16:17:19 +0200 Willy Tarreau wrote:

> On Sat, Aug 11, 2007 at 10:19:25AM -0400, J. Bruce Fields wrote:
> > On Fri, Aug 10, 2007 at 10:51:17PM +0200, Willy Tarreau wrote:
> > > The problem I have with asciidoc is that it's a nightmare to get it
> > > to work. It's what GIT uses, and after spending a whole day trying
> > > to *build* that thing, I finally resigned and asked Junio if he could
> > > publish the pre-formatted manpages himself, which he agreed to.
> > 
> > I wasn't actually suggesting we use the asciidoc tools--that's a
> > separate question.  We could ignore them, or wait till they solve
> > whatever problems they may have.
> > 
> > I was just suggesting that if we took your suggestion of standardizing
> > on plain text plus some conventions for formatting lists and headers and
> > such, one easy way to do that might just be to adopt the asciidoc format
> > (or some subset thereof).  Is there any part of the asciidoc *syntax*
> > that you object to?
> 
> Not particularly. It's just slightly less readable as plain text but
> OTOH produces nice documents when you have a working toolchain. But
> that's a language which needs to be learned, as every such language.
> Plain text on the contrary, requires no learning. The conventions are
> more like suggestions to newcomers. Everyone is free to proceed as he
> wants, judging by the result while writing the text.

[resend, sorry about duplicates]

but if we use something richer than plain text, I think that we
shouldn't need to invent yet another markup language.
Just use HTML or asciidoc or MarkDown etc...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
