Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbYBRPyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbYBRPyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 10:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbYBRPyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 10:54:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45445 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbYBRPyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:54:05 -0500
Date: Mon, 18 Feb 2008 16:53:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] simplify cpu_hotplug_begin()/put_online_cpus()
Message-ID: <20080218155339.GA4148@elte.hu>
References: <20080216172254.GA18521@tv-sign.ru> <20080218145947.GA27127@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218145947.GA27127@in.ibm.com>
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

> On Sat, Feb 16, 2008 at 08:22:54PM +0300, Oleg Nesterov wrote:
> 
> This looks neat and clean.
> 
> Acked-by: Gautham R Shenoy <ego@in.ibm.com>

thanks, picked it up into the scheduler queue.

	Ingo
