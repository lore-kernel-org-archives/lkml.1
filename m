Return-Path: <linux-kernel-owner+w=401wt.eu-S1161559AbXD2XlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161559AbXD2XlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161560AbXD2XlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:41:19 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:40230 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161559AbXD2XlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:41:17 -0400
Date: Mon, 30 Apr 2007 01:41:02 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20070429234102.GA13344@linuxtv.org>
References: <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <20070429173500.GA30248@one.firstfloor.org> <20070429223649.GA12672@linuxtv.org> <2722.81.207.0.53.1177888737.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2722.81.207.0.53.1177888737.squirrel@secure.samage.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 87.162.103.156
Subject: Re: Linux 2.6.21
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007, Indan Zupancic wrote:
> On Mon, April 30, 2007 00:36, Johannes Stezenbach wrote:
> > The lesson to learn is that there are some very valid
> > reasons why bug reports get ignored (some not mentioned here),
> > and there's nothing you can do about it. And it has nothing to
> > do with the method or tool used for reporting or tracking.
> >
> > And I also think that ignoring bad bug reports _increases_
> > the software quality, because you can use the saved time
> > working on something productive. And it makes developers
> > happier :-)
> >
> > [Just to avoid misunderstandings: By no means do I advocate
> > ignoring *every* bug report. But ignoring the bad ones
> > is just the sane thing to do.]
> 
> I don't know, but what about telling the hapless person who went
> through the process of posting a bug what's wrong with the bug report?
> Or is software quality the only thing you care about, and you don't
> want to waste time on learning people to write better bug reports?
> 
> If you want to scare away bug reporters, just ignore their first (and
> thus likely bad) bug report they write. There isn't much less motivating
> than a deafening silence. Just compare it with writing a patch.
> 
> Though, in a sense, if the software quality is measured by the number of
> bug reports, your tactic might "improve" it indeed.
> 
> That said, if someone is an obvious idiot, ignoring saves time. But I
> think that's quite rare, and in general you should give the reporter
> feedback, and then ignore the bug report. (Until it improves.)

Well, I'm a moody bastard, and I would hope other people handle
this better than I. However, all the bugzillas of this world
are full with old, ignored bugs, amd I thought this might
serve as an explanation why.

Developers are just humans and if they have no incentive to
act on a bug report they will ignore it. I think this is a
fact that you have to deal with.

It's also not necessarily the fault of the reporter if
a bug report gets ignored, but for every report a developer
has to make a decision to handle it or not, and there are
lots of reasons why he may decide to not handle it, or
at least not now (and then forget about it).

But I'm quite sure that an important bug would be reported
again until fixed.


Johannes
