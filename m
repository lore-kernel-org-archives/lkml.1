Return-Path: <linux-kernel-owner+w=401wt.eu-S1764741AbYBZVo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764741AbYBZVo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763506AbYBZVot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:44:49 -0500
Received: from ns.suse.de ([195.135.220.2]:47647 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762752AbYBZVos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:44:48 -0500
Date: Tue, 26 Feb 2008 13:46:32 -0800
From: Greg KH <gregkh@suse.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Daniel Drake <dsd@gentoo.org>,
       linux kernel list <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: Linux 2.6.24.3 (incr patch missing)
Message-ID: <20080226214632.GA12093@suse.de>
References: <20080226010024.GA26889@suse.de> <47C421B0.6040001@gentoo.org> <20080226200249.GA10280@suse.de> <20080226202400.GH4898@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226202400.GH4898@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 10:24:00PM +0200, Adrian Bunk wrote:
> On Tue, Feb 26, 2008 at 12:02:49PM -0800, Greg KH wrote:
> > On Tue, Feb 26, 2008 at 02:26:56PM +0000, Daniel Drake wrote:
> > > Greg Kroah-Hartman wrote:
> > >> We (the -stable team) are announcing the release of the 2.6.24.3
> > >> kernel.
> > >
> > > patch-2.6.24.2-3.* files are missing from 
> > > http://www.kernel.org/pub/linux/kernel/v2.6/incr/
> > >
> > > The 2.6.23.17 patches which were released at the same time are there, so it 
> > > doesn't seem to be a case of kernel.org being behind.
> > 
> > Sorry, for some reason I forgot to copy them there.  I just did it and
> > should show up in the mirrors in an hour or so.  Please let me know if
> > they don't.
> 
> They were copied, but to /pub/linux/kernel/v2.6/ (where the older copy 
> still is).

Ah, that's what I get for doing 3 stable releases at once...

Thanks, I've now removed the files in the v2.6 directory, all should be
sane now.

greg k-h
