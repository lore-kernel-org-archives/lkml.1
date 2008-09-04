Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYIDHmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYIDHmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 03:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYIDHlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 03:41:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:48979 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbYIDHlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 03:41:52 -0400
Subject: Re: [PATCH 0/2] ftrace: ftrace_printk fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080903214249.661170580@goodmis.org>
References: <20080903214249.661170580@goodmis.org>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 09:41:52 +0200
Message-Id: <1220514112.8609.185.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-03 at 17:42 -0400, Steven Rostedt wrote:
> Peter Zijlstra is starting to use ftrace_printk to debug the scheduler.
> He quickly came across a few issues.
> 
> These two patches address some of the things he has concerns about.

Yay - works now!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> I'm expecting that Peter will be sending some more patches to help with
> the interface.

Yep, I will.. let me extract that from the massive diff I have
here.. :-)



