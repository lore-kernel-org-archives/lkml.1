Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbXD2SJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbXD2SJN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 14:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbXD2SJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 14:09:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50807 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbXD2SJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 14:09:12 -0400
Date: Sun, 29 Apr 2007 20:09:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Adrian Bunk <bunk@stusta.de>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070429180909.GA30604@one.firstfloor.org>
References: <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk> <20070428224904.GE3468@stusta.de> <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <20070429173500.GA30248@one.firstfloor.org> <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  - a lot of reporters will not use bugzilla, because it's damn 
>    inconvenient even for reporting. If you propose something that uses 

Don't think that's true. There are plenty of projects who only
accept bugs through bugzilla (mozilla, various distributions, etc.) 
and I don't see any evidence of your claim being true.

Sure there will be always people who cannot be bothered
to use any kind of interface for bugs, but then
these are unlikely to stay on board during a longer 
remote debugging q'n'a session either. So those people
can be just ignored; they essentially don't exist in
the bug report universe.

Anyways it only works if people are willing to use it too and there
are enough people who maintain bugs (aka ask questions to find out
who to reassign, prune old bugs etc.)  If that's not there then
it won't work well obviously, like it is currently the case.

I don't think the "keep it in Andrew's/Adrian's head" method
is going to scale longer term at least (and one of them has 
already thrown in the towel) 

The "send it to a gigantic mailing list and hope someone catches
it" method also doesn't seem to be that great. At least there
are lots of lost reports in my experience this way.

I suspect the real reason is more "Linus doesn't like web interfaces
for no particular good reason". Not much can be done about that.
Well perhaps someone can write a gopher based bugzilla interface 
or something to solve that instead @)

-Andi
