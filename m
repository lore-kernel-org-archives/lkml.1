Return-Path: <linux-kernel-owner+w=401wt.eu-S1422743AbXBAKIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422743AbXBAKIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 05:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422742AbXBAKIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 05:08:55 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:37630 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422740AbXBAKIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 05:08:54 -0500
Message-ID: <45C1BC2D.8020405@garzik.org>
Date: Thu, 01 Feb 2007 05:08:45 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Lee Revell <rlrevell@joe-job.com>
CC: Mark Lord <lkml@rtr.ca>, Randy Dunlap <randy.dunlap@oracle.com>,
       Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org>	 <20070131201258.GB15128@kroah.com> <20070131230014.GD20514@thunk.org>	 <20070131150451.070fa90f.randy.dunlap@oracle.com>	 <45C13DAB.5090305@rtr.ca> <75b66ecd0701311739y5b9ebf52h296a9435a769bf1d@mail.gmail.com>
In-Reply-To: <75b66ecd0701311739y5b9ebf52h296a9435a769bf1d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Revell wrote:
> On 1/31/07, Mark Lord <lkml@rtr.ca> wrote:
>> I believe a BIG reason why lots of open-source drivers are out-of-tree
>> right now, is because lkml is perceived as being wayyyyyy too fussy
>> and petty about 80-column lines, brackets, etc.. for new code.
>>
>> It's just not worth the effort/abuse for many maintainers to pursue it.
> 
> That seems like the easy part - it seems like anyone bright enough to
> write a working Linux driver would be good enough with their editor or
> perl or bash to knock that out in 10 minutes.


Or simply running it through scripts/Lindent, which fixes 97% of all 
issues automatically.  The remaining 3% become fixing Lindent's lack of 
C99 knowledge, etc.

	Jeff


