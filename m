Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbXEBKOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbXEBKOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 06:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755000AbXEBKOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 06:14:52 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:32839 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991AbXEBKOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 06:14:51 -0400
Date: Wed, 2 May 2007 06:14:32 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: "Robert P. J. Day" <rpjday@mindspring.com>, Valdis.Kletnieks@vt.edu,
       Andre Tomt <andre@tomt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: so ... what *are* candidates for removal?
In-Reply-To: <46385EF8.8040005@s5r6.in-berlin.de>
Message-ID: <alpine.DEB.0.98.0705020612290.9993@sigma.j-a-k-j.com>
References: <Pine.LNX.4.64.0705011050080.11853@localhost.localdomain>      
      <46375D1C.4050404@tomt.net> <10590.1178037443@turing-police.cc.vt.edu>
 <4637C04E.4070306@s5r6.in-berlin.de> <Pine.LNX.4.64.0705020418530.7102@localhost.localdomain>
 <46385EF8.8040005@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Regarding features that are overdue for removal according to
> >> feature-removal-schedule.txt:
> >>
> >> I remember that at least one person used to watch for due dates for
> >> feature removal, wrote the removing patches, and sent them to the
> >> appropriate lists and maintainers.  This either got rid of the
> >> obsolete stuff, or it turned up reasons why some feature could not
> >> be removed just yet and how to update feature-removal-schedule.txt
> >> to correctly reflect that.
> >>
> >> So, as they say, Patches Are Welcome.
> > 
> > that's a nice idea, but it doesn't address the problem that someone
> > might go to the trouble to create such a patch and send it in, only to
> > have that submission generate shrieking along the lines of "OHMIGOD,
> > we can't delete that *yet*!!!"
> 
> You are absolutely right.
> 
> We have to try to avoid this waste of resources when we put features
> into feature-removal-schedule.txt.  That's what I meant with "the hard
> part" in the other post.
> 
> BTW, of course it doesn't suffice to say "we can't remove it yet" after
> the due day.  There need to be well-founded reasons for another
> deferral.  Of course if there are such reasons, it means something went
> wrong when the feature was put into removal schedule.  (Some facts
> weren't known.)

So when this sort of thing comes up, why can't somebody put together a 
trivial patch to update feature-removal-schedule.txt? If a deadline is 
reached, and a removal is attempted and aborted, the deadline should be 
extended, obviously. So then the patches can be resubmitted (or recreated, 
even) when the new deadline is reached, da capo.
