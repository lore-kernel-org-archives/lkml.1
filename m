Return-Path: <linux-kernel-owner+w=401wt.eu-S1758635AbYDULS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbYDULS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 07:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757637AbYDULSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 07:18:42 -0400
Received: from stinky.trash.net ([213.144.137.162]:37641 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420AbYDULSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 07:18:41 -0400
Message-ID: <480C780C.2030402@trash.net>
Date: Mon, 21 Apr 2008 13:18:36 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [bug] build failure in net/netfilter/nf_conntrack_sip.c, on	latest
 -git
References: <20080419100034.GA9475@elte.hu> <20080419.030337.244502148.davem@davemloft.net> <20080419103942.GA13599@elte.hu> <20080419.040945.13369499.davem@davemloft.net> <20080421082254.GA2522@elte.hu>
In-Reply-To: <20080421082254.GA2522@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * David Miller <davem@davemloft.net> wrote:
> 
>> You got a bug fix in 5 minutes after sending your email to the lists, 
>> and since you sent it to lkml anybody can find it, so I don't see what 
>> the big deal is.
> 
> for the last 3 days my own automated bug finding capacity is at 10% of 
> its normal throughput (it booted only 200 kernels, instead of 2000 
> kernels) - which is OK in early phases of the merge window, but you seem 
> to deny that i have any standing to argue development process issues.


In my perception networking is not doing worse than other subsystems,
this (small) accumulation of build-bugs seems more like an unfortunate
coincidence caused by two people being sloppy during testing (me and
the LED guys).


