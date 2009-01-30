Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbZA3Vrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbZA3Vrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 16:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZA3Vrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 16:47:43 -0500
Received: from corsair.crowder-design.com ([207.44.208.58]:56994 "EHLO
	corsair.crowder-design.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753175AbZA3Vrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 16:47:42 -0500
X-Greylist: delayed 2156 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Jan 2009 16:47:42 EST
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging
	adjacent	VM_LOCKED file segments
From: Will Crowder <will@crowder-design.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1233349152.908.56.camel@lts-notebook>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>
	 <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>
	 <1233259410.2315.75.camel@lts-notebook>
	 <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
	 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>
	 <bb4a86c70901291447k5c5e90cfg34877b745825f5e2@mail.gmail.com>
	 <alpine.LFD.2.00.0901291806340.3054@localhost.localdomain>
	 <20090130055639.GA30950@suse.de>
	 <alpine.LFD.2.00.0901300811260.3150@localhost.localdomain>
	 <Pine.LNX.4.64.0901301724010.1563@blonde.anvils>
	 <alpine.LFD.2.00.0901300946360.3150@localhost.localdomain>
	 <1233345190.908.36.camel@lts-notebook>  <498368D2.6090307@oracle.com>
	 <1233349152.908.56.camel@lts-notebook>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 13:11:03 -0800
Message-Id: <1233349863.5557.335.camel@enterprise.crowder-design.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-41.el4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What, no ".linux" TLD?  :-)  Oh well...in time, time...

Will Crowder

On Fri, 2009-01-30 at 15:59 -0500, Lee Schermerhorn wrote:
> On Fri, 2009-01-30 at 12:53 -0800, Randy Dunlap wrote:
> > Lee Schermerhorn wrote:
> > 
> > > I tried this patch atop 29-rc3 + your patch from yesterday with my
> > > simple test program at http://free.linux/hp.com/~lts/Tests/mmap_lock.c. 
> 
> D'oh!  that's ".hp.com"  
> 
> > Is that URL correct?  I can't find/access it.
> 
> Sorry, should have cut and pasted, like here:
> 
> 	http://free.linux.hp.com/~lts/Tests/mmap_lock.c
> 
> 
> Lee
> 

