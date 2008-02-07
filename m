Return-Path: <linux-kernel-owner+w=401wt.eu-S1765863AbYBGBAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765863AbYBGBAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 20:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759207AbYBGBAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 20:00:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33821 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759193AbYBGBAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 20:00:37 -0500
Date: Thu, 7 Feb 2008 02:00:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Rusty Russel <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lguest: Accept guest _PAGE_PWT page table entries
Message-ID: <20080207010006.GA5842@elte.hu>
References: <20080206232134.GB6450@ubuntu> <20080206235923.GA19843@elte.hu> <20080207005120.GA5751@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207005120.GA5751@ubuntu>
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


* Ahmed S. Darwish <darwish.07@gmail.com> wrote:

> Ofcourse :) :
> 
> Accept guest _PAGE_PWT page table entries, otherwise lguest will 
> always fail with a "bad page table entry" message.

thanks - i've queued this up into x86.git. Rusty, is this fine to you, 
and should we nurse this fix upstream?

	Ingo
