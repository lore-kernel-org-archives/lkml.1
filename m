Return-Path: <linux-kernel-owner+w=401wt.eu-S1750706AbXB0G5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750706AbXB0G5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 01:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXB0G5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 01:57:15 -0500
Received: from mail.kroah.org ([69.55.234.183]:55703 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbXB0G5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 01:57:15 -0500
Date: Mon, 26 Feb 2007 22:28:39 -0800
From: Greg KH <greg@kroah.com>
To: Ashutosh Naik <ashutosh.naik@gmail.com>
Cc: Takahiro Hirofuchi <taka-hir@is.naist.jp>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: Current Status of USB_IP
Message-ID: <20070227062839.GA9962@kroah.com>
References: <81083a450702262212y3f825efeo9e950f8c9212214b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81083a450702262212y3f825efeo9e950f8c9212214b@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 11:42:09AM +0530, Ashutosh Naik wrote:
> Hi guys,
> 
> I was wondering what is the current stage of the USB_IP project.
> 
> http://usbip.naist.jp/
> 
> The last, they appeared were
> 
> /archives/linux/kernel.org/kernel/people/akpm/patches/2.6/2.6.16-rc3/2.6.16-rc3-mm1/broken-out
> 
> It would be great if someone knows whats the status of this

I dropped it from my tree as the code was too much work keeping up to
date, and I didn't have the time.  It needed a lot of work to get
cleaned up, take advantage of the changes that happened to the core USB
code to allow this type of interface to work better, and change the
network code (possibly, not positive about that...)

If you want to take this up, that would be great.

good luck,

greg k-h
