Return-Path: <linux-kernel-owner+w=401wt.eu-S933379AbXEEUe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbXEEUe7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933351AbXEEUe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:34:59 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49647 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933330AbXEEUe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:34:58 -0400
Date: Sat, 5 May 2007 16:31:35 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, jsipek@cs.sunysb.edu,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       unionfs@filesystems.org
Subject: Re: [-mm patch] fix unionfs compilation
Message-ID: <20070505203135.GA21420@filer.fsl.cs.sunysb.edu>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org> <20070505170012.GF8975@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070505170012.GF8975@stusta.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 07:00:12PM +0200, Adrian Bunk wrote:
> On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.21-rc7-mm2:
> >...
> >  git-unionfs.patch
> >...
> >  git trees
> >...
> 
> <--  snip  -->
> 
> ...
>   CC      fs/unionfs/super.o
> /home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/fs/unionfs/super.c: In function ‘init_once’:
> /home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/fs/unionfs/super.c:822: error: ‘SLAB_CTOR_VERIFY’ undeclared (first use in this function)
> /home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/fs/unionfs/super.c:822: error: (Each undeclared identifier is reported only once
> /home/bunk/linux/kernel-2.6/linux-2.6.21-mm1/fs/unionfs/super.c:822: error: for each function it appears in.)
> make[3]: *** [fs/unionfs/super.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Applied. Thanks.

Josef "Jeff" Sipek.

-- 
*NOTE: This message is ROT-13 encrypted twice for extra protection*
