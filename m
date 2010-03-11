Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab0CKLnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 06:43:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40585 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757508Ab0CKLnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 06:43:04 -0500
Date: Thu, 11 Mar 2010 12:42:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org, anton@samba.org
Subject: Re: [GIT PULL] Please pull my perf.git urgent branch
Message-ID: <20100311114248.GB31354@elte.hu>
References: <20100310095259.GB3959@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310095259.GB3959@brick.ozlabs.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo,
> 
> My fix for the oops Anton was seeing was acked by Peter Z and
> attracted no other comments, so please pull it and send it on to
> Linus with the next batch of urgent fixes.
> 
> Thanks,
> Paul.
> 
> The following changes since commit 548b84166917d6f5e2296123b85ad24aecd3801d:
>   Ingo Molnar (1):
>         Merge commit 'v2.6.34-rc1' into perf/urgent
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perf.git urgent
> 
> Paul Mackerras (1):
>       perf_event: Fix oops triggered by cpu offline/online
> 
>  kernel/perf_event.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)

Applied, thanks a lot Paul!

	Ingo
