Return-Path: <linux-kernel-owner+w=401wt.eu-S1760706AbXJXW3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706AbXJXW3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 18:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbXJXW3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 18:29:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:54197 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbXJXW3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 18:29:36 -0400
Date: Wed, 24 Oct 2007 14:53:20 -0700
From: Greg KH <gregkh@suse.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Mark Lord <lkml@rtr.ca>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-git12: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Message-ID: <20071024215320.GA9464@suse.de>
References: <4716F134.2060002@rtr.ca> <20071018160829.GE13346@suse.de> <Pine.LNX.4.62.0710241138050.31837@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0710241138050.31837@pademelon.sonytel.be>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 11:38:21AM +0200, Geert Uytterhoeven wrote:
> On Thu, 18 Oct 2007, Greg KH wrote:
> > On Thu, Oct 18, 2007 at 01:37:56AM -0400, Mark Lord wrote:
> > > usb 5-1: new high speed USB device using ehci_hcd and address 2
> > > usb 5-1: configuration #1 chosen from 1 choice
> > > hub 5-1:1.0: USB hub found
> > > hub 5-1:1.0: 4 ports detected
> > > sysfs: duplicate filename 'bInterfaceNumber' can not be created
> > 
> > Known issue, people are working on it, there's already a proposed patch
> > on lkml for this.
> 
> But it's not in 2.6.24-rc1, right?

No, not yet, give me a day or so...

thanks,

greg k-h
