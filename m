Return-Path: <linux-kernel-owner+w=401wt.eu-S1758884AbZCWPVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884AbZCWPVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758711AbZCWPUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:20:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36919 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758629AbZCWPUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:20:17 -0400
Date: Mon, 23 Mar 2009 16:20:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jody McIntyre <scjody@sun.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] trivial: fix bad links in the ext2 and ext3
	documentation
Message-ID: <20090323152003.GA1412@ucw.cz>
References: <20090312213922.GK8732@clouds>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312213922.GK8732@clouds>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-03-12 17:39:23, Jody McIntyre wrote:
> Trivial patch to fix bad links in the ext2 and ext3 documentation.
> 
> Signed-off-by: Jody McIntyre <scjody@sun.com>
> 
> Index: linux-2.6/Documentation/filesystems/ext2.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/filesystems/ext2.txt
> +++ linux-2.6/Documentation/filesystems/ext2.txt
> @@ -373,10 +373,10 @@ Filesystem Resizing	http://ext2resize.so
>  Compression (*)		http://e2compr.sourceforge.net/
>  
>  Implementations for:
> -Windows 95/98/NT/2000	http://uranus.it.swin.edu.au/~jn/linux/Explore2fs.htm
> -Windows 95 (*)		http://www.yipton.demon.co.uk/content.html#FSDEXT2
> +Windows 95/98/NT/2000	http://www.chrysocome.net/explore2fs
> +Windows 95 (*)		http://www.yipton.net/content.html#FSDEXT2
>  DOS client (*)		ftp://metalab.unc.edu/pub/Linux/system/filesystems/ext2/
> -OS/2			http://perso.wanadoo.fr/matthieu.willm/ext2-os2/
> -RISC OS client		ftp://ftp.barnet.ac.uk/pub/acorn/armlinux/iscafs/
> +OS/2 (*)		ftp://metalab.unc.edu/pub/Linux/system/filesystems/ext2/
> +RISC OS client		http://www.esw-heim.tu-clausthal.de/~marco/smorbrod/IscaFS/
>  
> -(*) no longer actively developed/supported (as of Apr 2001)
> +(*) no longer actively developed/supported (as of Mar 2009)

Uhuh, this removes useful  info -- the fact that win95 client is
orphaned from 2001...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
