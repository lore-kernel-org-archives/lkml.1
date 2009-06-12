Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbZFLOUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbZFLOUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbZFLOUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:20:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:57812 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbZFLOUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:20:32 -0400
Subject: Re: linux-next: origin tree build failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <20090612140730.GJ32105@elte.hu>
References: <20090612102427.32582baa.sfr@canb.auug.org.au>
	 <1244768406.7172.1.camel@pasglop> <20090612092054.GB32052@elte.hu>
	 <1244799197.7172.106.camel@pasglop> <20090612125335.GH31845@elte.hu>
	 <1244812224.7172.146.camel@pasglop> <20090612134428.GC32105@elte.hu>
	 <1244814976.7172.164.camel@pasglop>  <20090612140730.GJ32105@elte.hu>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 00:19:58 +1000
Message-Id: <1244816398.7172.172.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Uhm, the bug you are making a big deal of would have been found and 
> fixed by Paulus a few hours after any such mail - and probably by me 
> too as i do daily cross builds to Power.
> 
> So yes, we had a bug, but any extra linux-next hoops would not have 
> prevented it: i could still have messed up by getting lured by that 
> nice piece of Power7 hardware enablement patch on the last day ;-)
> 
> So the bug was my fault for being too fast-and-loose with that 
> particular patch, creating a ~5-commits-hop build breakage bisection 
> window on Power.
> 
> Now that i'm sufficiently chastised, can we now move on please? :)

Sure we can :-) My point is, get a break before you merge upstream :-)

Cheers,
Ben.


