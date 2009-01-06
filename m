Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZAFWgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZAFWgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbZAFWR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:17:58 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58878 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509AbZAFWR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:17:57 -0500
Date: Tue, 6 Jan 2009 14:17:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [RFC, PATCH] kernel/rcu: add kfree_rcu
Message-ID: <20090106221755.GA19457@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200901021159.n02BxDLg024728@mail.q-ag.de> <20090102185543.GE6842@linux.vnet.ibm.com> <49604E19.8040502@cn.fujitsu.com> <20090104194851.GM6958@linux.vnet.ibm.com> <496174EB.4030601@cn.fujitsu.com> <20090105044023.GC8080@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105044023.GC8080@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 08:40:23PM -0800, Paul E. McKenney wrote:
> On Mon, Jan 05, 2009 at 10:48:11AM +0800, Lai Jiangshan wrote:
> > Paul E. McKenney wrote:
> > > 
> > > In any case, I do apologize -- since I didn't see anything from you I
> > > incorrectly assumed that you had given up on this patch.  Please accept
> > > my apologies!
> > 
> > It's my fault.
> > 
> > I'm a very low-yield developer.
> 
> Well, I am certainly not the highest-yield developer around, and I have
> probably put in at least 30,000 hours of programming over the past 35
> years, and probably half of those between 1981 and 1985.  Of course,
> a fair fraction of those hours were in languages and environments that
> are pretty much irrelevant these days.  Nevertheless, my guess is that
> you need to invest about 10,000 hours to really master programming, which
> works out to about five years at 40 hours per week of doing nothing but
> designing, coding, and debugging.
> 
> So please don't give up!

Two more things:

1.	I believe that reviewing code counts towards the 10,000 hours.
	Just in case you were curious.  ;-)

2.	To help prevent more collisions, I have posted a rough RCU
	to-do list at:

	http://www.kernel.org/pub/linux/kernel/people/paulmck/rcutodo.html.

							Thanx, Paul
