Return-Path: <linux-kernel-owner+w=401wt.eu-S932946AbXLMUoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946AbXLMUoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932812AbXLMUn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:43:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55827 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932803AbXLMUn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:43:26 -0500
Date: Thu, 13 Dec 2007 21:42:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Paul E McKenney <paulmck@us.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 6/6] Preempt-RCU: Update RCU Documentation.
Message-ID: <20071213204253.GG25130@elte.hu>
References: <20071213170348.GA25981@in.ibm.com> <20071213171814.GG25981@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071213171814.GG25981@in.ibm.com>
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


* Gautham R Shenoy <ego@in.ibm.com> wrote:

> Preempt-RCU: Update RCU Documentation.
> 
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> This patch updates the RCU documentation to reflect preemptible RCU as
> well as recent publications.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Gautham, this patch is missing your SoB line - could you please send it?

	Ingo
