Return-Path: <linux-kernel-owner+w=401wt.eu-S1757891AbZD1Tz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891AbZD1Tz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZD1TzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:55:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754412AbZD1TzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:55:15 -0400
Date: Tue, 28 Apr 2009 12:48:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: rusty@rustcorp.com.au, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, x86@kernel.org
Subject: Re: mmotm 2009-02-17-12-33 uploaded
Message-Id: <20090428124850.571c36e6.akpm@linux-foundation.org>
In-Reply-To: <20090428192219.GA3398@redhat.com>
References: <200902172050.n1HKorvc028933@imap1.linux-foundation.org>
	<499BD65B.2080307@gmail.com>
	<20090218015356.4454f758.akpm@linux-foundation.org>
	<200902182245.27525.rusty@rustcorp.com.au>
	<20090218145037.GA24240@redhat.com>
	<20090428192219.GA3398@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009 21:22:19 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> So, what happened with
> 
> 	kthreads-simplify-the-startup-synchronization.patch
> 	http://marc.info/?l=linux-mm-commits&m=123335224710768
> 
> 	kthreads-rework-kthread_stop.patch
> 	http://marc.info/?l=linux-mm-commits&m=123335227910835
> 
> patches? Can't find them in any tree.

I seem to have had an administrative error.  I think the patches were
temporarily parked because people were madly changing things under my feet,
and they didn't get unparked.

I've just restored

kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch

and I'll send them out again.

I hope nothing else got lost.  They're the only *kthread* patches which
I can see here.

