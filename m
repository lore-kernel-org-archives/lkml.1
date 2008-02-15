Return-Path: <linux-kernel-owner+w=401wt.eu-S933234AbYBOJ2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbYBOJ2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 04:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933062AbYBOJ0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 04:26:53 -0500
Received: from vms040pub.verizon.net ([206.46.252.40]:56652 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932939AbYBOJ0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 04:26:48 -0500
Date: Fri, 15 Feb 2008 04:26:45 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-reply-to: <4367.1203056954@turing-police.cc.vt.edu>
To: Valdis.Kletnieks@vt.edu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org
Message-id: <200802150426.46351.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
 <200802141332.03315.gene.heskett@gmail.com>
 <4367.1203056954@turing-police.cc.vt.edu>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 February 2008, Valdis.Kletnieks@vt.edu wrote:
>On Thu, 14 Feb 2008 13:32:02 EST, Gene Heskett said:
>> Nvidia vs 2.6.25-rc1 being a case in point, and they (nvidia) are
>> appearing to indicate its not a problem until some distro actually ships a
>> kernel with the changes that broke it.  That could be months or even a
>> year plus.
>
>Actually following the NVidia forums indicates otherwise:
>
>http://www.nvnews.net/vbulletin/showthread.php?t=107144
>
>I expect Zander will be posting a patch rather soonish, for some value of
>soonish.  And if you're running a -rc or -mm kernel, patching the 169.09
>drivers should be well within your abilities....

Not so for the binaries, existing patches do make it compile but it still 
upchucks someplace in the binary, or was this time yesterday.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
It is not well to be thought of as one who meekly submits to insolence and
intimidation.
