Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbYLIK70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbYLIK70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 05:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYLIK7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 05:59:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59934 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbYLIK7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 05:59:17 -0500
Date: Tue, 9 Dec 2008 11:59:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oliver Hartkopp <oliver@hartkopp.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] hrtimer: removing all ur callback modes
Message-ID: <20081209105902.GB21618@elte.hu>
References: <1227613431.4259.1537.camel@twins> <1228385830.5092.43.camel@twins> <493BB1EB.5000004@hartkopp.net> <493BC8A8.2030200@hartkopp.net> <1228731359.5778.18.camel@twins> <493E2725.7090305@hartkopp.net> <1228810331.12729.59.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228810331.12729.59.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > ps. What is the intended release for this hrtimer cleanup? 2.6.29?
> 
> I think so, Thomas, Ingo?

yes, 2.6.29.

	Ingo
