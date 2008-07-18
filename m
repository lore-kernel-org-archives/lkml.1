Return-Path: <linux-kernel-owner+w=401wt.eu-S1760167AbYGRCr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167AbYGRCr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 22:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYGRCrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 22:47:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36986 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbYGRCrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 22:47:21 -0400
Date: Thu, 17 Jul 2008 22:47:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Hellwig <hch@infradead.org>
cc: Florian Weimer <fw@deneb.enyo.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Elias Oltmanns <eo@nebensachen.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH -v2] ftrace: Documentation
In-Reply-To: <20080717141918.GA13741@infradead.org>
Message-ID: <Pine.LNX.4.58.0807172244100.22792@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
 <87zlop7bp6.fsf@denkblock.local> <20080710132832.38cc5048.randy.dunlap@oracle.com>
 <Pine.LNX.4.58.0807101956120.7719@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0807102035550.7719@gandalf.stny.rr.com> <871w1u5edg.fsf@mid.deneb.enyo.de>
 <Pine.LNX.4.58.0807160737250.31086@gandalf.stny.rr.com>
 <20080717141918.GA13741@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Thu, 17 Jul 2008, Christoph Hellwig wrote:
> >
> > The document is not code. The GPL is not appropriate for it. I had this
> > discussion when I wrote the rt-mutex-design.txt file, and the conclussion
> > was that the GFDL was an appropriate license.
>
> The GFDL is never appropriate, and certainly not for the kernel tree.
> We had some files under it in the past and we decided to relicense them
> after talking to the authors.
>

I'm fine with any "free" license. I don't need people asking me to use
this work, as long as they give me credit (keep the copyright). I don't
remember exactly how the thread went, I first put the document under the
GPL, but I someone told me that isn't appropriate for documentation. So I
used this instead. I know the documentation and the code are distributed
together, but the "binary" of Linux does not contain the Documentation
directory as source, so I would think that the GPL is not quite
appropriate for the Documentation directory.

I'll need to ask a lawyer about this, but how about a "dual" license?
The GFDL and what ever you feel is appropriate?

-- Steve

