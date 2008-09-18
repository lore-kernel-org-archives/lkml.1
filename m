Return-Path: <linux-kernel-owner+w=401wt.eu-S1757348AbYIRXs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348AbYIRXs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 19:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbYIRXsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 19:48:21 -0400
Received: from xenotime.net ([66.160.160.81]:45823 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754452AbYIRXsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 19:48:20 -0400
Date: Thu, 18 Sep 2008 16:48:17 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org
Subject: Re: mmotm 2008-09-18-14-56 uploaded (nilfs2 build error)
In-Reply-To: <200809182157.m8ILv0Vi021531@imap1.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0809181645230.18136@shark.he.net>
References: <200809182157.m8ILv0Vi021531@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-09-18-14-56 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.27-rc6:

nilfs2 build fails with

mmotm-2008-0918-1456/fs/nilfs2/inode.c: In function 'nilfs_new_inode':
mmotm-2008-0918-1456/fs/nilfs2/inode.c:283: error: 'struct task_struct' has no member named 'fsuid'
mmotm-2008-0918-1456/fs/nilfs2/inode.c:289: error: 'struct task_struct' has no member named 'fsgid'
make[3]: *** [fs/nilfs2/inode.o] Error 1

-- 
~Randy
