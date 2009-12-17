Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZLQBif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZLQBif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933084AbZLQBhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:37:08 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57167 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936072AbZLQBhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:37:01 -0500
Date: Wed, 16 Dec 2009 17:37:00 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Teach might_sleep() about preemptible RCU
Message-ID: <20091217013700.GL6744@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091216142536.GA18091@elte.hu> <1260991265-8451-1-git-send-regression-fweisbec@gmail.com> <20091216192354.GC5211@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216192354.GC5211@nowhere>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 08:23:57PM +0100, Frederic Weisbecker wrote:
> On Wed, Dec 16, 2009 at 08:21:05PM +0100, Frederic Weisbecker wrote:
> > From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
> 
> Crap... I think I'm really becoming this cyborg...
> 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Although I've happily put Paul's Reviewed-by tag in this v2,
> I'd feel more comfortable if he could confirm it :)

Given that I missed the TINY_RCU problem, I am not sure how much my
Reviewed-by tag is worth, but I have no problem attaching it to this
updated patch.  ;-)

						Thanx, Paul
