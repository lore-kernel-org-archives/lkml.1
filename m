Return-Path: <linux-kernel-owner+w=401wt.eu-S1764242AbXFHEXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764242AbXFHEXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 00:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbXFHEXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 00:23:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52283 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbXFHEXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 00:23:00 -0400
Date: Thu, 7 Jun 2007 21:23:58 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Grant Wilson <gww@swandive.no-ip.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.22-rc4-mm1
Message-ID: <20070608042358.GB20483@kroah.com>
References: <20070606163713.250a127a.akpm@linux-foundation.org> <Pine.LNX.4.44L0.0706071042410.3516-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0706071042410.3516-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 10:53:29AM -0400, Alan Stern wrote:
> To tell you the truth, I rather think there's not much point in keeping
> usb-try-to-debug-bug-8561.patch around.  Anything seriously wrong that
> it could catch ought to have shown up long ago.  And it is now clear
> that bug 8561 has nothing to do with this; it is a programming error
> common to many of the USB serial drivers.  (Still waiting to hear back 
> from Paulo Pereira whether the fix to the USB Option driver works...)

What error in the usb-serial drivers are you speaking about?

thanks,

greg k-h
