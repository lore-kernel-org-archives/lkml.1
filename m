Return-Path: <linux-kernel-owner+w=401wt.eu-S934347AbXEGQnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934347AbXEGQnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965907AbXEGQnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:43:18 -0400
Received: from www.osadl.org ([213.239.205.134]:51273 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965844AbXEGQnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:43:17 -0400
Subject: Re: [PATCH] x86-64 highres/dyntick support
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Chris Wright <chrisw@sous-sol.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070507163110.GP3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <20070507163110.GP3505@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Mon, 07 May 2007 18:46:00 +0200
Message-Id: <1178556361.3042.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 09:31 -0700, Chris Wright wrote:
> * Thomas Gleixner (tglx@linutronix.de) wrote:
> > I'm pleased to announce the first cut of the final x86_64
> > highres/dyntick support, which I did based on Chris Wright's patch set,
> > which is again based on Arjan van de Ven's initial work:
> 
> Cool.  I had finished mine as well, just didn't get time to polish
> and resubmit.

Hrmpf, you could have saved my weekend :)

>   Going through to see where we differ and if there's
> any bits of my set that yours needs.  

Yes please.

	tglx


