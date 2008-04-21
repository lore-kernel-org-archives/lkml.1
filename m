Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbYDUTdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbYDUTdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbYDUTdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:33:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52667 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958AbYDUTdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:33:43 -0400
Date: Mon, 21 Apr 2008 21:33:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: suresh.b.siddha@intel.com, rostedt@goodmis.org, chinang.ma@intel.com,
       arjan@linux.intel.com, willy@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 0/2] sched: refreshes
Message-ID: <20080421193326.GC8770@elte.hu>
References: <20080421180747.4560.67794.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421180747.4560.67794.stgit@novell1.haskins.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Gregory Haskins <ghaskins@novell.com> wrote:

> Hi Ingo,
>   Here is a refresh of the two patches you asked for:
> 
> #1 is "v3" of the "pushed" patch which fixes the compilation issue on
>  !CONFIG_SMP
> 
> #2 is a resend of the 2-d bitmap, which includes a fix for that typo I
>  mentioned.

thanks Gregory, applied. We'll see whether they'll make v2.6.26. (but 
given that they existed for a longer time i'd lean towards including 
them - barring some unexpected test failure.)

	Ingo
