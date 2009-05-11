Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbZEKPqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbZEKPqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbZEKPqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:46:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbZEKPqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:46:43 -0400
Date: Mon, 11 May 2009 17:46:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Sankar P <sankar.curiosity@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] Spelling fix in btrfs code comment
In-Reply-To: <1241867943.26731.5.camel@blr-psankar.blr.novell.com>
Message-ID: <alpine.LNX.2.00.0905111746100.22712@wotan.suse.de>
References: <1241867943.26731.5.camel@blr-psankar.blr.novell.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 May 2009, Sankar P wrote:

> Fix a trivial spelling error in a comment
> 
> Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
> 
> ---
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index e496644..3e2c7c7 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -312,7 +312,7 @@ btrfs_lookup_first_block_group(struct btrfs_fs_info *info, u64 bytenr)
>  }
>  
>  /*
> - * return the block group that contains teh given bytenr
> + * return the block group that contains the given bytenr
>   */
>  struct btrfs_block_group_cache *btrfs_lookup_block_group(
>  						 struct btrfs_fs_info *info,

Appplied to trivial tree. If it has been already applied to btrfs pileup, 
please let me know so that I could drop it.

Thanks,

-- 
Jiri Kosina
SUSE Labs
