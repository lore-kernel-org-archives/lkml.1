Return-Path: <linux-kernel-owner+w=401wt.eu-S933309AbXAaRza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933309AbXAaRza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933317AbXAaRza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:55:30 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:59222 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933309AbXAaRz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:55:29 -0500
Message-ID: <45C0D80D.2010404@garzik.org>
Date: Wed, 31 Jan 2007 12:55:25 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Roland Dreier <rdreier@cisco.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com> <20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com> <Pine.LNX.4.61.0701311849490.13737@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0701311849490.13737@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jan 30 2007 14:00, Roland Dreier wrote:
>> An uncharitable vendor might decide it's not worth publishing specs,
>> since the Linux guys can reverse engineer the Windows driver just as
>> fast anyway.
> 
> And ndiswrapper gives fire to just releasing the Windows one :(

Logically this makes sense from a user perspective, but I tend to doubt 
ndiswrapper is really a motivator for a vendor?  One would think that 
vendors would rather not have a crash-y solution for their hardware.

	Jeff



