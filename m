Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYH1Jop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYH1Jop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 05:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbYH1Joh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 05:44:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35052 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbYH1Jog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 05:44:36 -0400
Date: Thu, 28 Aug 2008 11:44:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
Message-ID: <20080828094423.GD28783@elte.hu>
References: <48B1D5CA.8000607@gmail.com> <c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com> <20080827212130.4b8365a8@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080827212130.4b8365a8@daedalus.pq.iki.fi>
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


* Pekka Paalanen <pq@iki.fi> wrote:

> > Do you think I should modify something or use a way to make it 
> > better? (Added Pekka Paalanen in Cc since it concerns an idea from 
> > his mmiotrace's documentation)...
> 
> Thanks for adding me, I've been brewing my own version of this stuff, 
> but didn't yet solve the __ftrace_printk-is-unusable issue yet. I have 
> the mmiotrace specific parts written for TRACE_PRINT, so we haven't 
> really overlapped each other's work yet.

we can certainly include and test Frédéric's patch in tip/tracing/ftrace 
- i'll wait for v2 as i guess he will implement the modifications 
suggested by you?

	Ingo
