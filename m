Return-Path: <linux-kernel-owner+w=401wt.eu-S1751811AbXB0U2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbXB0U2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbXB0U2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:28:14 -0500
Received: from kirby.webscope.com ([204.141.84.54]:57873 "EHLO
	kirby.webscope.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbXB0U2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:28:12 -0500
Message-ID: <45E49329.5080509@linuxtv.org>
Date: Tue, 27 Feb 2007 15:23:05 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Chuck Ebbert <cebbert@redhat.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>
Subject: Re: [patch 0/9] 2.6.19-stable review
References: <20070227000538.GA6283@kroah.com>
In-Reply-To: <20070227000538.GA6283@kroah.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.19.6 release.
> 
> This will probably be the last release of the 2.6.19-stable series, so
> if there are patches that you feel should be applied to that tree,
> please let me know.
> 
> There are 9 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
> 
> These patches are sent out with a number of different people on the Cc:
> line.  If you wish to be a reviewer, please email stable@kernel.org to
> add your name to the list.  If you want to be off the reviewer list,
> also email us.
> 
> Responses should be made by Thursday March 1 00:00 UTC.  Anything
> received after that time might be too late.
> 
> The whole patch set can be downloaded at:
>         kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.19.6-rc1.gz
> 
> thanks,
> 
> the -stable release team

Greg,

I still have three DVB patches that need to go to 2.6.19.y, the dvbdev patch
being most important.  I sent this dvbdev patch to you during the 2.6.19.5
review period and expected it to surface this time around, but maybe our email
paths have crossed.

Since I am unable to send patches inline from my current location, I've posted
the three pending patches for 2.6.19.y here:

http://linuxtv.org/~mkrufky/stable/2.6.19.y/

Please add these if possible.  Again, the
"dvbdev-fix-illegal-re-usage-of-fileoperations-struct" patch is the most
important one of these.

---

For 2.6.20.y, I have seven patches waiting for the v4l-dvb subsystem trees.  I
have posted these patches here:

http://linuxtv.org/~mkrufky/stable/2.6.20.y/

If you can queue these up for the next 2.6.20.y release, that would be great.
Otherwise, if I don't see them added to the queue, I will send them inline to
you the next time I am at my own machine (a few days from now).

Regards,

Michael Krufky

