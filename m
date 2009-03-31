Return-Path: <linux-kernel-owner+w=401wt.eu-S1765083AbZDAASh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765083AbZDAASh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759371AbZDAASL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:18:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:41851 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762094AbZDAASJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:18:09 -0400
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
 default percpu allocator
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org, rth@twiddle.net,
       ink@jurassic.park.msu.ru, heiko.carstens@de.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <200903311204.51774.rusty@rustcorp.com.au>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
	 <49D099F0.3000807@kernel.org> <20090330114938.GB10070@elte.hu>
	 <200903311204.51774.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Wed, 01 Apr 2009 10:49:15 +1100
Message-Id: <1238543355.17330.78.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 12:04 +1030, Rusty Russell wrote:
> On Monday 30 March 2009 22:19:38 Ingo Molnar wrote:
> > 
> > * Tejun Heo <tj@kernel.org> wrote:
> ...
> > We also need the Ack from Davem for Sparc32, the Ack from Martin, an 
> > Ack from Ben for the PowerPC bits and an ack from Tony for the IA64 
> > bits. We also need the ack from Andrew and Rusty for the MM and 
> > module bits.
> 
> Module bits are trivial, but Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> just in case :)

PPC32 bits look ok unless I missed something... oh well.

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>


