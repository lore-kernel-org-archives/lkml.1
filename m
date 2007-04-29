Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbXD2DEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbXD2DEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 23:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbXD2DEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 23:04:37 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262AbXD2DEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 23:04:36 -0400
Date: Sat, 28 Apr 2007 20:03:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Brown <neilb@suse.de>
Cc: "Martin J. Bligh" <mbligh@mbligh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-Id: <20070428200353.c6638cca.akpm@linux-foundation.org>
In-Reply-To: <17971.50834.907414.761549@notabene.brown>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
	<20070426040806.GJ3468@stusta.de>
	<20070426125802.GL3468@stusta.de>
	<alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
	<4630DB24.4030005@redhat.com>
	<20070426201325.8a1ebda3.diegocg@gmail.com>
	<alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
	<20070426224148.69b91b2e.diegocg@gmail.com>
	<alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
	<46339BC7.6050802@mbligh.org>
	<17971.50834.907414.761549@notabene.brown>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007 08:11:30 +1000 Neil Brown <neilb@suse.de> wrote:

> On Saturday April 28, mbligh@mbligh.org wrote:
> > 
> > Yes, human involvement from someone with half a brain would be better.
> > Andrew does a lot of that. Not a particularly good use of talent really.
> > but still.
> 
> I think more than half a brain is needed to do this well.  You need a
> reasonable understanding of how all the bits of the kernel work
> together so that you have a good chance of sending the bug in the right
> direction.  You need a good understanding of the kernel community and
> various sub communities so that you know who might be both able and
> willing to deal with the bug.  And it wouldn't hurt to have a good
> over-view of the current 'hot' areas of the kernel so you know if it
> is really worth suggesting "try with the latest -mm" or not.
> And you need good people skills.
> 
> So I think you really need a lot of up-to-date knowledge to do this
> well.  Because of Andrew's position as a funnel, he has a lot of that
> knowledge.

yup

>  It would be really nice if he had some help though.

Amen, Brother Neil.

>  And I
> really think that would mean finding someone in the community who
> would rather be coding (and currently are) and convincing them that
> there is a higher calling for them.  Finding someone out side or on
> the edge of the community is less likely to be effective.

	http://www.google.com/support/jobs/bin/answer.py?answer=53317

This is a fully funded regular full-time position @google's Mountain View
HQ, sitting within nagging range of myself, doing precisely what you
describe.

Unfortunately the recruiting has been a bit tricky - this is not a typical
job and it's a funny mixture of bureaucracy/politics/social engineering
and programming.  People who are skilled in both areas, are, ah, uncommon.
But it will happen eventually.

Meanwhile I

- ensure that all bugzilla reports are routed to the relevant maintainer

- ensure that all those who reported bugs via email are later asked to
  raise bugzilla reports if it didn't get fixed (but I only monitor one list!)

- continue to file away all the real-looking bugzillas with the intention
  of generating aggregated reports, but you know how it is.

