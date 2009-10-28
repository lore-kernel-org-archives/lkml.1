Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbZJ1PnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbZJ1PnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 11:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbZJ1PnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 11:43:05 -0400
Received: from kroah.org ([198.145.64.141]:35137 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224AbZJ1PnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 11:43:04 -0400
Date: Wed, 28 Oct 2009 08:40:00 -0700
From: Greg KH <greg@kroah.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [quilt patches] Staging: rt28x0: more cleanups
Message-ID: <20091028154000.GA28313@kroah.com>
References: <200910252134.17360.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910252134.17360.bzolnier@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 25, 2009 at 09:34:17PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> More cleanups:
> - run all files through scripts/Lindent
> - convert C++ style comments to C style
> - remove typedefs
> 
> As a result those drivers start looking Linux-like and become easier
> to comprehend, also as an added bonus another 1.5 KLOC are gone..
> 
> The downside is that it will be harder now to port over updates from
> the original vendor source code than it was in the past..
> 
> As usual all changes were tested with RT2860 and RT3070.
> 
> 
> Cause patches are too big for a mailing list they are available at:
> 
> http://www.kernel.org/pub/linux/kernel/people/bart/staging-rt28x0-more-cleanups/

All queued up now.

It seemed that there were some merge issues, like you forgot to add a
file to one of your patches somehow, and you had one mod.c file patched
which needed to be fixed up.

So if you could verify I got it all correctly, that would be great.

thanks,

greg k-h
