Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbXKEW3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbXKEW3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 17:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbXKEW32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 17:29:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:51552 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbXKEW31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 17:29:27 -0500
Date: Mon, 5 Nov 2007 14:28:46 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>, davem@davemloft.net,
       jgarzik@redhat.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [GIT PATCH] PCI patches for 2.6.24-rc1
Message-ID: <20071105222846.GA32090@suse.de>
References: <20071105215601.GA4612@kroah.com> <alpine.LFD.0.999.0711051410180.15101@woody.linux-foundation.org> <alpine.LFD.0.999.0711051414120.15101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0711051414120.15101@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 02:16:05PM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 5 Nov 2007, Linus Torvalds wrote:
> > 
> > This one is bogus:
> 
> Side note: I pulled and pushed out, since I assume the *code* is correct, 
> but please double-check the commit messages for things like this.
> 
> gitk makes it really easy, since it will highlight valid commit ID's. It 
> looks lik eyou may have re-ordered the commits or something?

Wow, that's cool, I never noticed that.

I'm guessing that David is referring to a commit in his tree, not in
yours yet.

thanks,

greg k-h
