Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbXLUXvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbXLUXvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 18:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbXLUXv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 18:51:27 -0500
Received: from relay2.sgi.com ([192.48.171.30]:48778 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752429AbXLUXv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 18:51:27 -0500
Date: Fri, 21 Dec 2007 15:51:25 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <20071221225413.GA26189@elte.hu>
Message-ID: <Pine.LNX.4.64.0712211548380.27290@schroedinger.engr.sgi.com>
References: <20071211143336.GA17866@elte.hu>
 <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>
 <20071221120908.GA15926@elte.hu> <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com>
 <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org>
 <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com>
 <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy>
 <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com>
 <20071221225413.GA26189@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2007, Ingo Molnar wrote:

> I'm really getting worried that you are apparently incapable of grasping 
> such _SIMPLE_ concepts. Who the heck cares whether you put in zeros or 
> whatever else in some of the fields? People use it to know how many 
> objects are allocated and sure SLUB knows that count, sheesh. How on 
> earth can you come up with a lame excuse like that? You dont like the 
> 'SLAB' portion of the name perhaps? Is it NIH again?

NIH? I wrote major portions of SLAB. I would be hating my own product.
Could you get the facts straight at some point? This is getting weird.

> Really, if your behavior is representative of how our SLAB allocator 
> will be maintained in the future then i'm very, very worried :-( You 
> ignore and downplay clear-cut regressions, you insult and attack 
> testers, you are incredibly stupid about user ABIs (or pretend to be so) 
> and you distort and mislead all the way. What will you be able to do in 
> the much less clear-cut cases??

I analyzed the issue and argued that the issues that one test showed in 
SLUB is a really special case and then you conclude that I ignore all 
regressions? I have addressed and responded to all reports of regressions 
that came to me.
