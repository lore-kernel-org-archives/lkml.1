Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbZAEMPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbZAEMPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 07:15:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZAEMPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 07:15:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39642 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbZAEMPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 07:15:22 -0500
Date: Mon, 5 Jan 2009 13:15:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/5] hrtimer: cleanups and fixes
Message-ID: <20090105121505.GA13969@elte.hu>
References: <20090105102818.829119334@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105102818.829119334@chello.nl>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Please consider for .29.

picked them up into tip/timers/urgent:

 e3f1d88: hrtimer: fixup comments
 a6037b6: hrtimer: fix recursion deadlock by re-introducing the softirq
 731a55b: hrtimer: simplify hotplug migration
 d5fd43c: hrtimer: fix HOTPLUG_CPU=n compile warning
 8bdec95: hrtimer: splitout peek ahead functionality

thanks Peter!

	Ingo
