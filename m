Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbXAXSGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbXAXSGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 13:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbXAXSGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 13:06:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44972 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbXAXSGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 13:06:11 -0500
Date: Wed, 24 Jan 2007 10:05:12 -0800
From: Greg KH <greg@kroah.com>
To: Christian Weiske <cweiske@cweiske.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel panic when inserting usb isdn modem
Message-ID: <20070124180512.GA10119@kroah.com>
References: <45B5F9B0.3050006@cweiske.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B5F9B0.3050006@cweiske.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 01:04:00PM +0100, Christian Weiske wrote:
> Hello,
> 
> 
> I reproducably get a kernel panic when plugging in a usb isdn modem,
> Billion tiny USB ISDN TA 128).
> It is said to work with the hfc_usb isdn drivers in the kernel, so I
> compiled them into it.
> 
> Kernel is 2.6.20-rc5, gcc 3.4.6 on a via epia 5000 board.
> 
> Is there anything I can do? Shall I file a bug report?

Yes, please do.  Or post this to the linux-usb-devel mailing list, the
uhci developer will probably be very interested in it.

thanks,

greg k-h
