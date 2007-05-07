Return-Path: <linux-kernel-owner+w=401wt.eu-S965853AbXEGQcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965853AbXEGQcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 12:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965838AbXEGQcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 12:32:48 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46627 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965795AbXEGQcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 12:32:47 -0400
Date: Mon, 7 May 2007 09:31:10 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86-64 highres/dyntick support
Message-ID: <20070507163110.GP3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178485128.31213.98.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner (tglx@linutronix.de) wrote:
> I'm pleased to announce the first cut of the final x86_64
> highres/dyntick support, which I did based on Chris Wright's patch set,
> which is again based on Arjan van de Ven's initial work:

Cool.  I had finished mine as well, just didn't get time to polish
and resubmit.  Going through to see where we differ and if there's
any bits of my set that yours needs.  

thanks,
-chris
