Return-Path: <linux-kernel-owner+w=401wt.eu-S1763556AbYEAQie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763556AbYEAQie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759675AbYEAQi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:38:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55785 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759982AbYEAQiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:38:25 -0400
Date: Thu, 1 May 2008 12:38:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: RFC: starting a kernel-testers group for newbies
In-Reply-To: <20080501084919.8ac6dbdd.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0805011217200.11101@gandalf.stny.rr.com>
References: <20080429.190352.137408408.davem@davemloft.net>
 <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org>
 <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org>
 <20080501003125.GM29330@cs181133002.pp.htv.fi> <20080430000338.50548884@infradead.org>
 <20080501113038.GW29330@cs181133002.pp.htv.fi> <20080430072013.7c3b30b1@infradead.org>
 <20080501132159.GC29330@cs181133002.pp.htv.fi> <20080501084919.8ac6dbdd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 1 May 2008, Andrew Morton wrote:
>
> Arjan's fourth fallacy: "We don't make (effective) prioritization
> decisions." lol.  This implies that someone somewhere once sat down and
> wondered which bug he should most effectively work on.  Well, we don't do
> that.  We ignore _all_ the bugs in favour of busily writing new ones.

And actually, core kernel developers are best for writing new bugs.

Really, the way I started out learning how the kernel ticks was to go and
try to solve some bugs that I was seeing (this was years ago). I get
people asking that they want to learn to be a kernel developer and they
ask what new feature should they work on? Well, honestly, the last thing
a newbie kernel developer should be doing is writing new bugs. We need to
send them to a URL that lists all the known bugs and have them pick one,
any one, and have them solve it. This would be the best way to learn part
of the kernel.

I even find that I understand my own code better when I'm in the debugging
phase.

People here mention differnt places to look at code, and besides the
kerneloops.org I really don't even know where to look for bugs, because I
haven't seen a URL to point me to.

The next time someone asks me how to get started in kernel programming, I
would love to tell them to go and look here, and solve the bugs. I'm
guessing that I should just point them to:

  http://janitor.kernelnewbies.org/

and tell them to focus on real bugs (not just comments and such) to get
fixed if they really want to learn the kernel.

-- Steve

