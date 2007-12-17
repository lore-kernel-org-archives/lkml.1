Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbXLQRX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbXLQRX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758288AbXLQRXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:23:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40856 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbXLQRXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:23:49 -0500
Date: Mon, 17 Dec 2007 18:23:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation>, protasnb@gmail.com
Subject: Re: Top kernel oopses/warnings this week
Message-ID: <20071217172331.GA23070@elte.hu>
References: <4762CF8C.90808@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4762CF8C.90808@linux.intel.com>
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


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> The http://www.kerneloops.org website collects kernel oops and warning 
> reports from various mailing lists and bugzillas; below is a top 10 
> list of the oopses collected in the last 7 days. (Reports prior to 
> 2.6.23 have been omitted in collecting the top 10)

cool stuff! I cannot over-emphasise how useful this will be.

Let us know if you need any additional WARN_ON()s or other dmesg 
annotations to make parsing easier / more intelligent. At least as far 
as arch/x86 and the scheduler is related it's going to be applied to the 
fast-track queue ;-)

	Ingo
