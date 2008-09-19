Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbYISKnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbYISKnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 06:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYISKno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 06:43:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59182 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbYISKno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 06:43:44 -0400
Date: Fri, 19 Sep 2008 12:43:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -tip FIXED] ftrace: add nop tracer
Message-ID: <20080919104330.GA28190@elte.hu>
References: <1221818803-9616-1-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221818803-9616-1-git-send-email-steven@uplinklabs.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0056]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Noonan <steven@uplinklabs.net> wrote:

> A no-op tracer which can serve two purposes:
>  1. A template for development of a new tracer.
>  2. A convenient way to see ftrace_printk() calls without
>     an irrelevant trace making the output messy.
> 
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>

that was quick :) Applied to tip/tracing/ftrace, thanks Steven!

	Ingo
