Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYJHIYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYJHIYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 04:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbYJHIXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 04:23:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54637 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbYJHIXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 04:23:42 -0400
Subject: Re: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes
	(Re: 2.6.27-rc8+ - first impressions)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jason Vas Dias <jason.vas.dias@gmail.com>
In-Reply-To: <87tzbpmocm.fsf@basil.nowhere.org>
References: <20081005183603.GA3263@amd.corenet.prv>
	 <200810060029.42471.rjw@sisk.pl> <20081006062235.GA2808@amd.corenet.prv>
	 <200810061159.30103.rjw@sisk.pl>
	 <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org>
	 <20081006150055.GA16930@elte.hu>
	 <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org>
	 <87tzbpmocm.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 10:23:22 +0200
Message-Id: <1223454202.1378.38.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-06 at 22:59 +0200, Andi Kleen wrote:

> The real reason is actually a workaround in the BIOS for problems
> in the older Linux code that caused duplicated timer interrupts.

That really made me blink - so instead of fixing Linux they fudged their
BIOS?

*utter amazement*

