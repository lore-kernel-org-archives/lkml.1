Return-Path: <linux-kernel-owner+w=401wt.eu-S1757437AbYADJxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437AbYADJxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 04:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbYADJxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 04:53:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49088 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbYADJxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 04:53:45 -0500
Date: Fri, 4 Jan 2008 10:53:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       John Stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH x86] [16/16] Mark memory_setup __init
Message-ID: <20080104095324.GA6302@elte.hu>
References: <20080103442.621670000@suse.de> <20080103154231.0856214EFF@wotan.suse.de> <20080104092501.GA2189@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104092501.GA2189@elte.hu>
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


btw., as a sidenote, all of your recent patches to lkml had one or two 
missing Cc:s.

for lockdep patches, please Cc:

   Peter Zijlstra <a.p.zijlstra@chello.nl>
   Ingo Molnar <mingo@elte.hu>

for genirq patches, please Cc:

   Thomas Gleixner <tglx@linutronix.de>
   Ingo Molnar <mingo@elte.hu>

for timer/clocksource/clockevents patches please Cc:

   Thomas Gleixner <tglx@linutronix.de>
   John Stultz <johnstul@us.ibm.com>
   Ingo Molnar <mingo@elte.hu>

for x86 patches, please Cc:

   Thomas Gleixner <tglx@linutronix.de>
   "H. Peter Anvin" <hpa@zytor.com>
   Ingo Molnar <mingo@elte.hu>

having a complete Cc: line makes it easier to coordinate patches - 
especially for larger patchbombs. Thanks,

	Ingo
