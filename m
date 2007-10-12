Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbXJLDs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbXJLDs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 23:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbXJLDsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 23:48:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756433AbXJLDsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 23:48:37 -0400
Date: Thu, 11 Oct 2007 20:52:15 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, rdreier@cisco.com,
       general@lists.openfabrics.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jeff@garzik.org
Subject: Re: [GIT PULL] please pull infiniband.git for-linus
Message-ID: <20071012035215.GA10190@suse.de>
References: <aday7e9b0m3.fsf@cisco.com> <20071011.181719.78707713.davem@davemloft.net> <alpine.LFD.0.999.0710111944120.6887@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710111944120.6887@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 07:58:04PM -0700, Linus Torvalds wrote:
> 
> So I merged it all, and I don't expect any problems, but I'm hoping 
> somebody is thinking about that mod_devicetable.h/file2alias.c mess.
> 
> I'm not entirely sure who to blame on that thing. I'm adding Greg to the 
> Cc, on the assumption that blaming him is usually the right thing to do ;)

Hey, it wasn't me this time, I haven't even built my trees for you to
pull from and break everything yet :)

But yeah, splitting up the mod_devicetable.h/file2alias.c mess is a very
good idea, I'll see what I can come up with tomorrow.

thanks,

greg k-h
