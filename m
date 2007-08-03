Return-Path: <linux-kernel-owner+w=401wt.eu-S1764313AbXHCRmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764313AbXHCRmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 13:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761079AbXHCRmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 13:42:06 -0400
Received: from ns.suse.de ([195.135.220.2]:45349 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759277AbXHCRmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 13:42:04 -0400
Date: Fri, 3 Aug 2007 10:44:35 -0700
From: Greg KH <gregkh@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Rogan Dawes <lists@dawes.za.net>, Oliver Neukum <oliver@neukum.org>,
       David Brownell <david-b@pacbell.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: Only enable autosuspend by   default on certain
	device classes
Message-ID: <20070803174435.GA17053@suse.de>
References: <Pine.LNX.4.44L0.0708022240250.1043-100000@netrider.rowland.org> <200708022301.08719.david-b@pacbell.net> <20070803112824.GA16802@srcf.ucam.org> <200708031344.03282.oliver@neukum.org> <20070803120418.GB16802@srcf.ucam.org> <46B31F03.80908@dawes.za.net> <20070803123253.GA17725@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070803123253.GA17725@srcf.ucam.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 01:32:53PM +0100, Matthew Garrett wrote:
> On Fri, Aug 03, 2007 at 02:26:43PM +0200, Rogan Dawes wrote:
> 
> > Compare that to:
> > 
> > "My USB printer broke, guess I'd better report it to LKML".
> 
> But while this is still a likely probability, the chances are no 
> distribution is going to ship with CONFIG_USB_SUSPEND enabled.

I wouldn't be so sure, I was thinking of doing just that based on an
internal conversation I had yesterday.

Let's see what breaks and what happens :)

thanks,

greg k-h
