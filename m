Return-Path: <linux-kernel-owner+w=401wt.eu-S964980AbXBOHlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964980AbXBOHlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 02:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964981AbXBOHlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 02:41:20 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:34776 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964980AbXBOHlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 02:41:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Qa0VOwQDzp87c9TPbcYez0SftlgJ3C7TJdEKQv+zswZhCwuvoA8+ORKY0djizYcrWsK6OF/+NTSevZxbpShWibtuLnR2rQ/LtX73+7Yv18LXVES6WEb2SMsU9p+Vll0NyREweHbioNPS2gLnfMJYxwX0H9L3fUVoLmmC29tCDxw=  ;
X-YMail-OSG: 2XCMvL4VM1n8_qF4YLEQ2Bi2tYUkescFcq7_dJPiy9SyGTgdkcgiNQIgwr3wbhVBedybXFI9SqinvLm35zsqS7bwlf3SMe6r.X9cVJJ965pxnmTYrcUiZDcJbcMzlpIXgigFHIvXvlrZzJQ-
Message-ID: <45D40E81.3050506@yahoo.com.au>
Date: Thu, 15 Feb 2007 18:40:49 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ben Nizette <ben.nizette@iinet.net.au>
CC: v j <vj.linux@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: GPL vs non-GPL device drivers
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com> <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com> <45D3FC67.3000903@iinet.net.au>
In-Reply-To: <45D3FC67.3000903@iinet.net.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Nizette wrote:
> v j wrote:
> 
>> This is in reference to the following thread:
>>
>> http://lkml.org/lkml/2006/12/14/63
>>
>> I am not sure if this is ever addressed in LKML, but linux is _very_
>> popular in the embedded space. We (an embedded vendor) chose Linux 3
>> years back because of its lack of royalty model, robustness and
>> availability of infinite number of open-source tools.
> 
> [...]
> 
>> However we have a worrying trend here. If at some point it becomes
>> illegal to load our modules into the linux kernel, then it is
>> unacceptable to us. We would have been better off choosing VxWorks or
>> OSE 3 years ago when we made an OS choice. The fact that Linux is
>> becoming more and more closed is very very alarming.
>>
> Question to the world here:  Distros make, as a matter of course, a 
> series of modifications to the Linux Kernel so that their modules or 
> features work.  What stops VJ making a patchset which effectively 
> s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/g 's the kernel source then 
> distributing that under the GPL?  He then supplies his un-GPL'd modules 
> to the world which just happen to only run on the modified kernel.  I've 
> read the GPL of course (IANAL though) and I can't see what this violates 
> except the /spirit/ of the license.  Don't get me wrong, I'm strongly 
> against anyone doing what I just mentioned, I believe it to be immoral 
> taking someone's GPL'd code and mangling it in such a way.  I speak as 
> an embedded developer myself whose company decided that running our code 
> under Linux and distributing our code under the GPL was far preferable 
> to running closed-source software on a closed-source platform.

The best bet would be to read up on lots of past discussions related to
exactly these kinds of questions, then ask your Lawyer.

Rhetorical question: what stops me from taking somebody's copyrighted
work, stripping the copyrights or falsely claiming to have a license
to redistribute it, then selling it?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
