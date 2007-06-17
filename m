Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbXFQXte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbXFQXte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 19:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXFQXt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 19:49:27 -0400
Received: from paragon.brong.net ([66.232.154.163]:38212 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbXFQXt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 19:49:27 -0400
Date: Mon, 18 Jun 2007 09:22:21 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Chris Adams <cmadams@hiwaay.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070617232221.GB14098@brong.net>
References: <fa.toMqQ3LqoQn6Xh51bVordO8WMVc@ifi.uio.no> <fa.EmnDne9QndTLcw7NAzc83tWplMI@ifi.uio.no> <fa.G+0vGcF8U8pcd6ozkdhKGsQ/dDs@ifi.uio.no> <fa.8bXRW7nY7z5eXVZxCxUgra+gbb8@ifi.uio.no> <fa.qtDtq+aSKlNweTqHtKcy/Gj5PXg@ifi.uio.no> <20070617215840.GA1217855@hiwaay.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617215840.GA1217855@hiwaay.net>
Organization: brong.net
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 04:58:40PM -0500, Chris Adams wrote:
> Once upon a time, Jesper Juhl <jesper.juhl@gmail.com> said:
> >Let's say I'm the owner of a company selling some device that uses a
> >GPLv2 OS and some GPLv2 applications to do the job. Let's say that for
> >some reason I don't want the end users of my device to tinker with the
> >software inside my device.  Obviously I release the source for any
> >modifications I may have made, but I use the hardware to prevent users
> >from installing modified versions on the device (basically I TiVO'ize
> >the device).
> 
> BTW: Another reason a vendor might lock down the device is for security.
> For example, Juniper routers (which now run a significant portion of the
> "core" of the Internet) run FreeBSD on the routing engine.  They include
> several GNU software utilities (for example gawk, diff, and gdb).
> Starting with JUNOS 7.6 (IIRC), end-users can no longer build and run
> their own binaries on the routing engine.  This means that the GPLv2
> code cannot be modified in-place (similar to TiVo altough done using
> different means).
> 
> The reason is that if there ever is a security hole in the routing
> engine software (FreeBSD kernel, OpenSSH, etc.), it would be a really
> bad thing if crackers could load arbitrary software (rootkits, spam
> software, etc.) directly on Internet core routers.  If you think spam
> zombies on cable modems or DSL are bad, imagine them on 100 megabit
> links!

To be fair here, this could also be accomplished by having to flip a
physical switch on the router, especially if you did something funky
like:

[---] push this button for a 5 minute access pass to upload new
      software through physical cable port 1.

More complex, but not unreasonable.

Bron.
