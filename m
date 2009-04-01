Return-Path: <linux-kernel-owner+w=401wt.eu-S1765828AbZDAAXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765828AbZDAAXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 20:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765675AbZDAAWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 20:22:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:49032 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765621AbZDAAWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 20:22:20 -0400
Message-ID: <49D2B2FA.2020208@kernel.org>
Date: Wed, 01 Apr 2009 09:19:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the default
 percpu allocator
References: <1236671631-9305-1-git-send-email-tj@kernel.org>	 <49D099F0.3000807@kernel.org> <20090330114938.GB10070@elte.hu>	 <200903311204.51774.rusty@rustcorp.com.au> <1238543355.17330.78.camel@pasglop>
In-Reply-To: <1238543355.17330.78.camel@pasglop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 00:19:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Tue, 2009-03-31 at 12:04 +1030, Rusty Russell wrote:
>> On Monday 30 March 2009 22:19:38 Ingo Molnar wrote:
>>> * Tejun Heo <tj@kernel.org> wrote:
>> ...
>>> We also need the Ack from Davem for Sparc32, the Ack from Martin, an 
>>> Ack from Ben for the PowerPC bits and an ack from Tony for the IA64 
>>> bits. We also need the ack from Andrew and Rusty for the MM and 
>>> module bits.
>> Module bits are trivial, but Acked-by: Rusty Russell <rusty@rustcorp.com.au>
>> just in case :)
> 
> PPC32 bits look ok unless I missed something... oh well.
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cool, all thread ACKs added.

Thanks.

-- 
tejun
