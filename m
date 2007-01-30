Return-Path: <linux-kernel-owner+w=401wt.eu-S1751596AbXA3WMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbXA3WMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXA3WMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:12:34 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50929 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbXA3WMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:12:33 -0500
Message-ID: <45BFC2CF.8010603@garzik.org>
Date: Tue, 30 Jan 2007 17:12:31 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>	<45BFA087.6020905@garzik.org> <ada4pq8qjpd.fsf@cisco.com>	<20070130214759.GA12477@kroah.com> <adar6tcp43r.fsf@cisco.com>
In-Reply-To: <adar6tcp43r.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Sure, Ralink drivers will get upstream eventually.  But by the time
> the drivers get merged, Ralink will have stopped making the chips that
> it supports (or so I read, http://www.linuxemporium.co.uk/products/wireless/)!
> I don't think that taking a year or two to merge a driver is going to
> impress a vendor, especially since the reverse-engineered Broadcom
> wireless driver is probably going to go upstream at just about the
> same time.

You mean the bcm43xx wireless driver that's been upstream for months?


> An uncharitable vendor might decide it's not worth publishing specs,
> since the Linux guys can reverse engineer the Windows driver just as
> fast anyway.

Most vendors are likely to focus on examples that are in the statistical 
(and competitive) majority, where publishing specs led to a driver 
supported by an enterprise distro.

	Jeff


