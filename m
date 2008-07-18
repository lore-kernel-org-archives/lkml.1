Return-Path: <linux-kernel-owner+w=401wt.eu-S1760435AbYGRR1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435AbYGRR1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbYGRR07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:26:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59146 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758007AbYGRR06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:26:58 -0400
Date: Fri, 18 Jul 2008 19:26:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix a compile warning in arch/x86/mm/init_64.c
Message-ID: <20080718172647.GO6875@elte.hu>
References: <20080709225202.GA3232@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709225202.GA3232@local>
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


* Hans J. Koch <hjk@linutronix.de> wrote:

> This fixes a minor compile warning in arch/x86/mm/init_64.c about 
> passing a wrong pointer type as argument 2 to find_e820_area_size(). 
> Tested with 2.6.26-rc9.
> 
> Signed-of-by: Hans J. Koch <hjk@linutronix.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>

applied to tip/x86/cleanups - thanks Hans!

	Ingo
