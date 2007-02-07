Return-Path: <linux-kernel-owner+w=401wt.eu-S1422740AbXBGVOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422740AbXBGVOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 16:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422771AbXBGVOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 16:14:06 -0500
Received: from kirby.webscope.com ([204.141.84.54]:55400 "EHLO
	kirby.webscope.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422740AbXBGVOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 16:14:05 -0500
Message-ID: <45CA3FBD.70407@linuxtv.org>
Date: Wed, 07 Feb 2007 16:08:13 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Chris Wright <chrisw@sous-sol.org>, torvalds@osdl.org, akpm@osdl.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: [stable] [patch 00/50] -stable review
References: <20070106022753.334962000@sous-sol.org> <45C624D2.9030403@linuxtv.org> <20070205214332.GB18230@kroah.com> <45C7ACAB.6060408@linuxtv.org> <20070205223304.GA19793@kroah.com>
In-Reply-To: <20070205223304.GA19793@kroah.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

>>> I'll go through the archives and see if there's enough to do a .18
>>> release (and the patches are serious enough to warrent it.)
>> Actually, I have a few more -stable patches for both 2.6.18.y and 2.6.19.y, if
>> you don't mind holding off a day or two (wont have time to prepare these until
>> tomorrow evening)...  One of them is a security fix, that allows a non-root user
>> to hang the kernel given the correct circumstances.
> 
> Ok, that's serious enough :)
> 
> I'll wait for your patches.
> 
> thanks,
> 
> greg k-h

I've uploaded the remaining pending v4l/dvb -stable patches for both 2.6.18.y
and 2.6.19.y to the following locations:

http://linuxtv.org/~mkrufky/stable/2.6.18.y/ (8 patches)

and

http://linuxtv.org/~mkrufky/stable/2.6.19.y/ (5 patches)

Using the mailer at my current location, I am unable to send patches inline, and
I won't have the time for it this evening.  In the interest of saving time, I
figured that sending them to you in this method is good enough.  If you still
need for me to send them via email inline, please let me know.

Best Regards,

Michael Krufky

