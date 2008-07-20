Return-Path: <linux-kernel-owner+w=401wt.eu-S1757466AbYGTLQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbYGTLQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 07:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYGTLQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 07:16:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38115 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbYGTLQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 07:16:18 -0400
Date: Sun, 20 Jul 2008 07:16:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>, Florian Weimer <fw@deneb.enyo.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Elias Oltmanns <eo@nebensachen.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH -v2] ftrace: Documentation
Message-ID: <20080720111601.GA11143@infradead.org>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com> <87zlop7bp6.fsf@denkblock.local> <20080710132832.38cc5048.randy.dunlap@oracle.com> <Pine.LNX.4.58.0807101956120.7719@gandalf.stny.rr.com> <Pine.LNX.4.58.0807102035550.7719@gandalf.stny.rr.com> <871w1u5edg.fsf@mid.deneb.enyo.de> <Pine.LNX.4.58.0807160737250.31086@gandalf.stny.rr.com> <20080717141918.GA13741@infradead.org> <Pine.LNX.4.58.0807172244100.22792@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0807172244100.22792@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 10:47:18PM -0400, Steven Rostedt wrote:
> this work, as long as they give me credit (keep the copyright). I don't
> remember exactly how the thread went, I first put the document under the
> GPL, but I someone told me that isn't appropriate for documentation. So I
> used this instead. I know the documentation and the code are distributed
> together, but the "binary" of Linux does not contain the Documentation
> directory as source, so I would think that the GPL is not quite
> appropriate for the Documentation directory.
> 
> I'll need to ask a lawyer about this, but how about a "dual" license?
> The GFDL and what ever you feel is appropriate?

The GPL is what covers the whole kernel tree and thuis also te
Documentation/ directory.  I don't think we've ever denied anyone to do
any kind of dual licensing as as strange as it might be, so a GPLv2/GFDL
dual license  sounds perfectly fine.
