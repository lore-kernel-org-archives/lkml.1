Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbXI1R0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbXI1R0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbXI1R0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:26:43 -0400
Received: from xenotime.net ([66.160.160.81]:33785 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753160AbXI1R0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:26:42 -0400
Date: Fri, 28 Sep 2007 10:26:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-Id: <20070928102637.fabb09bd.rdunlap@xenotime.net>
In-Reply-To: <20070928132138.GG18163@shadowen.org>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky>
	<20070928084003.GA18882@elte.hu>
	<20070928020132.f6c6f528.akpm@linux-foundation.org>
	<20070928092235.GA31180@shadowen.org>
	<20070928093902.GA28455@elte.hu>
	<20070928100024.GB18163@shadowen.org>
	<20070928104935.GA606@elte.hu>
	<20070928132138.GG18163@shadowen.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 14:21:38 +0100 Andy Whitcroft wrote:

> Anyhow.  I have already added a --check/--no-check option which controls
> the more subjective tests which will be in the next release; though its
> likely the option name will be something more useful by then.
> 
> The only question is whether this should default to on.  You are voting
> off.  I personally think on.
> 
> Andrew?  Randy?  Joel?

I think that if someone wants --verbose mode (--noisy, --beginner),
they should have to ask for it.

---
~Randy
