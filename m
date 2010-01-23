Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899Ab0AWP6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab0AWP6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 10:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581Ab0AWP6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 10:58:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60441 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab0AWP6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 10:58:10 -0500
Date: Sat, 23 Jan 2010 13:57:49 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kyle Moffett <kyle@moffetthome.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100123155749.GC2689@ghostprotocols.net>
References: <20100121170541.7425ff10.akpm@linux-foundation.org> <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> <20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <20100123110121.1ce89bb9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100123110121.1ce89bb9@lxorguk.ukuu.org.uk>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jan 23, 2010 at 11:01:21AM +0000, Alan Cox escreveu:
> Years ago (and it really must be years ago because this was about the
> time I started hacking on Linux stuff !) there was a proposal to extract
> and sanitize the arch specific stuff in binutils and in gdb etc into
> sensible libraries that could be used by other apps.

Aleluiah if it had happened at that time, but sadly... :-(
 
- Arnaldo
