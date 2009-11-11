Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbZKKGpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbZKKGpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 01:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZKKGph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 01:45:37 -0500
Received: from kroah.org ([198.145.64.141]:50445 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbZKKGph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 01:45:37 -0500
Date: Tue, 10 Nov 2009 22:43:52 -0800
From: Greg KH <greg@kroah.com>
To: Phil Reynolds <phil-lkml@tinsleyviaduct.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: USB - scanner no longer working on desktop system
Message-ID: <20091111064352.GC5277@kroah.com>
References: <20091110103454.43876f3efnb0lmmm@topdeck.tinsleyviaduct.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110103454.43876f3efnb0lmmm@topdeck.tinsleyviaduct.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 10:34:54AM +0000, Phil Reynolds wrote:
> My scanner, an Epson Perfection 2400, has recently stopped working on my 
> desktop system - it was fine for the last year. It still works on my 
> laptop.
>
> Both systems are running Debian lenny, the main difference being the kernel 
> version. Currently, the desktop has 2.6.26-19lenny1 - 19lenny2 and 19 are 
> also listed as available. Due to its Intel 5100 wireless, the laptop has a 
> newer kernel - 2.6.30-7~bpo50+1 - with 2.6.30-8~bpo50+1 also listed as 
> available.

Care to post all of this, including your usbmon output, on the
linux-usb@vger.kernel.org mailing list so the USB developers are sure to
see it?

thanks,

greg k-h
