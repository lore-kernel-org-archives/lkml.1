Return-Path: <linux-kernel-owner+w=401wt.eu-S1763031AbXFAT0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763031AbXFAT0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762095AbXFAT0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:26:23 -0400
Received: from waste.org ([66.93.16.53]:40680 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761943AbXFAT0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:26:22 -0400
Date: Fri, 1 Jun 2007 14:25:08 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Daniel Walker <dwalker@mvista.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
Message-ID: <20070601192508.GN11166@waste.org>
References: <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com> <20070530134907.GA27085@elte.hu> <1180544796.32594.184.camel@imap.mvista.com> <1180545380.2958.1.camel@lappy> <1180545913.32594.194.camel@imap.mvista.com> <20070601131249.GA17059@elte.hu> <1180711606.15884.32.camel@imap.mvista.com> <1180713154.5676.4.camel@lappy> <1180714263.15884.52.camel@imap.mvista.com> <20070601183053.GA30072@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601183053.GA30072@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 08:30:53PM +0200, Ingo Molnar wrote:
>  - better scheduling
>  - better printk timestamps
>  - higher-quality blktrace timestamps
- more entropy in /dev/random

-- 
Mathematics is the supreme nostalgia of our time.
