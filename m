Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbXEBK7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbXEBK7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993044AbXEBK67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:58:59 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37751 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbXEBK66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:58:58 -0400
X-Originating-Ip: 72.143.66.196
Date: Wed, 2 May 2007 06:58:15 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Valdis.Kletnieks@vt.edu,
       Andre Tomt <andre@tomt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: so ... what *are* candidates for removal?
In-Reply-To: <alpine.DEB.0.98.0705020612290.9993@sigma.j-a-k-j.com>
Message-ID: <Pine.LNX.4.64.0705020653560.7971@localhost.localdomain>
References: <Pine.LNX.4.64.0705011050080.11853@localhost.localdomain>      
      <46375D1C.4050404@tomt.net> <10590.1178037443@turing-police.cc.vt.edu>
 <4637C04E.4070306@s5r6.in-berlin.de> <Pine.LNX.4.64.0705020418530.7102@localhost.localdomain>
 <46385EF8.8040005@s5r6.in-berlin.de> <alpine.DEB.0.98.0705020612290.9993@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, John Anthony Kazos Jr. wrote:

> stefan richter wrote:

> > We have to try to avoid this waste of resources when we put
> > features into feature-removal-schedule.txt.  That's what I meant
> > with "the hard part" in the other post.
> >
> > BTW, of course it doesn't suffice to say "we can't remove it yet"
> > after the due day.  There need to be well-founded reasons for
> > another deferral.  Of course if there are such reasons, it means
> > something went wrong when the feature was put into removal
> > schedule.  (Some facts weren't known.)
>
> So when this sort of thing comes up, why can't somebody put together
> a trivial patch to update feature-removal-schedule.txt? If a
> deadline is reached, and a removal is attempted and aborted, the
> deadline should be extended, obviously. So then the patches can be
> resubmitted (or recreated, even) when the new deadline is reached,
> da capo.

argh.  the whole point of this discussion is to come to a *consensus*
on what should be in that feature removal file.  there is no point in
creating and submitting patches, either to update that file or remove
kernel features, until enough people *agree*.

at the risk of being head-bangingly repetitive, that's what the wiki
page is for:

http://fsdev.net/wiki/index.php?title=Stuff_to_be_removed

go.  read.  comment.  update.  add.  remove.  it's a wiki.  don't make
me pull this car over and explain it.  :-)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
