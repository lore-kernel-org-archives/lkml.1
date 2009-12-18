Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbZLRRMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbZLRRMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932195AbZLRRMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:12:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbZLRRMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:12:45 -0500
Date: Fri, 18 Dec 2009 12:12:34 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Alasdair G Kergon <agk@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       Joe Perches <joe@perches.com>, Valdis.Kletnieks@vt.edu,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] Re: [PATCH] scripts/checkpatch.pl: Change long line
 warning to 105 chars
In-Reply-To: <20091218085858.029c5660.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0912181210130.3223@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
 <20091217061229.GD3946@linux-sh.org> <m3tyvqgfs4.fsf@intrepid.localdomain>
 <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
 <24653.1261110557@localhost> <1261113144.13734.317.camel@Joe-Laptop.home>
 <m3iqc41h83.fsf@intrepid.localdomain> <20091218151241.GD9334@agk-dp.fab.redhat.com>
 <20091218085858.029c5660.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Dec 2009, Randy Dunlap wrote:

> On Fri, 18 Dec 2009 15:12:41 +0000 Alasdair G Kergon wrote:
> 
> > On Fri, Dec 18, 2009 at 03:37:00PM +0100, Krzysztof Halasa wrote:
> > > Not sure if that's long enough (maybe it is).
> > > 132 looks like the next "natural" number.
> > 
> > Well it's good that this thread has produced more examples where it's
> > reasonable and acceptable to exceed 80 characters.
> > 
> > What do people feel about files where the policy is to place all the
> > parameters passed into a function on the same line, regardless of its
> > consequent length?  
> 
> Not good IMO.  It's much easier to read something that is restricted in
> width than to have to scroll/pan side to side.
> (e.g., newspaper columns.  Oops, what's a newspaper?)

I don't like scrolling too but most viewers and editors wrap it 
automatically to screen width. For example, restrict your terminal to 50 
columnts and try using "less".

Mikulas
