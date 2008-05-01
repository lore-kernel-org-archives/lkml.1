Return-Path: <linux-kernel-owner+w=401wt.eu-S1765484AbYEATjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765484AbYEATjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760861AbYEATjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:39:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60554 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760558AbYEATjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:39:31 -0400
Date: Thu, 1 May 2008 15:39:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Theodore Tso <tytso@MIT.EDU>, bunk@kernel.org, arjan@infradead.org,
       torvalds@linux-foundation.org, rjw@sisk.pl, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: RFC: starting a kernel-testers group for newbies
In-Reply-To: <20080501122636.152c80db.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0805011538350.12785@gandalf.stny.rr.com>
References: <20080429.190352.137408408.davem@davemloft.net>
 <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org>
 <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
 <20080501003125.GM29330@cs181133002.pp.htv.fi> <20080430000338.50548884@infradead.org>
 <20080501113038.GW29330@cs181133002.pp.htv.fi> <20080430072013.7c3b30b1@infradead.org>
 <20080501132159.GC29330@cs181133002.pp.htv.fi> <20080501084919.8ac6dbdd.akpm@linux-foundation.org>
 <20080501172434.GB17365@mit.edu> <20080501122636.152c80db.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 1 May 2008, Andrew Morton wrote:

> On Thu, 1 May 2008 13:24:34 -0400
> Theodore Tso <tytso@MIT.EDU> wrote:
>
> > ... and maybe we can't solve hardware bugs.
>
> Many, many of these are regressions.  If old-linux works on that
> hardware then new-linux can too.
>
> (still wants to know what we did 2-3 years ago which caused thousands of
> people to have to resort to using noapic and other apic-related boot option
> workarounds)

Perhaps 2-3 years ago more people started using more hardware that
implements APIC. ;-)

-- Steve

