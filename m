Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753220AbYLRTDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbYLRTDy (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYLRTD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:03:29 -0500
Received: from kroah.org ([198.145.64.141]:60559 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752028AbYLRTD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:03:29 -0500
Date: Thu, 18 Dec 2008 11:01:29 -0800
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg KH <gregkh@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Willy Tarreau <w@1wt.eu>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, mingo@elte.hu, venkatesh.pallipadi@intel.com
Subject: Re: [patch 68/83] x86: HPET: convert WARN_ON to WARN_ON_ONCE
Message-ID: <20081218190129.GA13232@kroah.com>
References: <20081211190201.612240183@mini.kroah.org> <20081211191620.GP5894@kroah.com> <20081217112625.GJ13247@console-pimps.org> <s5h4p13dojm.wl%tiwai@suse.de> <20081217120305.GK13247@console-pimps.org> <20081217184236.GC30724@suse.de> <alpine.LFD.2.00.0812181235170.3492@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812181235170.3492@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 12:37:50PM +0100, Thomas Gleixner wrote:
> On Wed, 17 Dec 2008, Greg KH wrote:
> > > Ah, thanks. I wasn't aware of that.
> > 
> > Ok, so which patch should go into the 2.6.27-stable tree?
> 
> Just the WARN_ON_ONCE() one: 1de5b0854623d30d01d72cd4ea323eb5f39d1f16

That is already in the 2.6.27.9 release.

thanks,

greg k-h
