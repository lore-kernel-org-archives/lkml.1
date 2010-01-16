Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab0APEcr (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 23:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756921Ab0APEcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 23:32:46 -0500
Received: from snt0-omc3-s2.snt0.hotmail.com ([65.55.90.141]:12063 "EHLO
	snt0-omc3-s2.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754008Ab0APEcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 23:32:45 -0500
X-Originating-IP: [96.253.143.208]
X-Originating-Email: [yuhongbao_386@hotmail.com]
Message-ID: <SNT125-DS159A43E33091193EE3624DC3680@phx.gbl>
From: <yuhongbao_386@hotmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: <hpa@zytor.com>, <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
References: <SNT125-W41CEF6892DBE0B1FD99B4AC3780@phx.gbl>,<4B511B12.6010208@zytor.com> <SNT125-W39A63687E4BE4F52FAA517C3680@phx.gbl> <alpine.LFD.2.00.1001151946460.13231@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001151946460.13231@localhost.localdomain>
Subject: Re: Ubuntu 32-bit, 32-bit PAE, 64-bit Kernel Benchmarks
Date: Fri, 15 Jan 2010 20:32:40 -0800
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8089.726
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8089.726
X-OriginalArrivalTime: 16 Jan 2010 04:32:45.0489 (UTC) FILETIME=[F337B210:01CA9664]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Unfortunately most desktop/laptop systems nowadays ship with more than
>> 1GB.Luckily, in the case of Atom netbooks that Linus mentioned, most
>> Atom netbooks ship with only 1GB of RAM
>
> Not the ones I have. If they had only 1GB of RAM when I got them, they got
> upgraded.

That is why I said "ship with", I know that most netbooks can be upgraded to 
2GB of RAM.
For most netbooks, that is the limit due to for one thing chipset limits, 
even the new Atom N400 series has a 2GB limit in it's on-die memory 
controller. At least it support 64-bit unlike the older N200 series without 
the on-die northbridge.

Yuhong Bao 

