Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab0CIRN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:13:59 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:16487 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0CIRNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:13:54 -0500
Date: Tue, 9 Mar 2010 09:13:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34-rc1
Message-Id: <20100309091313.c568ef5a.randy.dunlap@oracle.com>
In-Reply-To: <20100309162804.GB7373@atrey.karlin.mff.cuni.cz>
References: <alpine.LFD.2.00.1003081204510.3669@localhost.localdomain>
	<20100309162804.GB7373@atrey.karlin.mff.cuni.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B9681C6.019B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010 17:28:04 +0100 Jan Kara wrote:

> > It's out there now. I still have a few trees I already got pull requests 
> > for, and that I want to look over a bit more (ceph, gdb tree etc), and 
> > it's possible that I've just overlooked some other pull request.
>   It seems you haven't pulled my UDF tree (requested on Thursday -
> http://lkml.indiana.edu/hypermail/linux/kernel/1003.0/02186.html).
>   I've rebased the tree on top of 2.6.34-rc1 so could you please pull
> now?
>   The full pull request for your convenience:
> 
>   could you please pull from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus
> 
>   to get:
> 
> Akinobu Mita (1):
>       udf: use ext2_find_next_bit
> 
> Jan Kara (2):
>       udf: Fix unalloc space handling in udf_update_inode
>       udf: Do not read inode before writing it
> 
> The diffstat is
> 
>  fs/udf/balloc.c |   49 +------------------------------------------------
>  fs/udf/inode.c  |   34 +++++++++++++++++-----------------
>  2 files changed, 18 insertions(+), 65 deletions(-)


I have no objections, fwiw, but please change the $subject line...

---
~Randy
