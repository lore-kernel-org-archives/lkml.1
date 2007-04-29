Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXD2Rr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXD2Rr3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965085AbXD2Rr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:47:28 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58414 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964934AbXD2RrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:47:24 -0400
Date: Sun, 29 Apr 2007 10:47:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <20070429173500.GA30248@one.firstfloor.org>
Message-ID: <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org>
References: <20070426201325.8a1ebda3.diegocg@gmail.com>
 <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
 <20070426224148.69b91b2e.diegocg@gmail.com>
 <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
 <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk>
 <20070428224904.GE3468@stusta.de> <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org>
 <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
 <20070429173500.GA30248@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Apr 2007, Andi Kleen wrote:
> On Sun, Apr 29, 2007 at 09:07:43AM -0700, Linus Torvalds wrote:
> >
> > Yes. But not using bugzilla.
> 
> And what would you use instead? 

Didn't you even *read* my email?

I already told you: we have real bugs getting reported and fixed that 
don't hit bugzilla or any bugtracker AT ALL.

This is not a "all or nothing" situation. There is absolutely _zero_ real 
reason to think that everything has to go through bugzilla.

> > I don't know if you've noticed already, but I'm not the only one that 
> > doesn't have a very high opinon of bugzilla ;)
> 
> Sure, but do you have alternatives? 

Yes. The ones that *work*. Plain email is preferably over bugzilla 90% of 
the time. 

But quite frankly, if you think you can make bugzilla work (and realize 
that a lot of people will _not_ be looking at it or reporting bugs into 
it), go ahead. I don't care. The only think I care about is *REALITY*, and 
that means:

 - a lot of reporters will not use bugzilla, because it's damn 
   inconvenient even for reporting. If you propose something that uses 
   _only_ bugzilla, you'd better also have the people who enter other 
   peoples bugreports into there.

 - a lot of developers will not use bugzilla, because it's even more 
   inconvenient for developers, with no sane ways to interact with the 
   right people. So if you propose using bugzilla, you'd really better 
   have the manpower to turn bugzilla into emails (and no, the bugzilla 
   cc list etc is _not_ the primary one - the email cc's are the primary 
   ones, because that's where it is much easier to bring in new people)

In other words, anything that thinks that bugzilla is "primary" is just 
broken. It can be a _part_ of the thing, but drop the belief of it being a 
primary tracker. It's just too inconvenient.

		Linus
