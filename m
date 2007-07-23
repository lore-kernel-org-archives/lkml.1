Return-Path: <linux-kernel-owner+w=401wt.eu-S934723AbXGWTqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934723AbXGWTqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763425AbXGWTqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:46:30 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42558 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759895AbXGWTq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:46:29 -0400
Date: Mon, 23 Jul 2007 21:45:54 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] the next round of scheduled OSS code removal
Message-ID: <20070723194554.GR26212@stusta.de>
References: <20070723193339.GQ26212@stusta.de> <20070723194333.GM21668@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070723194333.GM21668@ftp.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 08:43:33PM +0100, Al Viro wrote:
> On Mon, Jul 23, 2007 at 09:33:39PM +0200, Adrian Bunk wrote:
> > This patch contains the next round of scheduled OSS code removal.
> 
> Er...  There are e.g. m68k dmasound drivers; with dmasound_core gone
> they won't survive, AFAICS...

Look at my patch, dmasound_core isn't gone.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

