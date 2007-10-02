Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbXJBEtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbXJBEtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 00:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbXJBEt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 00:49:26 -0400
Received: from 1wt.eu ([62.212.114.60]:2765 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbXJBEtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 00:49:25 -0400
Date: Tue, 2 Oct 2007 06:48:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Patches for tiny 386 kernels, again. Linux kernel   2.6.22.7
Message-ID: <20071002044820.GN10199@1wt.eu>
References: <46F77A85.6020202@nerdgrounds.com> <20070924104940.50a52cf3.randy.dunlap@oracle.com> <46FD7104.9070609@tmr.com> <20071001134405.GA16330@csclub.uwaterloo.ca> <4701040E.1050604@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4701040E.1050604@tmr.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 10:28:30AM -0400, Bill Davidsen wrote:
> Lennart Sorensen wrote:
> >On Fri, Sep 28, 2007 at 05:24:20PM -0400, Bill Davidsen wrote:
> >  
> >>I'll offer this suggestion, knowing it may piss you off, given the 
> >>difficulty of preserving whitespace on *many* mailers without using 
> >>attachments, and given that attachments can be saved easily without 
> >>prying them out of the message, why don't you (one person) switch to a 
> >>capable mail agent, if only for patches, instead of trying to teach many 
> >>people to jump through hoops to avoid whitespace issues?
> >>
> >>Not criticizing, just seems easier for everybody for you to avoid 
> >>teaching people things they don't find useful elsewhere, or getting 
> >>discouraged and not bothering.
> >>    
> >
> >Ehm, so you want people to save the patch, then when replying they
> >should load the patch into their (much better) mail client where they
> >can comment on the patch?  That is the reason the patch should be
> >inline.  People need to comment on it just as they would comment on any
> >other plain text email.
> >  
> 
> And in a perfect world everyone would have a mail client which made that 
> easy, no one would be force by company policy or other circumstances to 
> use a client which didn't work the way you think it should, no company 
> or ISP would filter and mangle outgoing mail, and all vendors would 
> understand that pristine patches are more important that all that stuff 
> they do to make business communications look reasonable.
> 
> In my world people send me attachments so they don't get mangled, and if 
> I need to quote them I know how to do so.
> >Well that and some people use git to import patches from the email in a
> >mostly automated way which also expects them to have the info at top
> >with signed-off and then the patch, which attachments also screw up.
> >
> >So yes there are good reasons for getting a non broken mail client when
> >sending patches to lkml.
> >  
> 
> And reading them, many show attached text at the end of the message and 
> make turning it into inline text simple.

Hey, if the poster knows his mail client is broken, nothing prevents him
from attaching the patches (so that they don't get mangled) and at the
same time inline them for an easy review. People who review patches won't
bother about spaces or tabs when you indicate to them from the beginning
that the patch may have been mangled.

Willy

