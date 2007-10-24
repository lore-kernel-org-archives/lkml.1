Return-Path: <linux-kernel-owner+w=401wt.eu-S1757329AbXJXG5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbXJXG5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbXJXG5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:57:03 -0400
Received: from brick.kernel.dk ([87.55.233.238]:17341 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbXJXG5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:57:01 -0400
Date: Wed, 24 Oct 2007 08:56:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071024065658.GX14671@kernel.dk>
References: <20071022211617.31f5c63d@the-village.bc.nu> <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org> <20071022224343.4abf3c96@the-village.bc.nu> <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org> <471DBEF4.4030303@panasas.com> <20071023094142.GD5059@kernel.dk> <20071023103351.GA2795@elte.hu> <20071023105615.GI5059@kernel.dk> <20071023112738.GA13847@elte.hu> <Pine.LNX.4.64.0710232120080.21337@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710232120080.21337@anakin>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Geert Uytterhoeven wrote:
> On Tue, 23 Oct 2007, Ingo Molnar wrote:
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > > Linus' latest tree, which has your SG-list enhancements included, 
> > > > certainly works fine here and does not have the problems of the 
> > > > first iteration.
> > > 
> > > That's good to hear :-)
> > > 
> > > I have a series of pending patches where I've collected fallout 
> > > patches from people and some from myself here:
> > > 
> > > http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=sg
> > > 
> > > or pullable from
> > > 
> > > git://git.kernel.dk/inux-2.6-block.git sg
> > 
> > i've attached your fixes as a diff against linus-latest below - for 
> > those who'd like to have it in patch form.
> 
> The below are still needed for m68k

The wep.c was already applied, I applied the rest of them. Thanks!

-- 
Jens Axboe

