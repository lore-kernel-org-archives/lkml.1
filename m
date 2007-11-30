Return-Path: <linux-kernel-owner+w=401wt.eu-S934477AbXK3LSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477AbXK3LSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758250AbXK3LSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:18:21 -0500
Received: from mailgate.travel2.com ([217.33.104.102]:3299 "EHLO
	mailgate.travel2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661AbXK3LSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:18:20 -0500
X-Greylist: delayed 82918 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2007 06:18:19 EST
Message-ID: <474FF0FE.50208@stellatravel.co.uk>
Date: Fri, 30 Nov 2007 11:16:14 +0000
From: Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: loic.grenie@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
References: <474EAD18.6040408@stellatravel.co.uk> <9b06e8d20711300229r1ed570bfi9ecbb6466fd0a0ab@mail.gmail.com>
In-Reply-To: <9b06e8d20711300229r1ed570bfi9ecbb6466fd0a0ab@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: Ben.Crowhurst@stellatravel.co.uk
X-Spam-Processed: mailgate.travel2.com, Fri, 30 Nov 2007 11:17:23 +0000
	(not processed: spam filter heuristic analysis disabled)
X-MDRemoteIP: 10.166.136.173
X-Return-Path: Ben.Crowhurst@stellatravel.co.uk
X-Envelope-From: Ben.Crowhurst@stellatravel.co.uk
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: Ben.Crowhurst@stellatravel.co.uk
X-MDAV-Processed: mailgate.travel2.com, Fri, 30 Nov 2007 11:17:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Loïc Grenié wrote:
> 2007/11/29, Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>:
>   
>> Has Objective-C ever been considered for kernel development?
>>
>> regards,
>> BPC
>>     
>
>    No, it has not. Any language that looks remotely like an OO language
>   has not ever been considered for (Linux) kernel development and for
>   most, if not all, other operating systems kernels.
>
>     Various problems occur in an object oriented language. One of them
>   is garbage collection: it provokes asynchronous delays and, during
>   an interrupt or a system call for a real time task, the kernel cannot
>   wait. 
Objective C 1.0 does not force nor have garbage collection.

> Another is memory overhead: all the magic that OO languages
>   provide take space in memory and Linux kernel is used in embedded
>   systems with very tight memory requirements.
>   
But are embedded systems not rapidly moving on. Turning to stare at the 
ADSL X6 modem with MB's of ram.
>     Lots of people will think of better reasons why ObjC is not used...
>
>         Loïc Grenié
>
>
>   
Which I'm looking forward to hear :)

Thank you for your appropriate response.

--

Regards
BPC


