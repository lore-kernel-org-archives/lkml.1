Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbXKNBwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbXKNBwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbXKNBwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:52:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56014 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbXKNBwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:52:12 -0500
Date: Wed, 14 Nov 2007 02:52:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Philip Mucci <mucci@cs.utk.edu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Stephane Eranian <eranian@hpl.hp.com>,
       William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Perfmon <perfmon@napali.hpl.hp.com>,
       perfmon2-devel@lists.sourceforge.net,
       papi list <ptools-perfapi@cs.utk.edu>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071114015210.GA20365@one.firstfloor.org>
References: <20071109213829.GC28276@kroah.com> <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org> <20071113203645.GA17145@one.firstfloor.org> <9FF72994-F55A-4B36-9EAA-CB1D2360A6F5@cs.utk.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9FF72994-F55A-4B36-9EAA-CB1D2360A6F5@cs.utk.edu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 04:28:52PM -0800, Philip Mucci wrote:
> I know you don't want to hear this, but we actually use all of the  
> features of perfmon, because a) we wanted to use the best methods  

That is hard to believe.

But let's go for it temporarily for the argument. 

Can you instead prioritize features.  What is most essential, what is 
important, what is just nice to have, what is rarely used? 

> Note that PAPI is just middleware. The tools built upon it are what  

Surely the tools on top cannot use more than the middleware provides.

> 	- providing virtualized 64-bit counters per-thread
> 	- providing notification (buffered or non) on interrupt/overflow of  
> the above.

Ok that makes sense and should be possible with a reasonable simple
interface.

> If you'd like to outline further what you'd like to hear from the  
> community, I can arrange that. I seem to remember going through this  
> once before, but I'd be happy to do it again. For reference, here's a  
> quick list from memory of some of the tools in active use and built  
> on this infrastructure. These are used heavily around the globe.  

Please list concrete features, throwing around random names is not useful.

-Andi

