Return-Path: <linux-kernel-owner+w=401wt.eu-S1755031AbZD1UT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbZD1UT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbZD1UTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:19:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38633 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbZD1UTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:19:48 -0400
Date: Tue, 28 Apr 2009 22:13:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rusty@rustcorp.com.au, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, x86@kernel.org
Subject: Re: mmotm 2009-02-17-12-33 uploaded
Message-ID: <20090428201325.GA6100@redhat.com>
References: <200902172050.n1HKorvc028933@imap1.linux-foundation.org> <499BD65B.2080307@gmail.com> <20090218015356.4454f758.akpm@linux-foundation.org> <200902182245.27525.rusty@rustcorp.com.au> <20090218145037.GA24240@redhat.com> <20090428192219.GA3398@redhat.com> <20090428124850.571c36e6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428124850.571c36e6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28, Andrew Morton wrote:
>
> kthreads-simplify-the-startup-synchronization.patch
> kthreads-rework-kthread_stop.patch
> kthreads-simplify-migration_thread-exit-path.patch
>
> and I'll send them out again.

Thanks!

> I hope nothing else got lost.  They're the only *kthread* patches which
> I can see here.

Yes, there was nothing else kthread-related.

Oleg.

