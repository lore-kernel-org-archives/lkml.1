Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbXIEU3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbXIEU3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 16:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbXIEU3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 16:29:23 -0400
Received: from 1wt.eu ([62.212.114.60]:2397 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbXIEU3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 16:29:22 -0400
Date: Wed, 5 Sep 2007 22:29:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: Beschorner Daniel <Daniel.Beschorner@facton.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.4.35.1 md problem
Message-ID: <20070905202908.GA11602@1wt.eu>
References: <3C59DB883F7B0B4D8096010D45ACCD134F1D24@exch.facton.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3C59DB883F7B0B4D8096010D45ACCD134F1D24@exch.facton.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2007 at 03:45:45PM +0200, Beschorner Daniel wrote:
> I got a strange problem after I updated from 2.4.34.4 to 2.4.35.1:
> 
> The kernel raid autodetection assembles my 2 raid-1 arrays, but mdstat
> shows "0 blocks" for each md.
> So the filesystem check complains about no valid superblock, but the
> arrays seem to run fine.
> After raidstop/raidstart the blocks are displayed correctly and all is
> fine.
> But this is no solution, because the root fs is raid.
> 
> Could it be a compiler issue, I assume there is no change in raid since
> 2.4.34?!?
> 
> I use GCC 4.1.2 and no LVM.

Also, I forgot one important thing: could you please send me your .config ?

Thanks in advance,
Willy

