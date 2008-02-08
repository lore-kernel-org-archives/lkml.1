Return-Path: <linux-kernel-owner+w=401wt.eu-S1764744AbYBHWmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764744AbYBHWmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762863AbYBHWcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:32:14 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:34897 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761111AbYBHWcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:32:12 -0500
Date: Sat, 9 Feb 2008 00:32:28 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Miklos Szeredi <mszeredi@suse.cz>, jdike@addtoit.com
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: uml compile error
Message-ID: <20080208223228.GD6505@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit dd2cc4dff3b08ab54c4c177a080046bcc84ac41d broke uml:

<-- snip  -->

...
  CC      fs/hostfs/hostfs_kern.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/hostfs/hostfs_kern.c: In function ‘hostfs_show_options’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/fs/hostfs/hostfs_kern.c:328: error: dereferencing pointer to incomplete type
make[3]: *** [fs/hostfs/hostfs_kern.o] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

