Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbZAaTNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbZAaTNR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 14:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZAaTND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 14:13:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50458 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZAaTNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 14:13:00 -0500
Date: Sat, 31 Jan 2009 20:12:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mandeep Singh Baines <msb@google.com>
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softlockup: remove unused definition for
	spawn_softlockup_task
Message-ID: <20090131191249.GC10895@elte.hu>
References: <20090130232954.GA18399@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130232954.GA18399@google.com>
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


* Mandeep Singh Baines <msb@google.com> wrote:

> The definition of spawn_softlockup_task in sched.h became
> unnecessary once it was converted to the early_initcall()
> interface.
> 
> Signed-off-by: Mandeep Singh Baines <msb@google.com>
> ---
>  include/linux/sched.h |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)

applied to tip/core/softlockup, thanks Mandeep!

	Ingo
