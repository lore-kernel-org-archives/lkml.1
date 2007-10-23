Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbXJWIkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbXJWIkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 04:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXJWIkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 04:40:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46562 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbXJWIkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 04:40:09 -0400
Date: Tue, 23 Oct 2007 10:39:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Paul Jackson <pj@sgi.com>, Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -v2 0/7] New RT Task Balancing -v2
Message-ID: <20071023083955.GA15887@elte.hu>
References: <20071023025900.927578809@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023025900.927578809@goodmis.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

>   Changes since V1:
>     Updated to git tree 55b70a0300b873c0ec7ea6e33752af56f41250ce
> 
>     Various clean ups suggested by Gregory Haskins, Dmitry Adamushko,
>     and Peter Zijlstra.

ok, i like this new approach - nice work! I'd suggest we test it in -rt 
for some time and then merge it into v2.6.25?

	Ingo
