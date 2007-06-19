Return-Path: <linux-kernel-owner+w=401wt.eu-S1757697AbXFSOnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697AbXFSOnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbXFSOnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:43:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41984 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbXFSOnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:43:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Martin Bligh <mbligh@mbligh.org>
Subject: Re: regression tracking (Re: Linux 2.6.21)
Date: Tue, 19 Jun 2007 16:49:43 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Verych <olecom@flower.upol.cz>, Adrian Bunk <bunk@stusta.de>,
       Andi Kleen <andi@firstfloor.org>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070426040806.GJ3468@stusta.de> <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org> <46772321.9080602@mbligh.org>
In-Reply-To: <46772321.9080602@mbligh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706191649.44806.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 19 June 2007 02:28, Martin Bligh wrote:
> Linus Torvalds wrote:
> > 
> > On Thu, 14 Jun 2007, Oleg Verych wrote:
> >> I'm seeing this long (198) thread and just have no idea how it has
> >> ended (wiki? hand-mailing?).
> > 
> > I'm hoping it's not "ended".
> > 
> > IOW, I really don't think we _resolved_ anything, although the work that 
> > Adrian started is continuing through the wiki and other people trying to 
> > track regressions, and that was obviously something good.
> > 
> > But I don't think we really know where we want to take this thing in the 
> > long run. I think everybody wants a better bug-tracking system, but 
> > whether something that makes people satisfied can even be built is open. 
> > It sure doesn't seem to exist right now ;)
> 
> I know you hate bugzilla ... but at least I can try to make that bit
> of the process work better.
> 
> The new version just rolled out does have a simple "regression" checkbox
> (and you can search on it), which will hopefully help people keep track
> of the ones already in bugzilla more easily.
> 
> Thanks to Jon T, Dave J et al. for helping to figure out methods and
> implement them.

Yes, good work, thanks a lot for it!  The new interface is much better and more
useful.

Greetings,
Rafael


PS
BTW, would that be possible to create the "Hibernation/Suspend" subcategory
of "Power Management" that I asked for some time ago, please? :-)

-- 
"Premature optimization is the root of all evil." - Donald Knuth
