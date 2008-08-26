Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbYHZSdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbYHZSdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 14:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756581AbYHZSdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 14:33:20 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:35043 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYHZSdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:33:19 -0400
Subject: Re: [PATCH] 2.6.27-rc4-git3: make section names compatible with
	-ffunction-sections -fdata-sections
From: Daniel Walker <dwalker@mvista.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, x86@kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
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
In-Reply-To: <200808250118.08406.vda.linux@googlemail.com>
References: <200808250118.08406.vda.linux@googlemail.com>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 11:33:05 -0700
Message-Id: <1219775585.3797.2.camel@dhcp32.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-25 at 01:18 +0200, Denys Vlasenko wrote:
> Hi Andrew,
> 
> You asked me to maintain it and resubmit when
> merge frenzy is over.
> 
> Here is the update against current Linus tree
> (which is 2.6.27-rc4-git3), rolled up into one patch.


Do you have the patches that actually use
-ffunction-sections,-fdata-sections updated someplace?

Daniel

