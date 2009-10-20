Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZJTG4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZJTG4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZJTG4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:56:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38583 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbZJTG4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 02:56:30 -0400
Date: Tue, 20 Oct 2009 08:55:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ashwin Chaugule <ashbertslists@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes, perf: perf
	probe and kprobe-tracer bugfixes
Message-ID: <20091020065554.GO8550@elte.hu>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <ad7a95ae0910191610q6f6200f1n112a71a0cbd483f1@mail.gmail.com> <4ADD049E.9080000@redhat.com> <ad7a95ae0910191859l6e0246b8u8634fac5b8ec0770@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad7a95ae0910191859l6e0246b8u8634fac5b8ec0770@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ashwin Chaugule <ashbertslists@gmail.com> wrote:

> > Yes, it's done as I said above. But it still has long TODO list, 
> > including support type of arguments, arrays, fields of structures 
> > and so on (of course, defining useful syntax too). So any comments 
> > and contributes are welcome :-)
>
> Excellent ! Time to give it a spin :)

btw., you can pick it up from:

  http://people.redhat.com/mingo/tip.git/README

  git checkout tip/perf/probes

	Ingo
