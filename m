Return-Path: <linux-kernel-owner+w=401wt.eu-S933931AbYCFNMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931AbYCFNMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757747AbYCFNMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:12:42 -0500
Received: from brick.kernel.dk ([87.55.233.238]:21746 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbYCFNMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:12:41 -0500
Date: Thu, 6 Mar 2008 14:12:37 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080306131237.GE17940@kernel.dk>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080306090029.GA6215@elte.hu> <20080306125929.GD17940@kernel.dk> <20080306130643.GB21359@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306130643.GB21359@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06 2008, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Presumably any hw issues would get noticed (like missing interrupt) 
> > and trigger the error handler, so it looks like this IO is still stuck 
> > in the queue somewhere. That mainly points the finger at AS, but given 
> > that you cannot reproduce I'm not sure how best to proceed with 
> > this...
> 
> me neither... just wanted to give notice that something's brewing in 
> this area. Will know more after tonight's qa series i guess, if it gets 
> above 100 bootups ;-)

Could be old brew, depends on when/how you can re-trigger it :-)

-- 
Jens Axboe

