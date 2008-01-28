Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbYA1Iyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbYA1Iyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 03:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYA1Iy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 03:54:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33991 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYA1Iy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 03:54:27 -0500
Date: Mon, 28 Jan 2008 00:57:57 -0800
From: Greg KH <greg@kroah.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080128085757.GA25035@kroah.com>
References: <20080125180232.GA4613@kroah.com> <479D8E9C.5030808@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479D8E9C.5030808@ladisch.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 09:13:16AM +0100, Clemens Ladisch wrote:
> Greg KH wrote:
> > Over two years ago, the Linux USB developers stated that they believed
> > there was no way to create a USB kernel driver that was not under the
> > GPL.  This patch moves the USB apis to enforce that decision.
> >
> > There are no known closed source USB drivers in the wild, so this patch
> > should cause no problems.
> 
> There are the commercial OpenSound drivers.

What are they?  Do you have a link to them?  And why have I not heard
from any user of them for the past two years (we have had a kernel
warning for over 2 years for this issue.)

thanks,

greg k-h
