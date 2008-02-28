Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbYB1CWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbYB1CWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 21:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYB1CV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 21:21:56 -0500
Received: from foo.birdnet.se ([213.88.146.6]:34209 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750802AbYB1CVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 21:21:55 -0500
X-Greylist: delayed 3667 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Feb 2008 21:21:55 EST
Message-ID: <20080228002457.30489.qmail@cdy.org>
Date: Thu, 28 Feb 2008 01:24:57 +0100
From: Peter Stuge <stuge-linux-pcmcia@cdy.org>
To: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@brodo.de>
Subject: Re: [2.6 patch] the long overdue pcmcia_ioctl.c removal
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	Dominik Brodowski <linux@brodo.de>
References: <20080213213115.GW3383@cs181133002.pp.htv.fi> <20080218050133.23454db1.akpm@linux-foundation.org> <20080227181303.GB29269@cs181133002.pp.htv.fi> <20080227204407.GA10455@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227204407.GA10455@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Really cross-post like this?)

On Wed, Feb 27, 2008 at 08:44:07PM +0000, Russell King wrote:
> TBH I've given up trying to fight this continue "lets remove these
> IOCTLs which no one uses" crap.  Obviously, _I_ use them.

I suppose critical mass or other powers that be have decided they
aren't good enough. If your userspace will never change, settling
on a kernel as well shouldn't be too big a deal.

Closed source sure sucks.


//Peter
