Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbXKDJzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbXKDJzo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 04:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbXKDJzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 04:55:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53672 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbXKDJze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 04:55:34 -0500
Date: Sun, 4 Nov 2007 10:55:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v2] Restore deterministic CPU accounting on powerpc
Message-ID: <20071104095509.GA11570@elte.hu>
References: <18220.26005.778223.84644@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18220.26005.778223.84644@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> account_process_tick now takes the task_struct * as an argument.
> Tested both with and without CONFIG_VIRT_CPU_ACCOUNTING.

thanks, applied.

	Ingo
