Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYGOJTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYGOJTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 05:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbYGOJTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 05:19:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47805 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbYGOJTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 05:19:40 -0400
Date: Tue, 15 Jul 2008 11:19:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [Bug 10489] Kprobe smoke test lockdep warning
Message-ID: <20080715091925.GA14182@elte.hu>
References: <20080421150656.GJ6011@cs181133002.pp.htv.fi> <480D1B14.7070806@redhat.com> <1208869770.7115.265.camel@twins> <480E0FCF.1030704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480E0FCF.1030704@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hi Peter,
> 
> Thank you for the patch,

[...]
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> I tested it on x86-64/i386.
> 
> Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

applied to tip/x86/kprobes, thanks!

	Ingo
