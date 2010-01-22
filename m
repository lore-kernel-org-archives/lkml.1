Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297Ab0AVTkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0AVTkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 14:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881Ab0AVTko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 14:40:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab0AVTkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 14:40:43 -0500
Date: Fri, 22 Jan 2010 20:39:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: ananth@in.ibm.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       utrace-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100122193923.GB13185@redhat.com>
References: <20100120072925.GA11395@elte.hu> <20100121013822.28781960.sfr@canb.auug.org.au> <20100122111747.3c224dfd.sfr@canb.auug.org.au> <20100121163004.8779bd69.akpm@linux-foundation.org> <20100121163145.7e958c3f.akpm@linux-foundation.org> <20100122005147.GD22003@redhat.com> <20100121170541.7425ff10.akpm@linux-foundation.org> <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> <20100122052139.GA20532@in.ibm.com> <18867.1264167798@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18867.1264167798@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22, Valdis.Kletnieks@vt.edu wrote:
>
> No, that only proves it's compatible enough for gdb to not care. The problem
> is all those *other* packages that abuse ptrace in totally crackhead ways.
>
> (No, I can't name them - but ptrace is the sort of interface that almost
> encourages its use for things somewhere between crackhead and mad-scientist,
> so they're almost certainly out there.. WAY out there.. :)

Yes, this is true.

We are trying to test it as much as possible.

Oleg.

