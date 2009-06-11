Return-Path: <linux-kernel-owner+w=401wt.eu-S1757112AbZFKSE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112AbZFKSE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbZFKSEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:04:32 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:48858 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbZFKSEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:04:31 -0400
Message-ID: <4A314729.8030605@davidnewall.com>
Date: Fri, 12 Jun 2009 03:34:25 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
References: <20090611160329.GA3366@elte.hu>  <20090611161714.GA5008@infradead.org>  <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> <1244738098.27363.36.camel@violet> <alpine.LFD.2.01.0906110937110.3573@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906110937110.3573@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Thu, 11 Jun 2009, Marcel Holtmann wrote:
>   
>> so do you expect us to merge stuff like ip, iw, rfkill, crda, the WiMAX
>> tools, the Bluetooth ones and whatever we have that are all have the
>> same issues to be merged into the kernel source code as well.
>>     
>
> No. Only stuff that I expect to be really close to hardware, and used for 
> kernel purposes.

Whilst having no opinion on the matter, I can't help noticing that Ingo
said its "main focus is on measuring/profilig user-space apps" (sic), so
I think its use is not for kernel purposes. Coupled with Christoph's
observation that the tool is nowhere close to the hardware, it appears
neither of your two criteria apply to this.
