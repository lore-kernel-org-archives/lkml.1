Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbZKIU1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbZKIU1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 15:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbZKIU1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 15:27:48 -0500
Received: from www.tglx.de ([62.245.132.106]:35908 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbZKIU1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 15:27:47 -0500
Date: Mon, 9 Nov 2009 21:27:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-arch@vger.kernel.org
Subject: Re: [patch 1/2] locking: Make inlining decision Kconfig based
In-Reply-To: <1257794216.4108.372.camel@laptop>
Message-ID: <alpine.LFD.2.00.0911092126170.2725@localhost.localdomain>
References: <20091109150033.125758935@linutronix.de>  <20091109151428.504477141@linutronix.de> <1257794216.4108.372.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Nov 2009, Peter Zijlstra wrote:

> On Mon, 2009-11-09 at 15:21 +0000, Thomas Gleixner wrote:
> >  6 files changed, 284 insertions(+), 104 deletions(-)
> 
> Bloats the code a bit, and the Kconfig expressions are a pain to look
> at, but I guess having a clear and unambiguous CONFIG_ symbol in the end
> is a win.
> 
> If you fix up that floating hunk in the second patch, I guess I'm ok
> with it..

Duh. I'm sure that I fixed that _before_ sending it out. Seems to be
one of those days where you'd better stay in bed and read a book :)
 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks,

	tglx
