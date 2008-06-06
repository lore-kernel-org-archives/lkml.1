Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbYFFGGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbYFFGGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYFFGGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:06:24 -0400
Received: from ns.suse.de ([195.135.220.2]:38311 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbYFFGGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:06:24 -0400
Date: Thu, 5 Jun 2008 18:44:37 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: via agp patches
Message-ID: <20080606014437.GE3325@suse.de>
References: <20080531003214.GA6208@suse.de> <21d7e9970805311550r182c5291ta4c55e8069e631a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970805311550r182c5291ta4c55e8069e631a1@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 08:50:39AM +1000, Dave Airlie wrote:
> On Sat, May 31, 2008 at 10:32 AM, Greg KH <gregkh@suse.de> wrote:
> > Recently VIA has been distributing some pre-build kernel modules for
> > their latest video cards without the source for it.  So I asked, and got
> > the patches.  I've forward ported them to the current 2.6.26-rc4 tree,
> > and they also apply cleanly to 2.6.25 as well.  They are here in the
> > three emails after this one.
> >
> > I'm still working on getting some more information on exactly what these
> > patches each do for a good changelog, but until then, if anyone has the
> > hardware and wants to play with the code, here it is.
> >
> > If anyone has any questions, please let me know.
> >
> 
> Like I can pull the cleanups and style one no problems, but really any
> functional changes need to be explained with some detail, and the drm
> changes need to be submitted to dri-devel@lists.sf.net and Thomas
> Hellstrom would need to at least understand them before we could let
> them into the kernel.

Ok, I'm pushing back on them to get this information, and the userspace
portions to match up so that we can see, and actually use this new
kernel driver.

> VIA need to deal with the openchrome project to get those sort of
> changes into an upstream X.org related driver.

I agree, am trying to get them to do this...

thanks,

greg k-h
