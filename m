Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYGRI36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYGRI36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbYGRI3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:29:34 -0400
Received: from ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk ([217.169.26.28]:59070
	"EHLO ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853AbYGRI3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:29:32 -0400
Date: Fri, 18 Jul 2008 09:14:00 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, x86@kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
Subject: Re: [PATCH] (updated, rolled up) make section names compatible
	with -ffunction-sections -fdata-sections
Message-ID: <20080718081400.GB21656@linux-mips.org>
References: <200807172213.37411.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807172213.37411.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 10:13:37PM +0200, Denys Vlasenko wrote:

> I would like to ask arch maintainers to ACK/NAK this patch,
> and Andrew to act accordingly.

MIPS bits are looking good:

Acked-by: Ralf Baechle <ralf@linux-mips.org>

Is this patch intended to go to Linus for 2.6.27?

  Ralf
