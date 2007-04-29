Return-Path: <linux-kernel-owner+w=401wt.eu-S1161584AbXD2X4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161584AbXD2X4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161598AbXD2X4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:56:01 -0400
Received: from thunk.org ([69.25.196.29]:34622 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161584AbXD2Xz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:55:59 -0400
Date: Sun, 29 Apr 2007 19:55:35 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070429235535.GC19937@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk> <20070428224904.GE3468@stusta.de> <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73d51n1fup.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 03:15:42PM +0200, Andi Kleen wrote:
> This means we need people who figure out who to assign bugs too.
> Aka bugmasters.
> 
> BTW one big problem in our current bugzilla is that a lot of people
> cannot reassign bugs they don't own. I sometimes see bugs that I don't
> own bug I know who is responsible, but bugzilla doesn't allow me to do it.
> 
> So I think what would help:
> 
> - Ask more people to just categorize and reassign bugs (anybody interested?)
> - Give more people in bugzilla the power to reassign arbitary bugs
> (bugzilla maintainers would need to do that)

Folks might want to take a look at the Debian Bug Tracking System
(BTS).  It has a web interface which you can use to query history, but
*everything* is e-mail driven, and the way you submit, close, update,
tag/classfy bugs --- everything --- is via e-mail.

More importantly, anyone is allowed to recategorize and reassign bugs.
If someone does so maliciously or incorrectly, you can always revert
it, and if someone is being truly malicious, you can always blacklist
that one person.  It this respect, it is far more wiki-like than
bugzilla, which has always been too much like a straightjacket.

It's not perfect, but it's better than bugzilla --- but then again,
just about *anything* would be better than bugzilla.  (Hmm, except
maybe SourceForge's very tragic bug tracking system... :-)

Of course, as Linus has said, it's not a complete solution --- you
still need humans to be smart about things --- but if the goal is to
make it easier to archive and track information about a bug, at
*least* with the Debian BTS, when you reply to an e-mail message, the
reply is automatically appended to the bug log!
	
						- Ted
