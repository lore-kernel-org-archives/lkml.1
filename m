Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab0BVK32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 05:29:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42406 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab0BVK3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 05:29:25 -0500
Date: Mon, 22 Feb 2010 11:28:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Paul Mackerras <paulus@samba.org>,
       systemtap <systemtap@sources.redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Roland McGrath <roland@redhat.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [Dle-develop] [PATCH -tip 5/9] perf probe: Use elfutils-libdw
 for	analyzing	debuginfo
Message-ID: <20100222102843.GA9313@elte.hu>
References: <20100218232701.21679.5195.stgit@dhcp-100-2-132.bos.redhat.com>
 <20100218232741.21679.22423.stgit@dhcp-100-2-132.bos.redhat.com>
 <4B81A308.3020204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B81A308.3020204@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Masami Hiramatsu wrote:
> > Newer gcc introduces newer & richer debuginfo, and only libdw
> > in elfutils project can support it. So perf probe moves onto
> > elfutils-libdw from libdwarf.
> 
> Hmm, this has some bit-width related issues on x86-64.
> I'll update this patch.

Ok, i'll wait for the next drop of these patches.

Thanks,

	Ingo
