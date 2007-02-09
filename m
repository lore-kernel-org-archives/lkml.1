Return-Path: <linux-kernel-owner+w=401wt.eu-S2992779AbXBITpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992779AbXBITpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992774AbXBITpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:45:05 -0500
Received: from kirby.webscope.com ([204.141.84.54]:46052 "EHLO
	kirby.webscope.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423258AbXBITpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:45:03 -0500
Message-ID: <45CCCE51.8090103@linuxtv.org>
Date: Fri, 09 Feb 2007 14:41:05 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Chris Wright <chrisw@sous-sol.org>, stable@kernel.org,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [patch 00/50] -stable review
References: <20070106022753.334962000@sous-sol.org> <45C624D2.9030403@linuxtv.org> <20070205214332.GB18230@kroah.com> <45C7ACAB.6060408@linuxtv.org> <20070205223304.GA19793@kroah.com> <45CA3FBD.70407@linuxtv.org>
In-Reply-To: <45CA3FBD.70407@linuxtv.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Krufky wrote:
> Greg KH wrote:
> 
>>>> I'll go through the archives and see if there's enough to do a .18
>>>> release (and the patches are serious enough to warrent it.)
>>> Actually, I have a few more -stable patches for both 2.6.18.y and 2.6.19.y, if
>>> you don't mind holding off a day or two (wont have time to prepare these until
>>> tomorrow evening)...  One of them is a security fix, that allows a non-root user
>>> to hang the kernel given the correct circumstances.
>> Ok, that's serious enough :)
>>
>> I'll wait for your patches.
>>
>> thanks,
>>
>> greg k-h
> 
> I've uploaded the remaining pending v4l/dvb -stable patches for both 2.6.18.y
> and 2.6.19.y to the following locations:
> 
> http://linuxtv.org/~mkrufky/stable/2.6.18.y/ (8 patches)
> 
> and
> 
> http://linuxtv.org/~mkrufky/stable/2.6.19.y/ (5 patches)
> 
> Using the mailer at my current location, I am unable to send patches inline, and
> I won't have the time for it this evening.  In the interest of saving time, I
> figured that sending them to you in this method is good enough.  If you still
> need for me to send them via email inline, please let me know.

Greg & Chris,

I haven't heard from either of you about these patches, nor have I seen any
update to the stable-queue.

Just for clarification, the security fix patch, that prevents a non-root user
from hanging the kernel is the patch entitled,

"V4L: buf_qbuf: fix videobuf_queue->stream corruption and lockup"

...as per Mauro's description, here:

http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg113820.html

Regards,

Michael Krufky

