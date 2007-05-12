Return-Path: <linux-kernel-owner+w=401wt.eu-S1760842AbXELUKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbXELUKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 16:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbXELUKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 16:10:48 -0400
Received: from brick.kernel.dk ([80.160.20.94]:28670 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbXELUKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 16:10:47 -0400
Date: Sat, 12 May 2007 22:09:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
Subject: Re: default y idiocy
Message-ID: <20070512200954.GT4629@kernel.dk>
References: <20070512182343.GO4629@kernel.dk> <Pine.LNX.4.61.0705122121340.9570@yvahk01.tjqt.qr> <20070512192726.GQ4629@kernel.dk> <20070512210944.52260991@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512210944.52260991@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12 2007, Alan Cox wrote:
> > Sorry, I don't buy that reason at all - it's a short term advantage,
> > causing long term pain. It's not what we have done in the past, don't
> > start doing crap like that now.
> 
> It doesn't really matter what it defaults too

It does matter what it defaults to, it should only default to y if it's
really needed. If it didn't matter, just default every driver to y?
Thanks, but no thanks.

> cp .config somewheresafe
> 
> Install new kernel
> 
> cp it back
> 
> make oldconfig

Ehm yes, kernel updating 101. What's your point? Do that with your
2.6.21 config and get met with lots of new questions on ps2, ethernet,
macintosh drivers, dab, etc. All because of some menuconfig shuffling.

-- 
Jens Axboe

