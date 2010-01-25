Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495Ab0AYRyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab0AYRyg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286Ab0AYRyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:54:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab0AYRye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:54:34 -0500
X-Authority-Analysis: v=1.0 c=1 a=7U3hwN5JcxgA:10 a=07d9gI8wAAAA:8 a=HZ0Hy6TM_vxVDq2X4EcA:9 a=wkLBd8P0D2puPbcFdFZam9FflfAA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: linux-next: add utrace tree
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Kyle Moffett <kyle@moffetthome.net>,
       tytso@mit.edu, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.LFD.2.00.1001250930320.3574@localhost.localdomain>
References: <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
	 <20100122221348.GA4263@redhat.com>
	 <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
	 <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
	 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
	 <20100123112333.GA15455@elte.hu> <20100123114729.GA7828@redhat.com>
	 <20100123194820.GM21263@thunk.org>
	 <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com>
	 <alpine.LFD.2.00.1001250845180.3574@localhost.localdomain>
	 <20100125170254.GB22862@redhat.com>
	 <alpine.LFD.2.00.1001250930320.3574@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 25 Jan 2010 12:54:30 -0500
Message-ID: <1264442070.31321.422.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 09:36 -0800, Linus Torvalds wrote:

>  Because I'm not interested in crazy 
> developers.
> 
> 			Linus


Uh oh, that's not good for us real-time folks.

http://lwn.net/Articles/357800/

"And, according to Linus, the realtime people are crazy, so they can be
left to deal with the weird stuff."


-- Steve

(Sorry, I just couldn't resist)


