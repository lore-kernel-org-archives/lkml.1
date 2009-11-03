Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbZKCPIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbZKCPIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 10:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZKCPID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 10:08:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbZKCPIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 10:08:02 -0500
Date: Tue, 3 Nov 2009 16:08:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Alberto Bertogli <albertito@blitiri.com.ar>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Fix fs/debugfs/inode.c typos
In-Reply-To: <1257024412-23427-1-git-send-email-albertito@blitiri.com.ar>
Message-ID: <alpine.LSU.2.00.0911031607240.9988@wotan.suse.de>
References: <1257024412-23427-1-git-send-email-albertito@blitiri.com.ar>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Oct 2009, Alberto Bertogli wrote:

> Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
> ---
>  fs/debugfs/inode.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
[ ... ]
> @@ -195,8 +195,8 @@ static int debugfs_create_by_name(const char *name, mode_t mode,
>   *        this file.
>   *
>   * This is the basic "create a file" function for debugfs.  It allows for a
> - * wide range of flexibility in createing a file, or a directory (if you
> - * want to create a directory, the debugfs_create_dir() function is
> + * wide range of flexibility in creating a file, or a directory (if you want
> + * to create a directory, the debugfs_create_dir() function is
>   * recommended to be used instead.)
>   *
>   * This function will return a pointer to a dentry if it succeeds.  This

I haven't found this one fixed in current -next, so I have put it into 
trivial queue.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
