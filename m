Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbYFKDdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbYFKDdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 23:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbYFKDdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 23:33:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57636 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbYFKDdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 23:33:14 -0400
Date: Tue, 10 Jun 2008 20:28:10 -0700
From: Greg KH <greg@kroah.com>
To: Felipe Balbi <felipebalbi@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       linux-next@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [ANNOUNCE] linux-staging tree created
Message-ID: <20080611032810.GA4483@kroah.com>
References: <20080610190540.GA25066@kroah.com> <31e679430806101707s357e4b0dm79c3f9a95c784320@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31e679430806101707s357e4b0dm79c3f9a95c784320@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 03:07:30AM +0300, Felipe Balbi wrote:
> hi,
> 
> On Tue, Jun 10, 2008 at 10:05 PM, Greg KH <greg@kroah.com> wrote:
> > Oh great, not yet-another-kernel-tree, just what the world needs...
> >
> > Yes, this is an announcement of a new kernel tree, linux-staging.  It is
> > a quilt series of patches that can be found at:
> >        git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> >
> >
> > In a long and meandering thread with some of the other kernel developers
> > a week or so ago, it came up that there is no single place for companies
> > and developers to put their code for testing while it gets cleaned up
> > for submission into the kernel tree.  All of the different subsystems
> > have trees, but they generally only want code that is about to go into
> > this release, or the next one.  For stuff that is farther off, there is
> > no place to go.
> 
> That's great. I started working on the test and measurement class
> driver. Do you want me to send preliminary patches or just the final
> one ?

I'll take whatever you have, prelim patches is nice if you are at a
stopping point and want to make sure I get them applied :)

thanks,

greg k-h
