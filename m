Return-Path: <linux-kernel-owner+w=401wt.eu-S1030767AbXDQVpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030767AbXDQVpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 17:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031237AbXDQVpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 17:45:54 -0400
Received: from ns2.suse.de ([195.135.220.15]:48578 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030767AbXDQVpx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 17:45:53 -0400
Date: Tue, 17 Apr 2007 14:43:34 -0700
From: Greg KH <gregkh@suse.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Prolific PL2303/05 driver
Message-ID: <20070417214334.GB10150@suse.de>
References: <200704172327.43170.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704172327.43170.mb@bu3sch.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 11:27:43PM +0200, Michael Buesch wrote:
> Hi Greg,
> 
> looking through the pl2303 driver, it seems you know about
> the internals.

Only a bit, don't have the specs though :(

> So I'm contacting you to ask if you got specification for this device.
> I have got a pl2305 (usb to parport) device and it seems there's no
> driver for it. On the Prolific page there is a datasheet download,
> but it seems to be incomplete.
> It seems that I could get basic functionality to work with it, but
> it seems to be missing a lot.
> Any suggestion on where to get proper specs for this device?

Try asking the company.

> Or do you even know where a driver is hidden? :)

Not that I know of, sorry.  Try asking them, they seem to want to
support Linux for some of their devices, and they now point people at my
usb driver for the pl2303 chip, so they at least are aware that Linux is
out there :)

good luck,

greg k-h
