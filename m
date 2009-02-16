Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbZBPQUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbZBPQUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZBPQUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:20:35 -0500
Received: from kroah.org ([198.145.64.141]:34843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750996AbZBPQUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:20:34 -0500
Date: Mon, 16 Feb 2009 08:09:33 -0800
From: Greg KH <greg@kroah.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] UWB and WUSB fixes
Message-ID: <20090216160933.GA5008@kroah.com>
References: <49873632.6040108@csr.com> <20090203051244.GA1826@kroah.com> <49885139.3070106@csr.com> <20090203154745.GA27533@kroah.com> <49997EF2.4070109@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49997EF2.4070109@csr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 02:57:54PM +0000, David Vrabel wrote:
> Greg KH wrote:
> > 
> > Also, it would be good to have the linux-usb developers at least review
> > any changes to these files, myself included, right?
> 
> I'll post patches to the list if I think they're significant enough to
> need a review.

They should all be posted to the linux-usb list please.

> > It shouldn't be any more work for you, just send the patches to me and
> > forget about them, I'll queue them up at the proper time :)
> 
> To be honest, in the past you have been too slow to handle patches and
> review in a timely manner.  The current system of sending pull request
> direct to Linus has worked well so I'm going to stick with it for now.

Things were slow when we were handling a 30+ patchset full of the whole
wusb system.  Smaller patches get handled within a week, and I've not
had any complaints about that in a while (musb withstanding, but that's
a total mess for other reasons...)

So again, I'd really like at least the ability to review the patches,
which in your current development flow, isn't even possible.

thanks,

greg k-h
