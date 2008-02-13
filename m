Return-Path: <linux-kernel-owner+w=401wt.eu-S933013AbYBMW2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbYBMW2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbYBMW2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:28:40 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58427 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbYBMW2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:28:38 -0500
Date: Thu, 14 Feb 2008 00:28:22 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Miklos Szeredi <mszeredi@suse.cz>, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: uml compile error
Message-ID: <20080213222822.GA12383@cs181133002.pp.htv.fi>
References: <20080208223228.GD6505@cs181133002.pp.htv.fi> <200802132324.32114.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802132324.32114.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 11:24:31PM +0100, Rafael J. Wysocki wrote:
> On Friday, 8 of February 2008, Adrian Bunk wrote:
> > Commit dd2cc4dff3b08ab54c4c177a080046bcc84ac41d broke uml:
> > 
> > <-- snip  -->
> > 
> > ...
> >   CC      fs/hostfs/hostfs_kern.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/hostfs/hostfs_kern.c: In function ‘hostfs_show_options’:
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/hostfs/hostfs_kern.c:328: error: dereferencing pointer to incomplete type
> > make[3]: *** [fs/hostfs/hostfs_kern.o] Error 1
> > 
> > <--  snip  -->
> 
> Has it been fixed in the mainline?

Yes.

> Rafael

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

