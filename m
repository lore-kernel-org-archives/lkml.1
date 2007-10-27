Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbXJ0DGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbXJ0DGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 23:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbXJ0DGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 23:06:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45244 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbXJ0DGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 23:06:06 -0400
Date: Fri, 26 Oct 2007 19:41:40 -0700
From: Greg KH <greg@kroah.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Robert Hancock <hancockr@shaw.ca>, akpm@linux-foundation.org, ak@suse.de,
       rajesh.shah@intel.com, torvalds@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
Message-ID: <20071027024140.GC29039@kroah.com>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org> <200710251622.36773.jbarnes@virtuousgeek.org> <20071026025407.GA21408@kroah.com> <200710260959.46811.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710260959.46811.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 09:59:45AM -0700, Jesse Barnes wrote:
> On Thursday, October 25, 2007 7:54 pm Greg KH wrote:
> > On Thu, Oct 25, 2007 at 04:22:35PM -0700, Jesse Barnes wrote:
> > > I think Greg doesn't like it, even though we don't have an
> > > alternative at this point...
> >
> > Yes, I didn't like it, Ivan didn't like it, and I got reports that it
> > wasn't even needed at all once you upgraded your BIOS to the latest
> > version.
> >
> > So, is this still needed?  And if so, can you try to implement what
> > Ivan suggested to do here instead?
> 
> Yes, it's still needed.  Auke rescinded his "BIOS upgrade makes it work" 
> message, so something like this is still necessary.

He did?  Ugh, I can't keep these all straight, sorry.

Can someone just send what they think is still needed, and explain why
Ivan will not object to it?  :)

thanks,

greg k-h
