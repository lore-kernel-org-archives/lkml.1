Return-Path: <linux-kernel-owner+w=401wt.eu-S965051AbXDMU2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051AbXDMU2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030181AbXDMU2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:28:10 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:42743
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965051AbXDMU2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:28:10 -0400
Date: Fri, 13 Apr 2007 13:27:45 -0700
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070413202745.GA17993@gnuppy.monkey.org>
References: <20070413202100.GA9957@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413202100.GA9957@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
> [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
... 
>    The CFS patch uses a completely different approach and implementation
>    from RSDL/SD. My goal was to make CFS's interactivity quality exceed
>    that of RSDL/SD, which is a high standard to meet :-) Testing
>    feedback is welcome to decide this one way or another. [ and, in any
>    case, all of SD's logic could be added via a kernel/sched_sd.c module
>    as well, if Con is interested in such an approach. ]

Ingo,

Con has been asking for module support for years if I understand your patch
corectly. You'll also need this for -rt as well with regards to bandwidth
scheduling. Good to see that you're moving in this direction.

bill

