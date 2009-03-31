Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbZCaBfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbZCaBfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 21:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbZCaBfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 21:35:01 -0400
Received: from ozlabs.org ([203.10.76.45]:41741 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbZCaBfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 21:35:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the default percpu allocator
Date: Tue, 31 Mar 2009 12:04:50 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>
References: <1236671631-9305-1-git-send-email-tj@kernel.org> <49D099F0.3000807@kernel.org> <20090330114938.GB10070@elte.hu>
In-Reply-To: <20090330114938.GB10070@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903311204.51774.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009 22:19:38 Ingo Molnar wrote:
> 
> * Tejun Heo <tj@kernel.org> wrote:
...
> We also need the Ack from Davem for Sparc32, the Ack from Martin, an 
> Ack from Ben for the PowerPC bits and an ack from Tony for the IA64 
> bits. We also need the ack from Andrew and Rusty for the MM and 
> module bits.

Module bits are trivial, but Acked-by: Rusty Russell <rusty@rustcorp.com.au>
just in case :)

Thanks!
Rusty.
