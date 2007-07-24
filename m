Return-Path: <linux-kernel-owner+w=401wt.eu-S1762514AbXGXTMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762514AbXGXTMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbXGXTLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:11:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45576 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbXGXTLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:11:51 -0400
Date: Tue, 24 Jul 2007 21:11:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users@vger.kernel.org
Subject: Re: [RT-PATCH] v2.6.23-rc1-rt0 Add missing header in sch_generic.c
Message-ID: <20070724191145.GB13268@elte.hu>
References: <200707242103.41880.hjk@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200707242103.41880.hjk@linutronix.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Hans-Jürgen Koch <hjk@linutronix.de> wrote:

> v2.6.23-rc1-rt0 adds an msleep(1) in net/sched/sch_generic.c without 
> including the neceessary header. This patches fixes it.
> 
> Signed-off-by: Hans J. Koch <hjk@linutronix.de>

thanks, applied.

	Ingo
