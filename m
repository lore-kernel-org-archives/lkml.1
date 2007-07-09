Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbXGINuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbXGINuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 09:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbXGINuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 09:50:01 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:56812 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbXGINuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 09:50:00 -0400
Date: Mon, 9 Jul 2007 15:51:09 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Brownell <david-b@pacbell.net>
Cc: Dmitry Krivoschekov <dmitry.krivoschekov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Li Yang-r58472 <LeoLi@freescale.com>,
       linux-usb-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk
Message-ID: <20070709135109.GO11451@enneenne.com>
References: <20070628103619.GW13886@enneenne.com> <200706281453.23414.david-b@pacbell.net> <4684CAF7.9050201@gmail.com> <200706300646.14399.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706300646.14399.david-b@pacbell.net>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [linux-usb-devel] [PATCH] PXA27x UDC driver.
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 06:46:14AM -0700, David Brownell wrote:
> 
> Has someone actually signed up to develop and maintain such a
> controller driver?  If so, that would be a Fine Thing, but not
> one I've heard rumored before.  I've assumed that the best we'd
> have is someone (Rodolfo?!) finally cleaning up a pxa27x version
> so it could be merged.

That's what I wish to do... I wish cleaning up as much possible my
pxa27x version af the driver so we can have something common where we
can work on.

Sorry for the delay but in these next days I'll read back all your
suggestions and I'll provide a new patch ASAP.

However I would like avoiding to remove what I did on
usb_ep_autoconfig() since I got functional g_ether device with RNDIS
support... there could be another way to resolve this problem?

Thanks a lot,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
