Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZLBIcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZLBIcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZLBIcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:32:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56968 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbZLBIcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:32:31 -0500
Date: Wed, 2 Dec 2009 09:31:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Wang Liming <liming.wang@windriver.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, mingo@redhat.com,
       peterz@infradead.org, linux-kernel@vger.kernel.org, acme@redhat.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       fche@redhat.com, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com
Subject: Re: [tip:perf/core] perf probe: Add --list option for listing
 current probe events
Message-ID: <20091202083120.GA20120@elte.hu>
References: <20091201002017.10235.76575.stgit@harusame>
 <tip-4de189fe6e5ad8241f6f8709d2e2ba4c3aeae33a@git.kernel.org>
 <4B15E913.1040105@windriver.com>
 <4B15F36F.5040304@redhat.com>
 <4B15FCAB.7000209@windriver.com>
 <20091202060655.GB5719@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202060655.GB5719@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, Dec 02, 2009 at 01:35:39PM +0800, Wang Liming wrote:
> > Yes, my glibc is old so that "perf" can't be built. I'm using ubuntu 8.04.
> >
> > Thanks a lot.
> 
> 
> 
> What is your glibc version?
> %m appears to be supported since 2.7
> 
> But if possible we would like perf to be buildable on most
> boxes. May be should we use %a instead there.

Definitely so.

Wang, mind sending a patch for that?

Thanks,

	Ingo
