Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbXGaW6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbXGaW6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbXGaW6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:58:41 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58678 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbXGaW6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:58:40 -0400
Date: Tue, 31 Jul 2007 15:57:55 -0700
From: Greg KH <greg@kroah.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stuart Hayes <Stuart_Hayes@dell.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: USB-related instability on 2.6.23-rc1
Message-ID: <20070731225755.GA22324@kroah.com>
References: <fa686aa40707311406w10169a20ibbef77c198020af8@mail.gmail.com> <20070731212454.GB18839@kroah.com> <fa686aa40707311426t23f23fbctc9865faf87ba7cdc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa686aa40707311426t23f23fbctc9865faf87ba7cdc@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 03:26:55PM -0600, Grant Likely wrote:
> On 7/31/07, Greg KH <greg@kroah.com> wrote:
> > On Tue, Jul 31, 2007 at 03:06:07PM -0600, Grant Likely wrote:
> > > I've attached my kernel config file and a dmesg output
> >
> > Can you enable CONFIG_USB_DEBUG and send the linux-usb-devel list and
> > us, the output when you have these problems?
> 
> Yes, I'll compile up a kernel right a way and do so.

If you could test out Stuart's patch and let me know if it solves the
problem, or not, for you, that would be greatly appreciated.

thanks,

greg k-h
