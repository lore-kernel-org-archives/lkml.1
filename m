Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbYHOPBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbYHOPBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756979AbYHOPBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:01:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51827 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756660AbYHOPBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:01:14 -0400
Date: Fri, 15 Aug 2008 17:00:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/2] ftrace: printk formatted recording
Message-ID: <20080815150059.GB10029@elte.hu>
References: <20080801162639.175407419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801162639.175407419@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> I previously sent out a patch to add printk formatted recording to the 
> ftrace buffers.  Andrew Morton suggested to get rid of my hacked 
> trace_cont structure and do it properly with one structure at the top 
> and two other structures to handle the difference between the fields 
> and the continuation entry.

applied all 3 patches to tip/tracing/ftrace - thanks Steve.

	Ingo
