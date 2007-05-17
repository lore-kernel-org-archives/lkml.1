Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbXEQPCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbXEQPCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 11:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbXEQPCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 11:02:20 -0400
Received: from canuck.infradead.org ([209.217.80.40]:46793 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756778AbXEQPCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 11:02:18 -0400
Date: Thu, 17 May 2007 07:58:49 -0700
From: Greg KH <greg@kroah.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: ark3116_driver@auctionant.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] ark3116: receive returns negative
Message-ID: <20070517145849.GA3282@kroah.com>
References: <Pine.LNX.4.61.0705161743250.9570@yvahk01.tjqt.qr> <20070517124525.GC20055@kroah.com> <Pine.LNX.4.61.0705171529570.3231@yvahk01.tjqt.qr> <Pine.LNX.4.61.0705171646130.3231@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705171646130.3231@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 04:51:09PM +0200, Jan Engelhardt wrote:
> 
> On May 17 2007 16:10, Jan Engelhardt wrote:
> >Hi Greg,
> >
> >>But does the driver seem to work properly?
> >>Do you get data through the device properly?
> 
> I have taken a voltmeter and an appropriate testcase program - and yes,
> at least transmit works.
> 
> >USB-RS232-GenderChanger-RS232-USB.
> 
> A faulty setup that is. My bad.

You forgot the NULL modem inverter :)

thanks,

greg k-h
