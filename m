Return-Path: <linux-kernel-owner+w=401wt.eu-S1761805AbYA1QQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761805AbYA1QQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761523AbYA1QQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:16:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43690 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761208AbYA1QQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:16:34 -0500
Date: Mon, 28 Jan 2008 08:13:30 -0800
From: Greg KH <greg@kroah.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080128161330.GC8790@kroah.com>
References: <20080125180232.GA4613@kroah.com> <479D8E9C.5030808@ladisch.de> <20080128085757.GA25035@kroah.com> <479DA75F.2070603@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479DA75F.2070603@ladisch.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 10:58:55AM +0100, Clemens Ladisch wrote:
> Greg KH wrote:
> > On Mon, Jan 28, 2008 at 09:13:16AM +0100, Clemens Ladisch wrote:
> >> Greg KH wrote:
> >> > Over two years ago, the Linux USB developers stated that they believed
> >> > there was no way to create a USB kernel driver that was not under the
> >> > GPL.  This patch moves the USB apis to enforce that decision.
> >> >
> >> > There are no known closed source USB drivers in the wild, so this patch
> >> > should cause no problems.
> >>
> >> There are the commercial OpenSound drivers.
> >
> > What are they?  Do you have a link to them?
> 
> http://www.opensound.com/
> 
> > And why have I not heard from any user of them for the past two years
> > (we have had a kernel warning for over 2 years for this issue.)
> 
> They aren't used widely (with Linux), and AFAIK the USB driver doesn't
> have anything to favor it over the ALSA driver.

Ok, then we don't have any issues :)

thanks,

greg k-h
