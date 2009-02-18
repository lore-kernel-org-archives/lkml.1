Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZBRMPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZBRMPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZBRMPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:15:37 -0500
Received: from ozlabs.org ([203.10.76.45]:38867 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbZBRMPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:15:36 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-02-17-12-33 uploaded
Date: Wed, 18 Feb 2009 22:45:26 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       tglx@linutronix.de, x86@kernel.org, oleg@redhat.com
References: <200902172050.n1HKorvc028933@imap1.linux-foundation.org> <499BD65B.2080307@gmail.com> <20090218015356.4454f758.akpm@linux-foundation.org>
In-Reply-To: <20090218015356.4454f758.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902182245.27525.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 20:23:56 Andrew Morton wrote:
> Someone else has been mucking with kthread.c in linux-next, and a
> couple of days ago that mucking got dropped from linux-next.  Perhaps
> this churn broke Oleg's patch.

Err, yes.

Oleg and I had an accidentally-offlist chat about these patches.

Last we decided, a more ambitious approach was desired.  Patches RSN.

I've taken kthreads-move-sched-realeted-initialization-from-kthreadd-context.patch
though, thanks!

Cheers,
Rusty.
