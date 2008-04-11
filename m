Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbYDKA13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbYDKA13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 20:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYDKA1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 20:27:18 -0400
Received: from rtr.ca ([76.10.145.34]:1030 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbYDKA1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 20:27:17 -0400
Message-ID: <47FEB062.3020003@rtr.ca>
Date: Thu, 10 Apr 2008 20:27:14 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: jesper.juhl@gmail.com, tilman@imap.cc, yoshfuji@linux-ipv6.org,
       jeff@garzik.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.25-rc8: FTP transfer errors
References: <9a8748490804101509l5d043ff8w565dc44dfeaf0072@mail.gmail.com>	<20080410.154651.101700010.davem@davemloft.net>	<47FEADCB.7070104@rtr.ca> <20080410.172453.44434205.davem@davemloft.net>
In-Reply-To: <20080410.172453.44434205.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Mark Lord <lkml@rtr.ca>
> Date: Thu, 10 Apr 2008 20:16:11 -0400
> 
>> Duh.. more like, "If I take 5-8 hours to attempt a bisect (which may not
>> even work), then that's 5-8 hours I do not get paid for."
> 
> And if I invest my spare time on your bug
> how does this statement apply to me?
..

It's not "my bug".  I'm just the first person to notice,
take time to report it, and even hand it to you on a platter (bisect).

It's *your* bug -- you signed off on the commit.

Cheers
