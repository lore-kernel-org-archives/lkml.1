Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbXFXWn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbXFXWn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 18:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXFXWnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 18:43:21 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:2305 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXFXWnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 18:43:21 -0400
Date: Mon, 25 Jun 2007 00:43:17 +0200
From: Olivier Galibert <galibert@pobox.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <20070624224317.GC93944@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	linux-kernel@vger.kernel.org
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <20070624215724.025a5de5@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070624215724.025a5de5@the-village.bc.nu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 09:57:24PM +0100, Alan Cox wrote:
> > Sory Alan but I don't want philosophical/historical discuss.
> > Try to answer on question "ALSA or OSS ?" using *only* technical arguments.
> 
> We dropped OSS for ALSA for technical reasons. Those being that ALSA
> - has a better audio API

You mean the undocumented, 100% ioctl one?  With one ioctl to write
interleaved sound, one for non-interleaved sound, in addition to
setting interleaved or not in the configuration?  I should check one
day which one wins.

Or the "library"?  Don't get me started on this one.


I take your word about the fact that the kernel side is better.  The
userland side, not so much.

  OG.
