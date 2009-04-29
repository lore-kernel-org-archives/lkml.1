Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbZD2VjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbZD2VjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbZD2VjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:39:05 -0400
Received: from kroah.org ([198.145.64.141]:45165 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260AbZD2VjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:39:04 -0400
Date: Wed, 29 Apr 2009 14:21:46 -0700
From: Greg KH <greg@kroah.com>
To: Tim Gardner <timg@tpi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT]: staging - mac80211 - unify config_interface and
	bss_info_changed
Message-ID: <20090429212146.GA5274@kroah.com>
References: <20090429193821.305DAF88CE@sepang.rtg.net> <20090429201947.GB20814@kroah.com> <49F8C120.6080807@tpi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F8C120.6080807@tpi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 03:05:36PM -0600, Tim Gardner wrote:
> Greg KH wrote:
> > On Wed, Apr 29, 2009 at 01:38:21PM -0600, Tim Gardner wrote:
> >> Greg,
> >>
> >> I did a build test to make sure things at least compile. checkpatch is fine
> >> with these patches, but the drivers clearly have other formatting issues.
> >>
> >> Lemme know if you have any problems.
> > 
> > Only thing that is a problem is that I can't pull 3 individual patches
> > out of one email :)
> > 
> > Care to use git send-email to send them to me?
> > 
> 
> Done, though I didn't Cc LKML again. I take it this is your preferred
> method for receiving patches? I thought you were a git weenie.

>From the MAINTAINERS file:
	STAGING SUBSYSTEM
	P:	Greg Kroah-Hartman
	M:	gregkh@suse.de
	L:	linux-kernel@vger.kernel.org
	T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
	S:	Maintained

I use quilt to handle the large patch queues.

I also didn't see a 'pull' request in your email, did I miss it?

And yes, emails are best.

thanks,

greg k-h
