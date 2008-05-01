Return-Path: <linux-kernel-owner+w=401wt.eu-S1764206AbYEARUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764206AbYEARUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759410AbYEART5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:19:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758761AbYEART4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:19:56 -0400
Date: Thu, 1 May 2008 10:18:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: bunk@kernel.org, arjan@infradead.org, torvalds@linux-foundation.org,
       rjw@sisk.pl, davem@davemloft.net, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: RFC: starting a kernel-testers group for newbies
Message-Id: <20080501101826.6609dc85.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.58.0805011217200.11101@gandalf.stny.rr.com>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200804302136.58005.rjw@sisk.pl>
	<20080430131537.1f7a0914.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
	<20080501003125.GM29330@cs181133002.pp.htv.fi>
	<20080430000338.50548884@infradead.org>
	<20080501113038.GW29330@cs181133002.pp.htv.fi>
	<20080430072013.7c3b30b1@infradead.org>
	<20080501132159.GC29330@cs181133002.pp.htv.fi>
	<20080501084919.8ac6dbdd.akpm@linux-foundation.org>
	<Pine.LNX.4.58.0805011217200.11101@gandalf.stny.rr.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 12:38:23 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:

> People here mention differnt places to look at code, and besides the
> kerneloops.org I really don't even know where to look for bugs, because I
> haven't seen a URL to point me to.

bugzilla.kernel.org is, umm, improving.

It would be an intersting exercise for someone to spend a few days seeing
how many of the bugzilla reports they personally can reproduce.  I'd guess
"zero".  There's a lesson in that.

The problem with bugzilla will be that it will be hard to find reports
where the reporter will be able to work with you on the fix - we've let
them go cold.

The most fruitful place to find fixable bugs is linux-kernel.  People who
report bugs there are sufficiently motivated to have actually sent the
email and the bug is still recent, so they probably haven't done the
Solaris install yet.

