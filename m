Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbXDIAmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbXDIAmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 20:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbXDIAmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 20:42:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35555 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbXDIAmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 20:42:24 -0400
Date: Sun, 8 Apr 2007 17:42:08 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Jeff Garzik <jeff@garzik.org>, Ayaz Abdulla <aabdulla@nvidia.com>,
       Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>
Subject: Re: Linux 2.6.21-rc6
Message-ID: <20070409004208.GA6092@kroah.com>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070408160954.edd248d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070408160954.edd248d1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2007 at 04:09:54PM -0700, Andrew Morton wrote:
> 
> I'm sitting on five patches which look like 2.6.21 material, but which
> would normally go through subsystem maintainers:
> 
> driver core:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/broken-out/update-documentation-driver-model-platformtxt.patch

Feel free to forward it on with:
	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

As it was just a documentation update, I figured it was safe to wait for
2.6.22, but I have no objection to it going in now.

thanks,

greg k-h
