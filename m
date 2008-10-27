Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbYJ0Wz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbYJ0Wz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 18:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYJ0Wzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 18:55:49 -0400
Received: from kroah.org ([198.145.64.141]:36863 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750734AbYJ0Wzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 18:55:48 -0400
Date: Mon, 27 Oct 2008 15:07:11 -0700
From: Greg KH <greg@kroah.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] w35und: remove dead code from wbusb_f.h
Message-ID: <20081027220711.GA10391@kroah.com>
References: <Pine.LNX.4.64.0810221906140.1679@melkki.cs.Helsinki.FI> <20081027183707.GA13737@kroah.com> <Pine.LNX.4.64.0810272241520.7338@melkki.cs.Helsinki.FI> <20081027211452.GA19762@kroah.com> <Pine.LNX.4.64.0810272334150.9093@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810272334150.9093@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 11:34:49PM +0200, Pekka J Enberg wrote:
> On Mon, 27 Oct 2008, Greg KH wrote:
> > This seems to be because wb_usb_submit_urb() and alloc_urb() are in the
> > drivers/staging/winbond/linux/wbusb_f.h file when it is removed.
> > 
> > I'll go fix this up by adding another patch removing these entries.
> > Don't know how they got in here, odd.
> 
> That's because I forgot to send the following patch. Sorry about that.

Heh, I already did this on my own.

thanks,

greg k-h
