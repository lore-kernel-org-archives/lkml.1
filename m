Return-Path: <linux-kernel-owner+w=401wt.eu-S1161404AbXD2VYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161404AbXD2VYy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161395AbXD2VYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:24:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161404AbXD2VYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:24:53 -0400
Date: Sun, 29 Apr 2007 14:24:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Diego Calleja <diegocg@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <20070429210505.GS3468@stusta.de>
Message-ID: <alpine.LFD.0.98.0704291419310.9964@woody.linux-foundation.org>
References: <20070428224904.GE3468@stusta.de>
 <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org>
 <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org>
 <20070429173500.GA30248@one.firstfloor.org>
 <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org>
 <20070429180909.GA30604@one.firstfloor.org> <20070429214007.9ea12e96.diegocg@gmail.com>
 <20070429201729.GQ3468@stusta.de> <alpine.LFD.0.98.0704291330280.9964@woody.linux-foundation.org>
 <20070429210505.GS3468@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Apr 2007, Adrian Bunk wrote:
> > 
> > Kernel bugzilla has 1600 open bugs BECAUSE IT SUCKS.
> 
> OK, how do you suggest to track bugs in a way that doesn't suck?

I've tried to explain.

Bugzilla can be one _part_ of it, but anybody who thinks it's the "main 
part" is really not being realistic. It's too cumbersome, and it's too 
stupid. 

Quite frankly, "lkml + google" is probably in many ways a *better* way to 
search for problems. But yes, some manual smarts (and the _occasional_ 
pointer to bugzilla) is probably currently the only option.

Exactly because I don't think anybody has shown any better automation than 
bugzilla. But that doesn't make bugzilla "the One Choice". That's not how 
it works. If there is no automation, manual tracking is still better than 
*crap* automation.

> Bug reports to linux-kernel have the big problem that they are lost if 
> no developer immediately picks them up.

..and this is different from bugzilla exactly _how_?

Those things are lost too. As you yourself have pointed out. The fact that 
you can search for them is _exactly_ as relevant as the fact that you can 
search for lkml on google.

> What I do know is that the majority of them has never been proper 
> debugged by a kernel developer knowing the subsystem in question.

And you blame the developers, but not bugzilla? Why are you so unable to 
see bugzilla as part of the *cause* of the problem? You're perfectly happy 
to blame other things, but bugzilla is somehow above blame?

		Linus
