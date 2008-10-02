Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYJBS1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYJBS1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 14:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbYJBS1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 14:27:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39774 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbYJBS1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 14:27:38 -0400
Date: Thu, 2 Oct 2008 14:27:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [boot crash] Re: [PATCH] ring-buffer: fix build error
In-Reply-To: <20081002155053.GA31953@elte.hu>
Message-ID: <alpine.DEB.1.10.0810021426080.2919@gandalf.stny.rr.com>
References: <1222790072.24384.21.camel@twins> <alpine.LFD.2.00.0809300930090.3389@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809301242550.1984@gandalf.stny.rr.com> <alpine.LFD.2.00.0809300958120.3389@nehalem.linux-foundation.org>
 <alpine.DEB.1.10.0810011114000.30777@gandalf.stny.rr.com> <20081002085030.GF26084@elte.hu> <20081002085145.GA3202@elte.hu> <20081002090517.GA8708@elte.hu> <20081002093835.GA17699@elte.hu> <alpine.DEB.1.10.0810020916580.19018@gandalf.stny.rr.com>
 <20081002155053.GA31953@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2 Oct 2008, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > On Thu, 2 Oct 2008, Ingo Molnar wrote:
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > full serial log and config attached. I'm excluding these latest commits 
> > 
> >  -ENOATTACHMENT
> 
> attached.
> 
> You can get the broken tree by doing this in tip/master:
> 
>   git-merge tip/tracing/ring-buffer

I've just checked-out tip/tracing/ring-buffer. That tree is still broken 
too, right? Or do I need to merge it to get the broken version?

-- Steve

