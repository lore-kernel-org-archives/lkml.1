Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492Ab0AYRrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0AYRrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476Ab0AYRrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:47:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754413Ab0AYRrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:47:06 -0500
Date: Mon, 25 Jan 2010 09:45:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Kyle Moffett <kyle@moffetthome.net>, tytso@mit.edu,
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
In-Reply-To: <alpine.LFD.2.00.1001250930320.3574@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001250945210.3574@localhost.localdomain>
References: <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <20100123112333.GA15455@elte.hu> <20100123114729.GA7828@redhat.com> <20100123194820.GM21263@thunk.org> <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com> <alpine.LFD.2.00.1001250845180.3574@localhost.localdomain>
 <20100125170254.GB22862@redhat.com> <alpine.LFD.2.00.1001250930320.3574@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Jan 2010, Linus Torvalds wrote:
> 
> So give me a populist argument that makes sense for tons of actual users, 
> not some f*cking "here's a cool infrastructure that developers can do 
> random crazy out-of-tree crap with". Because I'm not interested in crazy 
> developers.

In other words, give me the "killer feature". The thing I've asked for all 
the time. The thing that you seem to continually NOT EVEN UNDERSTAND.

		Linus
