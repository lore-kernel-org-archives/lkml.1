Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbZJGJkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbZJGJkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 05:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbZJGJkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 05:40:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32805 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757514AbZJGJkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 05:40:02 -0400
Date: Wed, 7 Oct 2009 11:39:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_event: Remove include/linux/perf_counter.h
Message-ID: <20091007093914.GA22743@elte.hu>
References: <4ACC5F6D.7020809@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACC5F6D.7020809@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> Remove include/linux/perf_counter.h because it's not used anymore 
> after one of Ingo's patch:

Please read the explanation in the file about why we left it in place:

> --- a/include/linux/perf_counter.h
> +++ /dev/null
> @@ -1,441 +0,0 @@
> -/*
> - *  NOTE: this file will be removed in a future kernel release, it is
> - *  provided as a courtesy copy of user-space code that relies on the
> - *  old (pre-rename) symbols and constants.

	Ingo
