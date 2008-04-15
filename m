Return-Path: <linux-kernel-owner+w=401wt.eu-S932979AbYDOVqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932979AbYDOVqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759949AbYDOVqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:46:34 -0400
Received: from citi.umich.edu ([141.211.133.111]:10342 "EHLO citi.umich.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758338AbYDOVqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:46:33 -0400
Date: Tue, 15 Apr 2008 17:46:32 -0400 (EDT)
From: "david m. richter" <richterd@citi.umich.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>, hch@infradead.org,
       bunk@kernel.org, dwmw2@infradead.org, miklos@szeredi.hu,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
In-Reply-To: <20080415205819.6340baa3@the-village.bc.nu>
Message-ID: <Pine.BSO.4.64.0804151651500.12362@citi.umich.edu>
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org>
 <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org>
 <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
 <1208121358.2700.4.camel@shinybook.infradead.org>
 <20080413154459.4b2f125d.akpm@linux-foundation.org> <20080413234920.63711ca7@core>
 <20080413161014.cb06964c.akpm@linux-foundation.org>
 <20080415151643.GD2454@cs181133002.pp.htv.fi> <20080415165727.GA8783@infradead.org>
 <20080415113452.e9eacb54.akpm@linux-foundation.org> <20080415195330.17f63348@the-village.bc.nu>
 <20080415130240.1b9b7662.akpm@linux-foundation.org> <20080415205819.6340baa3@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008, Alan Cox wrote:
<snip>

> > > This is a free software project not a business enterprise.
> > 
> > And the same principles apply, don't they?  We seek to minimise overhead
> > and to use our kernel development hours as effectively as we can.
> 
> One word if we are getting into the economics of this: Externalities.
> There are lots of benefits from merging the code beyond simple value of
> code merge including more developers, more reference code, more users.
> The ratio of new contributions to maintenance is a different problem and
> one I do not think should be conflated with it.
> 
> But yes I do think they are different - free software is largely done for
> fun, by people who want to contribute. What was it John Betjeman said of
> another large volunteer project:
> 
> "the result of the independent spirit which still survives in this
> country and refuses to be crushed by the money-worshippers, centralizers
> and the unimaginative theorists who are doing their best to kill it"
> 
> Alan

	to interject, and in response to a variety of posts in this thread 
and in no way drawing solely on yours, alan: despite that it may sound 
like some interesting viewpoints are getting aired here, i think the 
discussion may've unproductively slewed to a point where andrew's 
unfortunately been painted into a corner in which he has little practical 
interest.

	it seems like some folks have misinterpreted andrew's remarks as 
being variously inflexible, elitist, "political", pro-"corporate-drone", 
working at cross-purposes to the spirit of open source, and otherwise.  
in rereading the thread, though, he's pretty much been the most 
even-handed, moderate, practical, and open to discussion and compromise of 
anyone involved.

	he gave an opinion about the merits of OMFS in-kernel vs FUSE, 
clarified his stance, remained open to other's comments and criticism, 
didn't rise to any bait when people called his ideas "stupid" and whatnot 
(despite that he specifically said he had "no strong opinions either 
way"), and he compromised: he offered to pull the code into -mm; he said 
he'd merge v4.

	known: OMFS has a few bugs (thanks, reviewers), needs testing, and 
has outstanding legal questions to resolve.  andrew offered to merge the 
next version.

	to ground the topic in terms of practicality: what else would all 
of you have andrew do, at this moment, that he hasn't already done?  can 
we let him get back to work?


	thanks,

	d
	.
