Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbYGQOTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbYGQOTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbYGQOTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:19:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49706 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbYGQOTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:19:40 -0400
Date: Thu, 17 Jul 2008 10:19:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Florian Weimer <fw@deneb.enyo.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       Elias Oltmanns <eo@nebensachen.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH -v2] ftrace: Documentation
Message-ID: <20080717141918.GA13741@infradead.org>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com> <87zlop7bp6.fsf@denkblock.local> <20080710132832.38cc5048.randy.dunlap@oracle.com> <Pine.LNX.4.58.0807101956120.7719@gandalf.stny.rr.com> <Pine.LNX.4.58.0807102035550.7719@gandalf.stny.rr.com> <871w1u5edg.fsf@mid.deneb.enyo.de> <Pine.LNX.4.58.0807160737250.31086@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0807160737250.31086@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 07:39:23AM -0400, Steven Rostedt wrote:
> 
> On Wed, 16 Jul 2008, Florian Weimer wrote:
> 
> >
> > * Steven Rostedt:
> >
> > > +  License:   The GNU Free Documentation License, Version 1.2
> >
> > Is it really a good idea to put files under GPL-incompatible licenses
> > into the tree?
> >
> 
> The document is not code. The GPL is not appropriate for it. I had this
> discussion when I wrote the rt-mutex-design.txt file, and the conclussion
> was that the GFDL was an appropriate license.

The GFDL is never appropriate, and certainly not for the kernel tree.
We had some files under it in the past and we decided to relicense them
after talking to the authors. 
