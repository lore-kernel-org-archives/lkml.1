Return-Path: <linux-kernel-owner+w=401wt.eu-S1763513AbYBBPSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763513AbYBBPSF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 10:18:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbYBBPRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 10:17:54 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:65154 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbYBBPRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 10:17:54 -0500
Date: Sat, 2 Feb 2008 10:17:20 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] add support for dynamic ticks and preempt rcu
In-Reply-To: <20080202090113.GA17348@elte.hu>
Message-ID: <Pine.LNX.4.58.0802021014500.6971@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0802020123070.21975@gandalf.stny.rr.com>
 <20080202090113.GA17348@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2 Feb 2008, Ingo Molnar wrote:
>
> i've added it a few days ago and it's already in the sched-devel.git
> tree:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git


OK, thanks! I know everyone is extremely busy now and I just wanted to
make sure this didn't fall between the cracks.

-- Steve

