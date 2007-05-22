Return-Path: <linux-kernel-owner+w=401wt.eu-S935693AbXEVWU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935693AbXEVWU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760741AbXEVWUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:20:20 -0400
Received: from canuck.infradead.org ([209.217.80.40]:49003 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029AbXEVWUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:20:19 -0400
Date: Tue, 22 May 2007 15:15:33 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the
	-stable cycle
Message-ID: <20070522221533.GB2302@kroah.com>
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com> <46533EA8.7020602@garzik.org> <20070522193538.GA885@kroah.com> <46535164.8080604@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46535164.8080604@garzik.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 04:24:04PM -0400, Jeff Garzik wrote:
>  Greg KH wrote:
> > Well, SuSE handles this just fine, but I do notice that RHEL 5 disables
> > the new_id stuff entirely, so I can see why you might get this
> > impression :)
> 
>  I looked at distros other than those produced by my employer.
> 
>  Apparently you did not.
> 
>  This is not how we best serve Linux users.

See that ":)" above?

Anyway, I'm pretty sure that Ubuntu also handles new device ids through
sysfs, or so I was told once, but I don't have a box to test that out
on.  Oh, and Dell has some userspace tools that also use this interface
for adding new ids.

thanks,

greg k-h
