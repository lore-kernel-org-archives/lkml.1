Return-Path: <linux-kernel-owner+w=401wt.eu-S1161625AbXD3AeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161625AbXD3AeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 20:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161629AbXD3AeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 20:34:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:40370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161625AbXD3AeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 20:34:19 -0400
To: Theodore Tso <tytso@mit.edu>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <4630DB24.4030005@redhat.com>
	<20070426201325.8a1ebda3.diegocg@gmail.com>
	<alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
	<20070426224148.69b91b2e.diegocg@gmail.com>
	<alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
	<20070428195320.GZ3468@stusta.de>
	<20070428202701.GA30343@flint.arm.linux.org.uk>
	<20070428224904.GE3468@stusta.de>
	<alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org>
	<p73d51n1fup.fsf@bingen.suse.de> <20070429235535.GC19937@thunk.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 30 Apr 2007 03:31:46 +0200
In-Reply-To: <20070429235535.GC19937@thunk.org>
Message-ID: <p731wi21wcd.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> writes:
> 
> Folks might want to take a look at the Debian Bug Tracking System
> (BTS).  It has a web interface which you can use to query history, but
> *everything* is e-mail driven, and the way you submit, close, update,
> tag/classfy bugs --- everything --- is via e-mail.

Bugzilla can do that too. But I'm not convinced this is a good idea.
We had this some years ago with the jitterbug experiment and usually
it tended to faithfully keep track of very long off topic threads
that had drifted long from the original bug. The resulting collections
of emails usually not very useful.

While other interfaces might be a culture shock for some people
at least they force them to concentrate on the particular issue --
contribute to a specific bug.

-Andi
