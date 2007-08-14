Return-Path: <linux-kernel-owner+w=401wt.eu-S1761970AbXHNNOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761970AbXHNNOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 09:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761681AbXHNNNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 09:13:52 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39882 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761655AbXHNNNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 09:13:51 -0400
Date: Tue, 14 Aug 2007 15:13:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Paul Mundt <lethal@linux-sh.org>, "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-kernel@vger.kernel.org, Dave Airlie <airlied@linux.ie>
Subject: Re: Bad addresses in MAINTAINERS
Message-ID: <20070814131340.GO18945@stusta.de>
References: <1187032024.10249.266.camel@localhost> <1187036843.5058.10.camel@daplas> <20070814022147.GC633@linux-sh.org> <1187059613.10249.372.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1187059613.10249.372.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 07:46:53PM -0700, Joe Perches wrote:
> On Tue, 2007-08-14 at 11:21 +0900, Paul Mundt wrote:
> > I also haven't had one of these devices in years, though I never got
> > around to updating MAINTAINERS. Perhaps this should be orphaned?
> 
> IMS TWINTURBO FRAMEBUFFER DRIVER
> L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
> S:	Orphan
> F:	drivers/video/imsttfb.c

I don't see any value in such entries:

In several areas of the kernel drivers without a driver maintainer are 
the common case, and e.g. in this case the susbsystem entry for 
drivers/video/ should already cover it.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

