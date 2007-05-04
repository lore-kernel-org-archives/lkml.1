Return-Path: <linux-kernel-owner+w=401wt.eu-S1031549AbXEDU3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031549AbXEDU3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031547AbXEDU3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:29:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51499 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031535AbXEDU3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 16:29:09 -0400
Message-ID: <463B978C.6050303@garzik.org>
Date: Fri, 04 May 2007 16:29:00 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, a.p.zijlstra@chello.nl
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
       trond.myklebust@fys.uio.no, tgraf@suug.ch, James.Bottomley@SteelEye.com,
       michaelc@cs.wisc.edu, akpm@linux-foundation.org, phillips@google.com
Subject: Re: [PATCH 00/40] Swap over Networked storage -v12
References: <20070504102651.923946304@chello.nl>	<20070504.122716.31641374.davem@davemloft.net>	<1178307709.2767.19.camel@lappy> <20070504.130239.38710262.davem@davemloft.net>
In-Reply-To: <20070504.130239.38710262.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri, 04 May 2007 21:41:49 +0200
> 
>> How would you prefer I present these?
> 
> How about 8 or 9 at a time?  You are building infrastructure
> and therefore you could post them 1 at a time for review
> since each patch should be able to stand on it's own.

Indeed.  Just glancing over the patchset, there are quite a few "easy to 
apply" cleanup patches that could be fast-forwarded to upstream, without 
requiring deep thought on the swap-over-storage MM changes or net 
allocator changes.

	Jeff



