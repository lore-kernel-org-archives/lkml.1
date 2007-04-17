Return-Path: <linux-kernel-owner+w=401wt.eu-S1161206AbXDQUJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161206AbXDQUJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 16:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161228AbXDQUJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 16:09:35 -0400
Received: from holomorphy.com ([66.93.40.71]:54583 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161206AbXDQUJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 16:09:34 -0400
Date: Tue, 17 Apr 2007 13:05:53 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: James Bruce <bruce@andrew.cmu.edu>
Cc: Chris Friesen <cfriesen@nortel.com>, Willy Tarreau <w@1wt.eu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       hui Bill Huey <billh@gnuppy.monkey.org>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417200553.GO2986@holomorphy.com>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu> <20070415095146.GA30327@gnuppy.monkey.org> <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com> <20070415124527.GP943@1wt.eu> <20070415152643.GH8915@holomorphy.com> <46239C62.4090302@nortel.com> <4624C6A5.2090000@andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4624C6A5.2090000@andrew.cmu.edu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 09:07:49AM -0400, James Bruce wrote:
> Nonlinear is a must IMO.  I would suggest X = exp(ln(10)/10) ~= 1.2589
> That value has the property that a nice=10 task gets 1/10th the cpu of a 
> nice=0 task, and a nice=20 task gets 1/100 of nice=0.  I think that 
> would be fairly easy to explain to admins and users so that they can 
> know what to expect from nicing tasks.
[...additional good commentary trimmed...]

Lots of good ideas here. I'll follow them.


-- wli
