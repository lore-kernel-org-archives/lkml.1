Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751877AbYLQT7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbYLQT7y (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYLQT6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:58:53 -0500
Received: from ns2.suse.de ([195.135.220.15]:47449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbYLQT6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:58:52 -0500
Date: Wed, 17 Dec 2008 11:54:20 -0800
From: Greg KH <gregkh@suse.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Willy Tarreau <w@1wt.eu>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, mingo@elte.hu, venkatesh.pallipadi@intel.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 68/83] x86: HPET: convert WARN_ON to WARN_ON_ONCE
Message-ID: <20081217195420.GA25320@suse.de>
References: <20081211190201.612240183@mini.kroah.org> <20081211191620.GP5894@kroah.com> <20081217112625.GJ13247@console-pimps.org> <s5h4p13dojm.wl%tiwai@suse.de> <20081217120305.GK13247@console-pimps.org> <20081217184236.GC30724@suse.de> <20081217195127.GA2578@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217195127.GA2578@console-pimps.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 07:51:27PM +0000, Matt Fleming wrote:
> On Wed, Dec 17, 2008 at 10:42:36AM -0800, Greg KH wrote:
> > 
> > Ok, so which patch should go into the 2.6.27-stable tree?
> > 
> 
> Sorry, I was confused about what HPET code was in 2.6.27-stable. The
> current patch that you have queued (1de5b0854623d30d01d72cd4ea323eb5f39d1f16)
> is the only one that should be in. So you can entirely ignore this
> thread ;-)

Great, will do, thanks for clearing it up.

greg k-h
