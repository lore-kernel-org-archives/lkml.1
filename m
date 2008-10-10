Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbYJJSMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbYJJSMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 14:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757634AbYJJSMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 14:12:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757007AbYJJSMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 14:12:21 -0400
Date: Fri, 10 Oct 2008 11:10:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: FD Cami <francois.cami@free.fr>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Alex Howells <alex@bytemark.co.uk>,
       Nick Warne <nick@ukfsn.org>, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Documentation error: SubmittingPatches
Message-Id: <20081010111031.9518a142.akpm@linux-foundation.org>
In-Reply-To: <20081010192600.547eedcc@moria>
References: <20081010151539.6a2ff040@sauron.linicks.net>
	<48EF6B47.1080800@bytemark.co.uk>
	<20081010093427.31ddb955.randy.dunlap@oracle.com>
	<20081010192600.547eedcc@moria>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008 19:26:00 +0200 FD Cami <francois.cami@free.fr> wrote:

> On Fri, 10 Oct 2008 09:34:27 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > On Fri, 10 Oct 2008 15:48:39 +0100 Alex Howells wrote:
> > 
> > > Nick Warne wrote:
> > > > Andrews' URL seems to be AWOL
> > > > 
> > > > Documentation/SubmittingPatches: line 656
> > > > <http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt>
> > > 
> > > The URL for -mm tree bisection was also missing and he mailed me a link.
> > > Perhaps time to update the URLs generally?
> > 
> > Would one of you send a patch, please?

My zip account died for some reason.

> 
> Andrew, could you tell us where to find this now ?

http://userweb.kernel.org/~akpm/stuff/tpp.txt

> That way we could update the URLs instead of removing them.

We probably don't need the link at all - I think someone copied the
guts of that doc into SubmittingPatches.

> Also, should we change all instances of your old email addresses to the current one ?

If they're there, please just delete any email address.  People can use
the real name an an index into MAINTAINERS to find the current email
address.

