Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZC3O5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZC3O5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZC3O5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:57:30 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:45332 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZC3O5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:57:30 -0400
Date: Mon, 30 Mar 2009 10:50:41 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Tejun Heo <tj@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the
 default percpu allocator
In-Reply-To: <20090330114938.GB10070@elte.hu>
Message-ID: <alpine.DEB.1.10.0903301049060.13333@qirst.com>
References: <1236671631-9305-1-git-send-email-tj@kernel.org> <20090316190132.7965a49a@skybase> <49C300D8.5080204@kernel.org> <49C8FAC4.6060508@kernel.org> <20090325122738.42d105b7@skybase> <49CA1AC3.9080908@kernel.org> <20090325150035.541e707a@skybase>
 <49CA3C2C.5030702@kernel.org> <49D099F0.3000807@kernel.org> <20090330114938.GB10070@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Ingo Molnar wrote:

> We also need the Ack from Davem for Sparc32, the Ack from Martin, an
> Ack from Ben for the PowerPC bits and an ack from Tony for the IA64
> bits. We also need the ack from Andrew and Rusty for the MM and
> module bits. Plus a final Reviewed-by of the all-architectures
> percpu allocator concepts from Christoph and Nick would be nice as
> well, just in case we missed some trick or failed to consider a
> complication.

I just started looking at this but I see that the patches were already
merged. Will see if I can find what needs looking after.

