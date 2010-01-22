Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625Ab0AVAxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab0AVAxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 19:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471Ab0AVAxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 19:53:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab0AVAxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 19:53:09 -0500
Date: Thu, 21 Jan 2010 19:51:47 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100122005147.GD22003@redhat.com>
References: <20100119211646.GF16096@redhat.com> <20100120111220.e7fb4e2c.sfr@canb.auug.org.au> <20100120054950.GB27108@elte.hu> <20100120061551.GB6588@in.ibm.com> <20100120062834.GB12165@elte.hu> <20100120072925.GA11395@elte.hu> <20100121013822.28781960.sfr@canb.auug.org.au> <20100122111747.3c224dfd.sfr@canb.auug.org.au> <20100121163004.8779bd69.akpm@linux-foundation.org> <20100121163145.7e958c3f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100121163145.7e958c3f.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Jan 21, 2010 at 04:31:45PM -0800, Andrew Morton wrote:
> [...]
> > Someone please sell this to us.
> Here's what Oleg said last time I asked this: [...]

I wonder if Roland/Oleg are being too modest in their current role as
ptrace maintainers.  Considering that *they* think of utrace as a
means toward proper refactoring of ptrace, how much further burden of
proof should they shoulder?  To what extent are other subsystem
maintainers required to "sell" reworkings of their areas, when there
appear to be no drawbacks and at least arguable benefits?

- FChE
