Return-Path: <linux-kernel-owner+w=401wt.eu-S1423075AbXBUUMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423075AbXBUUMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:12:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423065AbXBUUMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:12:22 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41739 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423061AbXBUUMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:12:21 -0500
Date: Wed, 21 Feb 2007 12:09:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/21] 2.6.19-stable review
In-Reply-To: <20070221114737.a09be761.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702211208500.4043@woody.linux-foundation.org>
References: <20070221013619.GA30227@kroah.com> <45DC9E1D.40805@redhat.com>
 <20070221114737.a09be761.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 Feb 2007, Andrew Morton wrote:
> > 
> > http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-simplfy-__assign_irq_vector.patch
> > http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/broken-out/x86_64-mm-handle-irqs-pending-in-irr-during-irq-migration.patch
> 
> That's mainly an Andi decision.  Let's cc him.

Would be good to have Eric also ack them as safe and obvious.

Btw, that latter one has corrupted sign-offs from Andi (it's in the middle 
of the text, very confusing).

		Linus
