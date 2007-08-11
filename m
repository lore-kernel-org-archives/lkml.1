Return-Path: <linux-kernel-owner+w=401wt.eu-S1762812AbXHLHP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762812AbXHLHP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 03:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760128AbXHLHO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 03:14:59 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45806 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759581AbXHLHO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 03:14:56 -0400
Date: Sat, 11 Aug 2007 16:00:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Willy Tarreau <w@1wt.eu>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation files in html format?
Message-Id: <20070811160037.77d39afe.randy.dunlap@oracle.com>
In-Reply-To: <20070811141718.GK6002@1wt.eu>
References: <20070809113122.3aa508e4@oldman.hamilton.local>
	<20070810201704.GI6002@1wt.eu>
	<20070810204025.GC29549@fieldses.org>
	<20070810205117.GJ6002@1wt.eu>
	<20070811141925.GA21866@fieldses.org>
	<20070811141718.GK6002@1wt.eu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
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

but if we use something richer than plain text, I think that we
shouldn't need to invent yet another markup language.
Just use HTML or asciidoc or MarkDown etc...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
