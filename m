Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbXELUGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbXELUGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 16:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbXELUGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 16:06:11 -0400
Received: from brick.kernel.dk ([80.160.20.94]:24237 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbXELUGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 16:06:09 -0400
Date: Sat, 12 May 2007 22:05:16 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: default y idiocy
Message-ID: <20070512200516.GS4629@kernel.dk>
References: <20070512182343.GO4629@kernel.dk> <46461C77.5040404@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46461C77.5040404@simon.arlott.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12 2007, Simon Arlott wrote:
> On 12/05/07 19:23, Jens Axboe wrote:
> >Hi,
> >
> >This has bothered me for a long time, and it just seems to be getting
> >worse. Can people please STOP defaulting non-essential stuff to 'y'?
> >Grrr.
> 
> Is there a reason why various 10/100/1000Mbit network cards are 'y' too?
> There's even a default SCSI 'm' that seems to be completely hidden from 
> the menu too (CONFIG_SCSI_WAIT_SCAN). It depends on SCSI but I can't 
> disable SCSI...

For the exact same (wrong) reason that the other menuconfig changes did
it, I suppose. Need fixing, too.

-- 
Jens Axboe

