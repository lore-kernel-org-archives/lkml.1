Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbXEQOxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbXEQOxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbXEQOxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:53:42 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:36958 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbXEQOxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:53:41 -0400
Date: Thu, 17 May 2007 16:51:09 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Greg KH <greg@kroah.com>
cc: ark3116_driver@auctionant.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] ark3116: receive returns negative
In-Reply-To: <Pine.LNX.4.61.0705171529570.3231@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0705171646130.3231@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705161743250.9570@yvahk01.tjqt.qr>
 <20070517124525.GC20055@kroah.com> <Pine.LNX.4.61.0705171529570.3231@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 17 2007 16:10, Jan Engelhardt wrote:
>Hi Greg,
>
>>But does the driver seem to work properly?
>>Do you get data through the device properly?

I have taken a voltmeter and an appropriate testcase program - and yes,
at least transmit works.

>USB-RS232-GenderChanger-RS232-USB.

A faulty setup that is. My bad.



	Jan
-- 
