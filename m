Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbYIXUSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbYIXUSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYIXURx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:17:53 -0400
Received: from 1wt.eu ([62.212.114.60]:4466 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbYIXURx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:17:53 -0400
Date: Wed, 24 Sep 2008 22:17:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: Sylwester Gruszka <gruszex@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Broken XFS partition
Message-ID: <20080924201745.GE24654@1wt.eu>
References: <200809241236.26135.gruszex@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809241236.26135.gruszex@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 12:36:25PM +0200, Sylwester Gruszka wrote:
> Hello,
> 
> I have a problem with XFS partition, it has broken down suddenly. I was doing 
> no special things, just browsing www and suddenly my PC has restarted, after 
> that I could not boot by PLD Th linux, after few usual kernel messages I get 
> some matrix of numbers and it stops.
> 
> I realised that it is broken partition after I tried to repair system, I just 
> could not mount this partition (using sysrescuecd), 'mount' gave me lots of 
> weird numbers instead of mounting partition. It only do that way at first try, 
> the second try always freezes mount program and nothing is happening.
> 
> Here are some screenshots (mount using SystemRescueCd-1.1.0 so the kernel is 
> propably 2.6.25.16):
> http://img397.imageshack.us/my.php?image=dsc01043ko6.jpg
> http://img179.imageshack.us/my.php?image=dsc01044yj4.jpg
> http://img158.imageshack.us/my.php?image=dsc01045sr3.jpg
> http://img221.imageshack.us/my.php?image=dsc01047js4.jpg
> 
> PLD Linux Th booting:
> http://img530.imageshack.us/my.php?image=dsc01048mk3.jpg
> 
> Suse booting:
> http://img87.imageshack.us/my.php?image=dsc01050as4.jpg
> Except this warning it boots normal.
> 
> Now I'm running Suse and I tried xfs_check this partition but xfs_check is 
> freezing too.
> 
> Somebody on PLD Linux mailing list told me to mail this problem here.
> 
> I'm nod subscribed to this list so please send me CC.

I'm sure there's an XFS mailing list where people are really skilled
and will surely help for such trouble, I just don't have the address
here at hand. You should search the list archives on the net (google
for "linux xfs mailing list" and check the first or second one).

In the mean time, do not modify your FS unless told to do so!

Regards,
Willy

