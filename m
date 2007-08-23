Return-Path: <linux-kernel-owner+w=401wt.eu-S932297AbXHWWvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbXHWWvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbXHWWvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:51:14 -0400
Received: from ns.suse.de ([195.135.220.2]:36672 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbXHWWvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:51:12 -0400
Date: Thu, 23 Aug 2007 15:49:56 -0700
From: Greg KH <gregkh@suse.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [GIT PATCH] USB fixes for 2.6.23-rc3
Message-ID: <20070823224956.GA25969@suse.de>
References: <20070822220805.GB30603@kroah.com> <Pine.LNX.4.60.0708240036200.3246@poirot.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0708240036200.3246@poirot.grange>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 12:43:47AM +0200, Guennadi Liakhovetski wrote:
> Hi Greg,
> 
> sorry, this is a private egoistic request, so I took the liberty and 
> removed Linus and Andrew from CC: If this wouldn't make things more 
> difficult / worse for you and anyone else, could you perhaps post such 
> patch chains as a reply to the first message (patch 0/x) and not each 
> subsequent patch as a reply to the previous one? It would make it easier 
> to view for _me_ (remember egoistic?) because my mail agent (pine) 
> presents mail threads where every reply level produces a small right 
> offset in the subject line, so, starting from about reply number 20 the 
> subject is completely off-screen.
> 
> Again, this is a minor trouble, and, perhaps, I am the only one suffering 
> from it, but if it doesn't matter either way for everyone else, I would 
> really appreciate it that way.

Heh, people ask me about this every few months or so, so you are not
alone.

Unfortunately, I really like the cascade affect, it shows that the
patches do have to be applied in consecutive order for them to work
properly (which some people seem to forget and then get mad at me when
they try to cherry-pick intermediate patches and apply them to older
kernels for odd reasons...)

If I wanted to respond in an egotistical way, I could just tell you to
use an email client that can handle the cascade affect properly, like
mine does :)

thanks,

greg k-h
