Return-Path: <linux-kernel-owner+w=401wt.eu-S965224AbXAYDFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965224AbXAYDFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 22:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965236AbXAYDFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 22:05:14 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:53053 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965224AbXAYDFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 22:05:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:in-reply-to:references:mime-version:content-type:message-id:cc:content-transfer-encoding:from:subject:date:to:x-mailer;
        b=BbnYNDhFAcHuGGgMo3nbg6wtTq/L0Hei6Z0cZ9Q8S8W+/WiVkSmltXlraVsNcLH6VTQg3WTnl+4qFl+Jy4dcLZMiHMCJnFuZc/lqcixjq+GbHh/ctP6Ph3Eb7PdijnUi732/yB60htcZGGMKutZG4sYVkpyWy1AjWbsSlo4U6s4=
In-Reply-To: <559149.89346.qm@web52906.mail.yahoo.com>
References: <559149.89346.qm@web52906.mail.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=WINDOWS-1252; delsp=yes; format=flowed
Message-Id: <973C1FB2-7B4D-4A46-B5DA-4B04AB3444F6@gmail.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: Mark Rustad <mrustad@gmail.com>
Subject: Re: 2.6.18-stable release plans?
Date: Wed, 24 Jan 2007 21:05:04 -0600
To: Chris Rankin <rankincj@yahoo.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 24, 2007, at 5:45 PM, Chris Rankin wrote:
>> --- Mark Rustad <mrustad@gmail.com> wrote:
>> Exactly. Halting use of a version of the kernel based on a single
>> incident provides no insight to the source of the problem. It could
>> be anything...
>
> There is a world of difference between a polite request for more  
> information (although I gave you
> everything I had), and fobbing someone off with a story about  
> cosmic rays.

I'm sorry. I didn't mean to imply anything like that. I just happened  
to notice that the date of the bug report appeared to correlate  
pretty well with one of the solar flare events last month. I was  
really trying to share some information that just conceivably might  
have been related, based on the earlier messages in this thread  
regarding memory errors.

I don't normally follow solar activity. I have been looking into some  
system failures that happened last month. The systems had been  
running with all bus error detection enabled – the hardware set to  
spontaneously reboot on any uncorrectable error. Since our systems  
are redundant, performing a reset simply means that the redundant  
partner will take over, so the reset is the best way to be certain  
that there is no data corruption. I eventually recalled a radio  
report last month about a coronal mass ejection on the sun and how  
things might be disrupted here. I checked out www.spaceweather.com  
and found that December was a very active month, with three separate  
X-class flares. I have no way to conclude that the failures that I  
have seen were influenced by events on the sun, but it seems  
possible. Compared to our systems, most PCs and even much server- 
class hardware systems are likely to corrupt a bit just keep on going.

We'll never know if any of these things were correlated with the  
solar flares because they all seem to be one-off failures. I do find  
it interesting though. Our systems seem to be doing statistically  
better this month. What do you think?

-- 
Mark Rustad, MRustad@mac.com



