Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbXEQSd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbXEQSd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758264AbXEQSdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:33:16 -0400
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:9633 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756558AbXEQSdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:33:15 -0400
In-Reply-To: <464C9E67.2020909@ru.mvista.com>
References: <200705172142.26739.sshtylyov@ru.mvista.com> <8E44DB06-767D-4864-8D2C-6132E4D4370B@kernel.crashing.org> <464C99FF.8080404@ru.mvista.com> <135307ED-7125-4859-8594-4B5B900D92D6@kernel.crashing.org> <464C9E67.2020909@ru.mvista.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6E0D5E13-C939-4FCE-81A3-F29DFA6436A2@kernel.crashing.org>
Cc: tglx@linutronix.de, mingo@elte.hu, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 2.6.21-rt2] PowerPC: decrementer clockevent driver
Date: Thu, 17 May 2007 13:31:24 -0500
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 17, 2007, at 1:26 PM, Sergei Shtylyov wrote:

> Hello.
>
> Kumar Gala wrote:
>
>> I haven't looked at all the new clock/timer code, is there any   
>> utility in having support for more than one clock source?
>
>    Of course, you may register as many as you like.

Sure, but is there any utility in registering more than the  
decrementer on PPC?

- k
