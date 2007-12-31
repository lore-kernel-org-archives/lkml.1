Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbXLaFX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbXLaFX6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 00:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXLaFXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 00:23:49 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:1356 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751114AbXLaFXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 00:23:48 -0500
Date: Mon, 31 Dec 2007 14:23:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Joe Perches <joe@perches.com>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom device
Message-ID: <20071231052336.GA29275@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Joe Perches <joe@perches.com>, Jens Axboe <jens.axboe@oracle.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-sh <linux-sh@vger.kernel.org>
References: <1198774339.6170.11.camel@localhost.localdomain> <1198796281.4833.31.camel@localhost> <1199021904.6222.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199021904.6222.7.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 01:38:24PM +0000, Adrian McMenamin wrote:
> On Thu, 2007-12-27 at 14:58 -0800, Joe Perches wrote:
> > On Thu, 2007-12-27 at 16:52 +0000, Adrian McMenamin wrote:
> > > This patch adds support for the CD-Rom drive on the SEGA Dreamcast.
> > 
> > Because it was already so close, might as well make it checkpatch clean.
> > 
> > I also added a function gdrom_is_busy() to make a couple of tests
> > fit on a single line and perhaps easier to read.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > 
> Not really for me to decide if this gets applied - I'll leave that to
> Paul as the maintainer. But I have no objection to them :)

Both patches are fine with me, but it is ultimately Jens (as the
drivers/cdrom authority) that will have to decide whether to sign off on
the GDROM patches or not, and through which tree the patches will end up
being merged. I can certainly merge them through my tree with his
Acked-by if that's deemed the most convenient.
