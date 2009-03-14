Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbZCNLow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbZCNLow (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbZCNLon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:44:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59738 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbZCNLom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:44:42 -0400
Date: Sat, 14 Mar 2009 12:43:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 0/11] PM: Rework suspend-resume ordering to avoid
	problems with shared interrupts (updated 2x)
Message-ID: <20090314114314.GA3805@elte.hu>
References: <200902221837.49396.rjw@sisk.pl> <200903141224.29591.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903141224.29591.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Hi,
> 
> This is an update of the patch series reworking the handling 
> of interrupts during suspend-resume, addressing some comments 
> from Thomas and Ingo.

Looks very nice - thanks Rafael!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
