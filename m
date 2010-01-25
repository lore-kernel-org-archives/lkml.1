Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273Ab0AYREY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab0AYREY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156Ab0AYREX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:04:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab0AYREW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:04:22 -0500
Date: Mon, 25 Jan 2010 12:02:54 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kyle Moffett <kyle@moffetthome.net>, tytso@mit.edu,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100125170254.GB22862@redhat.com>
References: <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <20100123112333.GA15455@elte.hu> <20100123114729.GA7828@redhat.com> <20100123194820.GM21263@thunk.org> <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com> <alpine.LFD.2.00.1001250845180.3574@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001250845180.3574@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Mon, Jan 25, 2010 at 08:52:41AM -0800, Linus Torvalds wrote:

> [...]  If somebody extended ptrace in good ways, that's a totally
> different thing. But I think utrace has been over-designed, possibly
> as a result of others coming in and saying "hey, I'd like to use
> that too for xyz". [...]

Earlier, you said that you haven't followed utrace "at all".  Upon
what real information do you infer that it has been over-designed?


- FChE
