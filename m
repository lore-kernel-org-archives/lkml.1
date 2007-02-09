Return-Path: <linux-kernel-owner+w=401wt.eu-S2992788AbXBITxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992788AbXBITxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992774AbXBITxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:53:09 -0500
Received: from ns2.suse.de ([195.135.220.15]:42935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423246AbXBITxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:53:08 -0500
Date: Fri, 9 Feb 2007 11:51:56 -0800
From: Greg KH <greg@kroah.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Chris Wright <chrisw@sous-sol.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       stable@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [patch 00/50] -stable review
Message-ID: <20070209195156.GA27018@kroah.com>
References: <20070106022753.334962000@sous-sol.org> <45C624D2.9030403@linuxtv.org> <20070205214332.GB18230@kroah.com> <45C7ACAB.6060408@linuxtv.org> <20070205223304.GA19793@kroah.com> <45CA3FBD.70407@linuxtv.org> <45CCCE51.8090103@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45CCCE51.8090103@linuxtv.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 09, 2007 at 02:41:05PM -0500, Michael Krufky wrote:
> Michael Krufky wrote:
> > Greg KH wrote:
> > 
> >>>> I'll go through the archives and see if there's enough to do a .18
> >>>> release (and the patches are serious enough to warrent it.)
> >>> Actually, I have a few more -stable patches for both 2.6.18.y and 2.6.19.y, if
> >>> you don't mind holding off a day or two (wont have time to prepare these until
> >>> tomorrow evening)...  One of them is a security fix, that allows a non-root user
> >>> to hang the kernel given the correct circumstances.
> >> Ok, that's serious enough :)
> >>
> >> I'll wait for your patches.
> >>
> >> thanks,
> >>
> >> greg k-h
> > 
> > I've uploaded the remaining pending v4l/dvb -stable patches for both 2.6.18.y
> > and 2.6.19.y to the following locations:
> > 
> > http://linuxtv.org/~mkrufky/stable/2.6.18.y/ (8 patches)
> > 
> > and
> > 
> > http://linuxtv.org/~mkrufky/stable/2.6.19.y/ (5 patches)
> > 
> > Using the mailer at my current location, I am unable to send patches inline, and
> > I won't have the time for it this evening.  In the interest of saving time, I
> > figured that sending them to you in this method is good enough.  If you still
> > need for me to send them via email inline, please let me know.
> 
> Greg & Chris,
> 
> I haven't heard from either of you about these patches, nor have I seen any
> update to the stable-queue.
> 
> Just for clarification, the security fix patch, that prevents a non-root user
> from hanging the kernel is the patch entitled,
> 
> "V4L: buf_qbuf: fix videobuf_queue->stream corruption and lockup"
> 
> ...as per Mauro's description, here:
> 
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg113820.html

Thanks, I'll be flushing out the stable queue later on tonight and will
pick up all of these patches.

greg k-h
