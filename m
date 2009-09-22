Return-Path: <linux-kernel-owner+w=401wt.eu-S1751801AbZIVTGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbZIVTGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZIVTGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:06:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60582 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbZIVTGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:06:16 -0400
Date: Tue, 22 Sep 2009 21:04:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Alok Kataria <akataria@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Paravirtualization on VMware's Platform [VMI].
Message-ID: <20090922190419.GA24542@elte.hu>
References: <20090919224430.GB9567@kroah.com> <1253419185.3253.21.camel@ank32.eng.vmware.com> <20090920074247.GA5733@elte.hu> <20090920095239.456ad6f2@infradead.org> <4AB5EF25.9070502@redhat.com> <4AB64EFC.10707@goop.org> <20090922080913.GB1475@elte.hu> <4AB900CC.7090409@goop.org> <20090922180216.GA16789@elte.hu> <4AB91478.2050508@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB91478.2050508@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 09/22/09 11:02, Ingo Molnar wrote:
>
> > obviously they are workload dependent - that's why numbers were 
> > posted in this thread with various workloads. Do you concur with 
> > those conclusions that they are generally a speedup over paravirt? 
> > If not, which are the workloads where paravirt offers significant 
> > speedup over hardware acceleration?
> 
> We're not in a position to do any useful measurements yet.

Sorry for being dense, but what does that mean precisely? No available 
hardware? Xen doesnt run?

	Ingo
