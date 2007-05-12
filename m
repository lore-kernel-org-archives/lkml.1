Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbXELTqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbXELTqQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbXELTqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:46:04 -0400
Received: from brick.kernel.dk ([80.160.20.94]:23293 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbXELTqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:46:03 -0400
Date: Sat, 12 May 2007 21:45:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org, mchehab@infradead.org
Subject: Re: default y idiocy
Message-ID: <20070512194510.GR4629@kernel.dk>
References: <20070512182343.GO4629@kernel.dk> <Pine.LNX.4.61.0705122121340.9570@yvahk01.tjqt.qr> <20070512192726.GQ4629@kernel.dk> <Pine.LNX.4.61.0705122135510.9570@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705122135510.9570@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12 2007, Jan Engelhardt wrote:
> 
> On May 12 2007 21:27, Jens Axboe wrote:
> >On Sat, May 12 2007, Jan Engelhardt wrote:
> >> 
> >> On May 12 2007 20:23, Jens Axboe wrote:
> >> >Hi,
> >> >
> >> >This has bothered me for a long time, and it just seems to be getting
> >> >worse. Can people please STOP defaulting non-essential stuff to 'y'?
> >> >Grrr.
> >> 
> >> http://lkml.org/lkml/2007/5/8/76
> >
> >Sorry, I don't buy that reason at all - it's a short term advantage,
> >causing long term pain. It's not what we have done in the past, don't
> >start doing crap like that now.
> 
> Right, I shall create some patches to revert that and send them off
> to Linus ASAP.

Thanks!

-- 
Jens Axboe

