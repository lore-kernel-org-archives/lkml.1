Return-Path: <linux-kernel-owner+w=401wt.eu-S934107AbXKOHN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107AbXKOHN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbXKOHAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:00:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33874 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764242AbXKOHAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:00:19 -0500
Date: Wed, 14 Nov 2007 22:59:51 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] warning, huge 2.6.23-stable review cycle about to
	start
Message-ID: <20071115065951.GA20998@kroah.com>
References: <20071115055902.GA4670@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115055902.GA4670@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 09:59:02PM -0800, Greg Kroah-Hartman wrote:
> Ok, I've been slacking on the -stable front for a bit here, and didn't
> realize how far behind I've gotten.  Everyone has been sending patches
> in, which is great, but now we are facing a HUGE 114 patch release.
> 
> As there's no real way that everyone can review all of these patches,
> I've decided to split them up into 6 different categories, and will be
> sending patches out in these categories for review.  If people can just
> glance over the ones in the areas they care about, I would really
> appreciate it.

There are 6 different roll-up patches on kernel.org if people want to
use those instead:

> The 6 categories are:
> 	- core kernel changes

http://www.kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.23.2-rc1.gz

> 	- arch specific changes

http://www.kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.23.3-rc1.gz

> 	- networking changes

http://www.kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.23.4-rc1.gz

> 	- network driver changes

http://www.kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.23.5-rc1.gz

> 	- non-network driver changes

http://www.kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.23.6-rc1.gz

> 	- filesystems

http://www.kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.23.7-rc1.gz

thanks,

greg k-h
